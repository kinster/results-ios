//
//  ClubDetailsViewController.m
//  Results
//
//  Created by Kinman Li on 25/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "TeamDetailsViewController.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "Team.h"
#import "Player.h"
#import "ServerManager.h"
#import "CustomPlayerCell.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface TeamDetailsViewController ()

@end

@implementation TeamDetailsViewController

@synthesize name, badge, team, playersTable, playersList, subtitle;

- (void)setupNavBar {
    self.parentViewController.navigationItem.title = self.navigationItem.title;
    [self.parentViewController.navigationItem setRightBarButtonItem:self.navigationItem.rightBarButtonItem];
}

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavTitle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setNavTitle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setNavTitle];

    Division *division = [team division];
    
    DLog(@"team id: %@", team.teamId);
    name.text = [team name];
    
    subtitle.text = [NSString stringWithFormat:@"%@ %@", [division season].name, division.name];

    NSURL *imageUrl = [NSURL URLWithString:team.badge];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    badge.image = [[UIImage alloc]initWithData:imageData];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.view addSubview:hud];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        @try {
            NSError *error;
            
            ServerManager *serverManager = [ServerManager sharedServerManager];
            NSString *serverName = [serverManager serverName];
            
            Division *division = [team division];
            Season *season = [division season];
            
            NSString *playersUrlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/teams/%@/players.json", [season league].leagueId, season.seasonId, division.divisionId, team.teamId];
            DLog(@"%@", playersUrlString);
            
            NSURL *playersUrl = [NSURL URLWithString:playersUrlString];
            NSData *playersData = [NSData dataWithContentsOfURL:playersUrl];
            NSArray *playersJsonData = [NSJSONSerialization JSONObjectWithData:playersData options:NSJSONReadingMutableContainers error:&error];

            playersList = [[NSMutableArray alloc] init];

            Player *player = nil;
            for (NSDictionary *playerJson in playersJsonData) {
                player = [[Player alloc] initPlayer:[playerJson objectForKey:@"name"]];
                [playersList addObject:player];
            }
            
            // done
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
            [self loadNetworkExceptionAlert];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.playersTable reloadData];
        });
    });
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setNavTitle {
    self.tabBarController.title = @"Team Details";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [playersList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomPlayerCell";
    CustomPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[CustomPlayerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Player *player = [playersList objectAtIndex:indexPath.row];
 
    cell.numberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    cell.nameLabel.text = [player name];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// open a alert with an OK and cancel button
//    Player *player = [playersList objectAtIndex:indexPath.row];
//	NSString *alertString = [NSString stringWithFormat:@"Clicked on %@", [player name]];
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
//	[alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
