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

@interface LeagueTableViewController ()

@end

@implementation LeagueTableViewController

@synthesize teamList, leagueLogo, leagueName, leagueSeasonDivisionId, leagueLogoUrl;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    teamList = [[NSMutableArray alloc] init];
    Team *team = nil;
    
    NSError *error;

    NSString *urlString = [NSString stringWithFormat:@"http://localhost:3000/leagues/1/seasons/1/divisions/1.json"];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];

    NSDictionary *jsonTeams = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (!jsonTeams) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"How many? %d", [jsonTeams count]);
        for (NSDictionary *teamJson in jsonTeams) {
            NSString *teamId = [teamJson objectForKey:@"id"];
            NSString *played = [teamJson objectForKey:@"played"];
            NSString *wins = [teamJson objectForKey:@"wins"];
            NSString *draws = [teamJson objectForKey:@"draws"];
            NSString *losses = [teamJson objectForKey:@"losses"];
            NSString *goalsFor = [teamJson objectForKey:@"goals_for"];
            NSString *goalsAgainst = [teamJson objectForKey:@"goals_against"];
            NSString *goalDiff = [teamJson objectForKey:@"goal_diff"];
            NSString *points = [teamJson objectForKey:@"points"];
            NSDictionary *clubJson = [teamJson objectForKey:@"club"];
            NSString *clubBadge = [clubJson objectForKey:@"badge"];
            NSString *clubName = [clubJson objectForKey:@"name"];
            NSDictionary *leagueSeasonDivision = [teamJson objectForKey:@"league_season_division"];
            NSDictionary *leagueSeason = [leagueSeasonDivision objectForKey:@"league_season"];
            NSDictionary *league = [leagueSeason objectForKey:@"league"];
            NSDictionary *season = [leagueSeason objectForKey:@"season"];
            NSString *leagueNameJson = [league objectForKey:@"name"];
            NSString *leagueLogoJson = [league objectForKey:@"logo"];
            NSString *seasonName = [season objectForKey:@"name"];
            NSDictionary *division = [leagueSeasonDivision objectForKey:@"division"];
            NSString *divisionName = [division objectForKey:@"name"];
            NSInteger leagueSeasonDivisionIdJson = [[leagueSeasonDivision objectForKey:@"id"] integerValue];
            [self setLeagueSeasonDivisionId:leagueSeasonDivisionIdJson];
            NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", wins, draws, losses, goalsFor, goalsAgainst, goalDiff, points, clubBadge, clubName, leagueNameJson, divisionName, leagueLogoJson, seasonName);
            
            NSLog(@"league logo:%@", leagueLogoJson);
            [self setLeagueLogoUrl:leagueLogoJson];
//            NSURL *imageUrl = [NSURL URLWithString:leagueLogoJson];
//            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
//
//            leagueLogo.image = [[UIImage alloc]initWithData:imageData];

            [self setLeagueName:[leagueNameJson stringByAppendingFormat:@" %@ %@",seasonName, divisionName]];

            team = [[Team alloc] initWithClubName:clubName AndClubBadge:clubBadge AndPlayed:played AndWins:wins AndDraws:draws AndLosses:losses AndGoalsFor:goalsFor AndGoalsAgainst:goalsAgainst AndGoalDiff:goalDiff AndPoints:points AndTeamId:teamId];
            [teamList addObject: team];

        }
    }
//    [self setLeagueLogo:leagueLogo];
    NSLog(@"League set: %@ %@", leagueName, leagueLogo);
//    NSURL *imageUrl = [NSURL URLWithString:leagueLogoUrl];
//    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
//    UIImage *image = [[UIImage alloc]initWithData:imageData];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//    [self setLeagueLogo:imageView];
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
//    NSURL *imageUrl = [NSURL URLWithString:[[teamList objectAtIndex:indexPath.row]clubBadge]];
//    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    Team *team = [teamList objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.position.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
//    cell.badge.image = [[UIImage alloc]initWithData:imageData];
    cell.team.text = [team clubName];
    NSString *played = [NSString stringWithFormat:@"%d", team.played.intValue];
    NSString *wins = [NSString stringWithFormat:@"%d", team.wins.intValue];
    NSString *draws = [NSString stringWithFormat:@"%d", team.draws.intValue];
    NSString *losses = [NSString stringWithFormat:@"%d", team.losses.intValue];
    NSString *goalsFor = [NSString stringWithFormat:@"%d", team.goalsFor.intValue];
    NSString *goalsAgainst = [NSString stringWithFormat:@"%d", team.goalsAgainst.intValue];
    NSString *goalDiff = [NSString stringWithFormat:@"%d", team.goalDiff.intValue];
    NSString *points = [NSString stringWithFormat:@"%d", team.points.intValue];
    cell.played.text = played;
    cell.wins.text = wins;
    cell.draws.text = draws;
    cell.losses.text = losses;
    cell.goalsFor.text = goalsFor;
    cell.goalsAgainst.text = goalsAgainst;
    cell.goalDiff.text = goalDiff;
    cell.points.text = points;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"In prepareForSegue");
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%d", indexPath.row);
    Team *team = [teamList objectAtIndex:indexPath.row];
    UINavigationController *navigationController = [segue destinationViewController];
    UITabBarController *tabBarViewController = [navigationController.viewControllers objectAtIndex:0];

    if ([[segue identifier] isEqualToString:@"ShowTeamDetails"]) {
        NSLog(@"%@", team.clubName);
        NSLog(@"%@", segue.destinationViewController);
        TeamDetailsViewController *teamDetailsViewController = [tabBarViewController.viewControllers objectAtIndex:0];
        [teamDetailsViewController setTeamId:team.teamId];
    } else if ([[segue identifier] isEqualToString:@"ShowTeamFixtures"]) {
        NSLog(@"Team Fixtures");
        TeamDetailsViewController *teamDetailsViewController = [tabBarViewController.viewControllers objectAtIndex:1];
        [teamDetailsViewController setTeamId:team.teamId];
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
