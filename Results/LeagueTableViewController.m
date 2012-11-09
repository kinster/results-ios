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

@interface LeagueTableViewController ()

@end

@implementation LeagueTableViewController

@synthesize teamList, leagueLogo, leagueName, leagueSeasonDivisionId, leagueLogoUrl, leagueId, seasonId, divisionId;

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSError *error;
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* jsonServer = [infoDict objectForKey:@"jsonServer"];
    NSString *urlString = [jsonServer stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@.json", leagueId, seasonId, divisionId];
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
        NSLog(@"pos: %@", position);
        NSLog(@"gf: %@", gf);
        
        team = [[Team alloc] initWithTeam:name AndPosition:position AndPlayed:played AndWins:wins AndDraws:draws AndLosses:losses AndGoalsFor:gf AndGoalsAgainst:ga AndGoalDiff:gd AndPoints:points AndId:teamId];
        [teamList addObject: team];

    }

    [self loadView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [teamList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"CustomTableCell";
    
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (leagueLogo == nil) {
        NSLog(@"League Logo is NIL");
    } else {
        [self.tableView setTableHeaderView: leagueLogo];
    }
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"In prepareForSegue");
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%d", indexPath.row);
    Team *team = [teamList objectAtIndex:indexPath.row];
    UITabBarController *tabBarViewController = [segue destinationViewController];

    if ([[segue identifier] isEqualToString:@"ShowTeamDetails"]) {
        TeamDetailsViewController *teamDetailsViewController = [tabBarViewController.viewControllers objectAtIndex:0];
        NSLog(@"%@", teamDetailsViewController.class);
        [teamDetailsViewController setLeagueId:leagueId];
        [teamDetailsViewController setSeasonId:seasonId];
        [teamDetailsViewController setDivisionId:divisionId];
        [teamDetailsViewController setTeamId:team.teamId];
        NSLog(@"Team Fixtures");
        TeamFixturesViewController *teamFixturesController = [tabBarViewController.viewControllers objectAtIndex:1];
        [teamFixturesController setLeagueId:leagueId];
        [teamFixturesController setSeasonId:seasonId];
        [teamFixturesController setDivisionId:divisionId];
        [teamFixturesController setTeamId:team.teamId];
        NSLog(@"LeagueTableViewController %@ %@ %@ %@", leagueId, seasonId, divisionId, team.teamId);

    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return leagueName;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSLog(@"viewForHeaderInSection League logo: %@", leagueLogoUrl);
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
