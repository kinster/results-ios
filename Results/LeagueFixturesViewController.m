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

@synthesize leagueSeasonDivisionId, fixtureList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"LeagueFixturesViewController");
    
    fixtureList = [[NSMutableArray alloc] init];

    NSError *error;
    
    NSString *restfulUrl = [[NSString alloc]initWithFormat:@"http://localhost:3000/leagues/1/seasons/1/divisions/"];
    
    NSString *urlString = [restfulUrl stringByAppendingFormat:@"%d%@", 1, @"/fixtures.json"];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *jsonFixtures = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"jsonFixtures: %@", jsonFixtures);
    
    for (NSDictionary *fixtureEntry in jsonFixtures) {

        NSString *type = [fixtureEntry objectForKey:@"type"];
        NSString *dateTime = [fixtureEntry objectForKey:@"date_time"];
        NSString *homeTeam = [fixtureEntry objectForKey:@"home_team"];
        NSString *awayTeam = [fixtureEntry objectForKey:@"away_team"];
        NSString *location = [fixtureEntry objectForKey:@"location"];
        NSString *competition = [fixtureEntry objectForKey:@"competition"];
        NSString *statusNote = [fixtureEntry objectForKey:@"status_note"];

//        NSString *fixtureIdJson = [fixtureEntry objectForKey:@"id"];
//
//        NSString *dateJson = [fixtureEntry objectForKey:@"date_short"];
//        NSString *timeJson = [fixtureEntry objectForKey:@"time_short"];
//        NSString *locationJson = [fixtureEntry objectForKey:@"location"];
//
//        NSDictionary *homeTeamJson = [fixtureEntry objectForKey:@"home_club_team"];
//        NSDictionary *homeClubJson = [homeTeamJson objectForKey:@"club"];
//        NSString *homeBadge = [homeClubJson objectForKey:@"badge"];
//        NSString *homeName = [homeClubJson objectForKey:@"name"];
//        
//        NSDictionary *awayTeamJson = [fixtureEntry objectForKey:@"away_club_team"];
//        NSDictionary *awayClubJson = [awayTeamJson objectForKey:@"club"];
//        NSString *awayBadge = [awayClubJson objectForKey:@"badge"];
//        NSString *awayName = [awayClubJson objectForKey:@"name"];
//
//        Team *homeTeam = [[Team alloc] initWithClubName:homeName AndClubBadge:homeBadge];
//        Team *awayTeam = [[Team alloc] initWithClubName:awayName AndClubBadge:awayBadge];

//        Fixture *fixture = [[Fixture alloc] initWithIdDateTimeLocationHomeAway:fixtureIdJson AndDate:dateJson AndTime:timeJson AndLocation:locationJson AndHomeTeam:homeTeam andAwayTeam:awayTeam];
        
        Fixture *fixture = [[Fixture alloc] initWithType:type AndDateTime:dateTime AndHomeTeam:homeTeam AndAwayTeam:awayTeam AndLocation:location AndCompetition:competition AndStatusNote:statusNote];
        
        [fixtureList addObject:fixture];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [fixtureList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomFixtureCell";
    CustomFixtureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[CustomFixtureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    Fixture *fixture = [fixtureList objectAtIndex:indexPath.row];
    cell.homeTeam.text = fixture.hTeam;
    cell.awayTeam.text = fixture.aTeam;
    cell.date.text = fixture.dateTime;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%d", indexPath.row);
    Fixture *fixture = [fixtureList objectAtIndex:indexPath.row];
    LeagueFixtureDetailsViewController *destinationController = [segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"ShowLeagueFixtureDetails"]) {
        NSLog(@"Fixture id: %@", fixture.fixtureId);
        NSLog(@"%@", segue.destinationViewController);

        [destinationController setFixtureId:fixture.fixtureId];
    }
}

@end
