//
//  LeagueResultsViewController.m
//  Results
//
//  Created by Kinman Li on 06/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "LeagueResultsViewController.h"
#import "Result.h"
#import "CustomResultCell.h"

@interface LeagueResultsViewController ()

@end

@implementation LeagueResultsViewController

@synthesize resultsList, leagueId, seasonId, divisionId;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"LeagueFixturesViewController");
    
    resultsList = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSString *restfulUrl = [[NSString alloc]initWithFormat:@"http://localhost:3000/leagues/1/seasons/1/divisions/"];
    
    NSString *urlString = [restfulUrl stringByAppendingFormat:@"%d%@", 1, @"/results.json"];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"jsonResults: %@", jsonResults);
    
    for (NSDictionary *resultEntry in jsonResults) {
        
        NSString *type = [resultEntry objectForKey:@"type"];
        NSString *dateTime = [resultEntry objectForKey:@"date_time"];
        NSString *homeTeam = [resultEntry objectForKey:@"home_team"];
        NSString *score = [resultEntry objectForKey:@"score"];
        NSString *awayTeam = [resultEntry objectForKey:@"away_team"];
        NSString *competition = [resultEntry objectForKey:@"competition"];
        NSString *statusNote = [resultEntry objectForKey:@"status_note"];
        
        Result *result = [[Result alloc] initWithType:type AndDateTime:dateTime AndHomeTeam:homeTeam AndScore:score AndAwayTeam:awayTeam AndLocation:nil AndCompetition:competition AndStatusNote:statusNote];
        
        [resultsList addObject:result];
    }
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
    CustomResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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
