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

@interface LeagueTableViewController ()

@end

@implementation LeagueTableViewController

@synthesize teamList, division, nameLabel, subtitle, leagueBadge, leagueTable;

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)loadData {
    @try {
        NSError *error;
        
        Season *season = [division season];
        
        ServerManager *serverManager = [ServerManager sharedServerManager];
        NSString *serverName = [serverManager serverName];
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

    [self setNavTitle];
    
    Season *season = [division season];
    League *league = [season league];
    nameLabel.text = [NSString stringWithFormat:@"%@", league.name];
    subtitle.text = [NSString stringWithFormat:@"%@ %@", season.name, division.name];
    leagueBadge.image = league.image;
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

- (void)viewWillAppear:(BOOL)animated {
    DLog(@"table appeared");
    [self setNavTitle];
    NSIndexPath *selectedIndexPath = [self.leagueTable indexPathForSelectedRow];
    [self.leagueTable deselectRowAtIndexPath:selectedIndexPath animated:YES];
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
        
        TeamDetailsViewController *teamDetailsViewController = [tabBarViewController.viewControllers objectAtIndex:0];
        [teamDetailsViewController setTeam:team];
        TeamFixturesViewController *teamFixturesController = [tabBarViewController.viewControllers objectAtIndex:1];
        [teamFixturesController setDivision:division];
        [teamFixturesController setTeam:team];
        TeamResultsViewController *teamResultsController = [tabBarViewController.viewControllers objectAtIndex:2];
        [teamResultsController setDivision:division];
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
