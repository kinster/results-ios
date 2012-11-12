//
//  LeagueResultsViewController.m
//  Results
//
//  Created by Kinman Li on 06/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "LeagueResultsViewController.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "Result.h"
#import "CustomResultCell.h"
#import "ServerManager.h"

@interface LeagueResultsViewController ()

@end

@implementation LeagueResultsViewController

@synthesize resultsList, league, season, division, nameLabel, leagueBadge, subtitle, resultsTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"LeagueFixturesViewController");
    
    NSError *error;
    
    ServerManager *serverManager = [ServerManager sharedServerManager];
    NSString *serverName = [serverManager serverName];
    NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/results.json", league.leagueId, season.seasonId, division.divisionId];
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    resultsList = [[NSMutableArray alloc] init];
    Result *result = nil;
    
    
    for (NSDictionary *entry in jsonData) {
        NSString *type = [entry objectForKey:@"type"];
        NSString *dateTime = [entry objectForKey:@"date_time"];
        NSString *homeTeam = [entry objectForKey:@"home_team"];
        NSString *score = [entry objectForKey:@"score"];
        NSString *awayTeam = [entry objectForKey:@"away_team"];
        NSString *competition = [entry objectForKey:@"competition"];
        NSString *statusNote = [entry objectForKey:@"status_note"];
        
        result = [[Result alloc] initWithType:type AndDateTime:dateTime AndHomeTeam:homeTeam AndScore:score AndAwayTeam:awayTeam AndCompetition:competition AndStatusNote:statusNote];

        [resultsList addObject:result];
    }
    nameLabel.text = [NSString stringWithFormat:@"%@", league.name];
    subtitle.text = [NSString stringWithFormat:@"%@ %@", season.name, division.name];
    leagueBadge.image = league.image;
    self.tabBarController.title = @"League Results";

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [resultsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Configure the cell...
    static NSString *CellIdentifier = @"CustomResultCell";
//    CustomResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CustomResultCell *cell = [resultsTable dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[CustomResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Result *result = [resultsList objectAtIndex:indexPath.row];
    cell.date.text = result.dateTime;
    cell.homeTeam.text = result.homeTeam;
    cell.score.text = result.score;
    cell.awayTeam.text = result.awayTeam;
    
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
