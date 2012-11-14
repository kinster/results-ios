//
//  TeamFixturesViewController.m
//  Results
//
//  Created by Kinman Li on 09/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "TeamFixturesViewController.h"
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

@synthesize fixtureList, league, season, division, team, leagueBadge, nameLabel, subtitle,teamFixturesTable;

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"TeamFixturesViewController");
    
    NSLog(@"Fixtures badge: %@", team.badge);
    NSURL *imageUrl = [NSURL URLWithString:team.badge];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    leagueBadge.image = [[UIImage alloc]initWithData:imageData];
    
    nameLabel.text = [team name];
    
    subtitle.text = [NSString stringWithFormat:@"%@ %@", season.name, division.name];
    
    [self setNavTitle];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        @try {
            NSError *error;
            
            ServerManager *serverManager = [ServerManager sharedServerManager];
            NSString *serverName = [serverManager serverName];
            NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/teams/%@/fixtures.json", league.leagueId, season.seasonId, division.divisionId, team.teamId];
            NSLog(@"%@", urlString);
            
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
                
                fixture = [[Fixture alloc] initWithType:type AndDateTime:dateTime AndHomeTeam:homeTeam AndAwayTeam:awayTeam AndLocation:location AndCompetition:competition AndStatusNote:statusNote];
                
                [fixtureList addObject:fixture];
            }
            // done
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.teamFixturesTable reloadData];
        });
    });

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setNavTitle {
    self.tabBarController.title = @"Team Fixtures";
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"table appeared");
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
