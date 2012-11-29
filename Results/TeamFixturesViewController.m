//
//  TeamFixturesViewController.m
//  Results
//
//  Created by Kinman Li on 09/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "TeamFixturesViewController.h"
#import "LeagueFixtureDetailsViewController.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "Team.h"
#import "Fixture.h"
#import "CustomFixtureCell.h"
#import "ServerManager.h"
#import "MBProgressHUD.h"

@interface TeamFixturesViewController ()

@end

@implementation TeamFixturesViewController

@synthesize fixtureList, team, leagueBadge, nameLabel, subtitle, teamFixturesTable;

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)loadData {
    @try {
        NSError *error;
        
        Division *division = [team division];
        Season *season = [division season];

        ServerManager *serverManager = [ServerManager sharedServerManager];
        NSString *serverName = [serverManager serverName];
        NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/teams/%@/fixtures.json", [season league].leagueId, season.seasonId, division.divisionId, team.teamId];
        DLog(@"%@", urlString);
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        fixtureList = [[NSMutableArray alloc] init];
        Fixture *fixture = nil;
        
        for (NSDictionary *entry in jsonData) {
            
            NSString *type = [entry objectForKey:@"type"];
            NSString *dateTime = [entry objectForKey:@"date_time"];
            NSString *homeTeam = [entry objectForKey:@"home_team"];
            NSString *awayTeam = [entry objectForKey:@"away_team"];
            NSString *location = [entry objectForKey:@"location"];
            NSString *competition = [entry objectForKey:@"competition"];
            NSString *statusNote = [entry objectForKey:@"status_note"];
            NSString *fixtureId = [entry objectForKey:@"fixture_id"];
            
            fixture = [[Fixture alloc] initWithType:type AndDateTime:dateTime AndHomeTeam:homeTeam AndAwayTeam:awayTeam AndLocation:location AndCompetition:competition AndStatusNote:statusNote AndFixtureId:fixtureId];
            [fixture setDivision:division];
            [fixtureList addObject:fixture];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
        [self loadNetworkExceptionAlert];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    DLog(@"TeamFixturesViewController");
    
    DLog(@"Fixtures badge: %@", team.badge);
    NSURL *imageUrl = [NSURL URLWithString:team.badge];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    leagueBadge.image = [[UIImage alloc]initWithData:imageData];
    
    nameLabel.text = [team name];
    Division *division = [team division];
    subtitle.text = [NSString stringWithFormat:@"%@ %@", [division season].name, division.name];
    
    [self setNavTitle];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.teamFixturesTable reloadData];
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
            [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
            [self.teamFixturesTable addSubview:refreshControl];

        });
    });

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)refreshView:(UIRefreshControl *)refresh {
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        DLog(@"refreshing");
        refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
        
        // custom refresh logic would be placed here...
        [self loadData];
        [self.teamFixturesTable reloadData];
        
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
    self.tabBarController.title = @"Team Fixtures";
}

- (void)viewWillAppear:(BOOL)animated {
    DLog(@"table appeared");
    [self setNavTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [fixtureList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomFixtureCell";
    CustomFixtureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomFixtureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Fixture *fixture = [fixtureList objectAtIndex:indexPath.row];
    cell.homeTeam.text = fixture.homeTeam;
    cell.awayTeam.text = fixture.awayTeam;
    cell.date.text = fixture.dateTime;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DLog(@"In prepareForSegue");
    
    NSIndexPath *indexPath = [self.teamFixturesTable indexPathForSelectedRow];
    DLog(@"%d", indexPath.row);
    Fixture *fixture = [fixtureList objectAtIndex:indexPath.row];
    LeagueFixtureDetailsViewController *destinationController = [segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"ShowFixtureDetails"]) {
        DLog(@"Fixture location: %@", fixture.location);
        DLog(@"%@", segue.destinationViewController);
        [destinationController setFixture:fixture];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
