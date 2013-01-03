//
//  ResultsViewController.m
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "LeagueTableViewController.h"
#import "Team.h"
#import "CustomTableCell.h"
#import "TeamDetailsViewController.h"
#import "TeamFixturesViewController.h"
#import "TeamResultsViewController.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "ServerManager.h"
#import "MBProgressHUD.h"
#import "LeaguesViewController.h"
#import "AppDelegate.h"

@interface LeagueTableViewController ()

@end

@implementation LeagueTableViewController

@synthesize teamList, division, nameLabel, subtitle, leagueBadge, leagueTable, adBannerView;

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)loadData {
    @try {
        NSError *error;
        
        ServerManager *serverManager = [ServerManager sharedServerManager];
        NSString *serverName = [serverManager serverName];
        
        Season *season = [division season];
        NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@.json", [season league].leagueId, season.seasonId, division.divisionId];
        DLog(@"%@", urlString);
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        teamList = [[NSMutableArray alloc] init];
        Team *team = nil;
        
        for (NSDictionary *entry in jsonData) {
            NSString *position = [entry objectForKey:@"position"];
            NSString *name = [entry objectForKey:@"name"];
            NSString *played = [entry objectForKey:@"played"];
            NSString *wins = [entry objectForKey:@"wins"];
            NSString *draws = [entry objectForKey:@"draws"];
            NSString *losses = [entry objectForKey:@"losses"];
            NSString *points = [entry objectForKey:@"points"];
            NSString *gf = [entry objectForKey:@"gf"];
            NSString *ga = [entry objectForKey:@"ga"];
            NSString *gd = [entry objectForKey:@"gd"];
            NSString *teamId = [entry objectForKey:@"id"];
            
            team = [[Team alloc] initWithTeam:name AndPosition:position AndPlayed:played AndWins:wins AndDraws:draws AndLosses:losses AndGoalsFor:gf AndGoalsAgainst:ga AndGoalDiff:gd AndPoints:points AndTeamId:teamId AndBadge:nil];
            [team setDivision:division];
            [teamList addObject: team];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
        [self loadNetworkExceptionAlert];
        return;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    DLog(@"LeagueTableViewController");

    adBannerView.delegate = self;
    adBannerView.hidden = YES;

    [self setNavTitle];
    
    Season *season = [division season];
    
    nameLabel.text = [NSString stringWithFormat:@"%@", [season league].name];
    subtitle.text = [NSString stringWithFormat:@"%@ %@", season.name, division.name];
    leagueBadge.image = [season league].image;
    DLog(@"%@", self.nameLabel.text);

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.leagueTable reloadData];
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
            [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
            [self.leagueTable addSubview:refreshControl];
        });
    });        
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    DLog(@"bannerViewDidLoadAd loaded %d", banner.isBannerLoaded);
    banner.hidden = NO;
    [self toggleBanner:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    DLog(@"didFailToReceiveAdWithError loaded %d", banner.isBannerLoaded);
    banner.hidden = YES;
    [self toggleBanner:banner];
}

- (void)toggleBanner:(ADBannerView *)banner {
    CGRect bannerFrame = banner.frame;
    CGRect contentFrame = self.view.frame;
    DLog(@"Content height %f %@", contentFrame.size.height, banner);
    if ([banner isBannerLoaded]) {
        DLog(@"Has ad, showing");
        contentFrame.size.height -= banner.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        DLog(@"No ad, hiding");
        bannerFrame.origin.y = contentFrame.size.height;
    }
    banner.frame = bannerFrame;
    self.leagueTable.frame = CGRectMake(leagueTable.frame.origin.x,leagueTable.frame.origin.y,leagueTable.frame.size.width,contentFrame.size.height-banner.frame.size.height-(bannerFrame.size.height+10));
    
    DLog(@"New content height %@ %f %f %f %f %f", banner, contentFrame.size.height, banner.frame.origin.y, adBannerView.frame.origin.y, leagueTable.frame.size.height, leagueTable.contentSize.height);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setAdBannerView:AppDelegate.adBannerView];
    DLog(@"LeagueDivisionsViewController viewWillAppear %@", self.adBannerView);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNavTitle];
    [self setAdBannerView:AppDelegate.adBannerView];
    DLog(@"viewDidAppear %@", adBannerView);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    [self.adBannerView removeFromSuperview];
    DLog(@"LeagueDivisionsViewController viewWillDisappear %@", self.adBannerView);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    [self.adBannerView removeFromSuperview];
    DLog(@"LeagueDivisionsViewController viewDidDisappear %@", self.adBannerView);
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    [self setLeagueTable:nil];
    DLog(@"LeagueDivisionsViewController viewDidUnload %@", self.adBannerView);
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)refreshView:(UIRefreshControl *)refresh {

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    
        DLog(@"refreshing");
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
        
        // custom refresh logic would be placed here...
        [self loadData];
        [self.leagueTable reloadData];

        dispatch_async(dispatch_get_main_queue(), ^{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, hh:mm a"];
            NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
                                     [formatter stringFromDate:[NSDate date]]];
            
            refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];

            [refresh endRefreshing];
            DLog(@"refreshed");
        });
    });
}

- (void)setNavTitle {
    self.tabBarController.title = @"League Table";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [teamList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"CustomTableCell";
    
    CustomTableCell *cell = [leagueTable dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    Team *team = [teamList objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.position.text = [team position];
    cell.team.text = [team name];
    cell.played.text = [team played];
    cell.wins.text = [team wins];
    cell.draws.text = [team draws];
    cell.losses.text = [team losses];
    cell.goalsFor.text = [team goalsFor];
    cell.goalsAgainst.text = [team goalsAgainst];
    cell.goalDiff.text = [team goalDiff];
    cell.points.text = [team points];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DLog(@"In prepareForSegue");
    if ([[segue identifier] isEqualToString:@"ShowTeamDetails"]) {
        NSIndexPath *indexPath = [self.leagueTable indexPathForSelectedRow];
        Team *team = [teamList objectAtIndex:indexPath.row];
        UITabBarController *tabBarViewController = [segue destinationViewController];
        
        DLog(@"Team: %@ - %d %d", team.name, indexPath.row, teamList.count);
        TeamDetailsViewController *teamDetailsViewController = [tabBarViewController.viewControllers objectAtIndex:0];
        [teamDetailsViewController setTeam:team];

        @try {
            
            NSError *error;
            ServerManager *serverManager = [ServerManager sharedServerManager];
            NSString *serverName = [serverManager serverName];
            
            Season *season = [division season];
            NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/teams/%@.json", [season league].leagueId, season.seasonId, division.divisionId, team.teamId];
            DLog(@"%@", urlString);
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            DLog(@"%@", jsonData);
            NSString *image = [jsonData[0] objectForKey:@"image_url"];
            team.badge = image;
            DLog(@"image: %@", image);
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
            [self loadNetworkExceptionAlert];
        }
        [teamDetailsViewController setTeam:team];
        TeamFixturesViewController *teamFixturesController = [tabBarViewController.viewControllers objectAtIndex:1];
        [teamFixturesController setTeam:team];
        TeamResultsViewController *teamResultsController = [tabBarViewController.viewControllers objectAtIndex:2];
        [teamResultsController setTeam:team];
    }
    DLog(@"end of prepareForSegue");
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return nil;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    NSURL *imageUrl = [NSURL URLWithString:leagueLogoUrl];
//    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];    
//    UIImage *image = [[UIImage alloc]initWithData:imageData];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"In accessoryButtonTappedForRowWithIndexPath");
//    NSLog(@"%d", indexPath.row);
//    Team *team = [teamList objectAtIndex:indexPath.row];
//    NSLog(@"%@", team.clubName);
//    NSLog(@"%@", team.teamId);

//    if (teamDetailsViewController == nil) {
//        teamDetailsViewController = [[TeamDetailsViewController alloc] initWithNibName:@"ClubDetailsController" bundle:nil];
//    }
//    [teamDetailsViewController setTeamId:team.teamId];
//    [self performSegueWithIdentifier:@"ShowTeamDetails" sender:team.teamId];
}
@end
