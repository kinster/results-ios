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

@interface LeagueTableViewController ()

@end

@implementation LeagueTableViewController

@synthesize teamList, league, season, division, nameLabel, subtitle, leagueBadge, leagueTable;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSError *error;
    
    ServerManager *serverManager = [ServerManager sharedServerManager];
    NSString *serverName = [serverManager serverName];
    NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@.json", league.leagueId, season.seasonId, division.divisionId];
    NSLog(@"%@", urlString);
    
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
        [teamList addObject: team];

    }
    nameLabel.text = [NSString stringWithFormat:@"%@", league.name];
    subtitle.text = [NSString stringWithFormat:@"%@ %@", season.name, division.name];
    leagueBadge.image = league.image;
    NSLog(@"%@", self.nameLabel.text);
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
    NSLog(@"In prepareForSegue");
    
    NSIndexPath *indexPath = [self.leagueTable indexPathForSelectedRow];
    Team *team = [teamList objectAtIndex:indexPath.row];
    UITabBarController *tabBarViewController = [segue destinationViewController];

    NSLog(@"Team: %@ - %d %d", team.name, indexPath.row, teamList.count);
    if ([[segue identifier] isEqualToString:@"ShowTeamDetails"]) {
        TeamDetailsViewController *teamDetailsViewController = [tabBarViewController.viewControllers objectAtIndex:0];
        [teamDetailsViewController setLeague:league];
        [teamDetailsViewController setSeason:season];
        [teamDetailsViewController setDivision:division];
        [teamDetailsViewController setTeam:team];
        TeamFixturesViewController *teamFixturesController = [tabBarViewController.viewControllers objectAtIndex:1];
        [teamFixturesController setLeague:league];
        [teamFixturesController setSeason:season];
        [teamFixturesController setDivision:division];
        [teamFixturesController setTeam:team];
        TeamResultsViewController *teamResultsController = [tabBarViewController.viewControllers objectAtIndex:2];
        [teamResultsController setLeague:league];
        [teamResultsController setSeason:season];
        [teamResultsController setDivision:division];
        [teamResultsController setTeam:team];
    }
    NSLog(@"end of prepareForSegue");
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
