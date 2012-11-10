//
//  FixturesViewController.m
//  Results
//
//  Created by Kinman Li on 02/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "LeagueFixturesViewController.h"
#import "LeagueFixtureDetailsViewController.h"
#import "Team.h"
#import "Fixture.h"
#import "CustomFixtureCell.h"

@interface LeagueFixturesViewController ()

@end


@implementation LeagueFixturesViewController

@synthesize fixtureList, leagueId, seasonId, divisionId;

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

    NSError *error;
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* jsonServer = [infoDict objectForKey:@"jsonServer"];
    NSString *urlString = [jsonServer stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/fixtures.json", leagueId, seasonId, divisionId];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"In prepareForSegue");
    
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    NSLog(@"%d", indexPath.row);
//    Fixture *fixture = [fixtureList objectAtIndex:indexPath.row];
//    LeagueFixtureDetailsViewController *destinationController = [segue destinationViewController];
//    
//    if ([[segue identifier] isEqualToString:@"ShowLeagueFixtureDetails"]) {
//        NSLog(@"Fixture id: %@", fixture.fixtureId);
//        NSLog(@"%@", segue.destinationViewController);
//
//        [destinationController setFixtureId:fixture.fixtureId];
//    }
}

@end
