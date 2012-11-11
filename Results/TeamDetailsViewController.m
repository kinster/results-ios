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

@interface TeamDetailsViewController ()

@end

@implementation TeamDetailsViewController

@synthesize position, name, badge, league, season, division, team, navBar, playersTable, playersList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Team Details";
    navBar.title = @"Team Details";
    
    NSError *error;
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* jsonServer = [infoDict objectForKey:@"jsonServer"];
    NSString *urlString = [jsonServer stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/teams/%@.json", league.leagueId, season.seasonId, division.divisionId, team.teamId];
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    NSLog(@"%@", jsonData);
    

    NSString *image = [jsonData[0] objectForKey:@"image_url"];
    NSLog(@"image: %@", image);
    
    NSURL *imageUrl = [NSURL URLWithString:image];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    badge.image = [[UIImage alloc]initWithData:imageData];
    
    name.text = [team name];

    NSString *playersUrlString = [jsonServer stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/teams/%@/players.json", league.leagueId, season.seasonId, division.divisionId, team.teamId];
    NSLog(@"%@", playersUrlString);
    
    NSURL *playersUrl = [NSURL URLWithString:playersUrlString];
    NSData *playersData = [NSData dataWithContentsOfURL:playersUrl];
    NSArray *playersJsonData = [NSJSONSerialization JSONObjectWithData:playersData options:NSJSONReadingMutableContainers error:&error];

    playersList = [[NSMutableArray alloc] init];

    Player *player = nil;
    for (NSDictionary *playerJson in playersJsonData) {
        player = [[Player alloc] initPlayer:[playerJson objectForKey:@"name"]];
        [playersList addObject:player];
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [playersList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"PlayerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    NSLog(@"Players count in cell: %d", [playersList count]);

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Player *player = [playersList objectAtIndex:indexPath.row];
    NSLog(@"Player in cell: %@", player.name);
 
    cell.textLabel.text = [NSString stringWithFormat:@"%d) %@", indexPath.row+1, player.name];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// open a alert with an OK and cancel button
    Player *player = [playersList objectAtIndex:indexPath.row];
	NSString *alertString = [NSString stringWithFormat:@"Clicked on %@", [player name]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
	[alert show];
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
