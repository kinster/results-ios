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
    
    // current garforth league U11s 9v9 hard coded
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
            NSString *position = [teamJson objectForKey:@"position"];
            NSString *name = [teamJson objectForKey:@"name"];
            NSString *played = [teamJson objectForKey:@"played"];
            NSString *wins = [teamJson objectForKey:@"wins"];
            NSString *draws = [teamJson objectForKey:@"draws"];
            NSString *losses = [teamJson objectForKey:@"losses"];
            NSString *points = [teamJson objectForKey:@"points"];
            NSString *gf = [teamJson objectForKey:@"gf"];
            NSString *ga = [teamJson objectForKey:@"ga"];
            NSString *gd = [teamJson objectForKey:@"gd"];
            NSLog(@"pos: %@", position);
            NSLog(@"gf: %@", gf);

//            NSString *teamId = [teamJson objectForKey:@"id"];
//            NSString *played = [teamJson objectForKey:@"played"];
//            NSString *wins = [teamJson objectForKey:@"wins"];
//            NSString *draws = [teamJson objectForKey:@"draws"];
//            NSString *losses = [teamJson objectForKey:@"losses"];
//            NSString *goalsFor = [teamJson objectForKey:@"goals_for"];
//            NSString *goalsAgainst = [teamJson objectForKey:@"goals_against"];
//            NSString *goalDiff = [teamJson objectForKey:@"goal_diff"];
//            NSString *points = [teamJson objectForKey:@"points"];
//            NSDictionary *clubJson = [teamJson objectForKey:@"club"];
//            NSString *clubBadge = [clubJson objectForKey:@"badge"];
//            NSString *clubName = [clubJson objectForKey:@"name"];
//            NSDictionary *leagueSeasonDivision = [teamJson objectForKey:@"league_season_division"];
//            NSDictionary *leagueSeason = [leagueSeasonDivision objectForKey:@"league_season"];
//            NSDictionary *league = [leagueSeason objectForKey:@"league"];
//            NSDictionary *season = [leagueSeason objectForKey:@"season"];
//            NSString *leagueNameJson = [league objectForKey:@"name"];
//            NSString *leagueLogoJson = [league objectForKey:@"logo"];
//            NSString *seasonName = [season objectForKey:@"name"];
//            NSDictionary *division = [leagueSeasonDivision objectForKey:@"division"];
//            NSString *divisionName = [division objectForKey:@"name"];
//            NSInteger leagueSeasonDivisionIdJson = [[leagueSeasonDivision objectForKey:@"id"] integerValue];
//            [self setLeagueSeasonDivisionId:leagueSeasonDivisionIdJson];
//            NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", wins, draws, losses, goalsFor, goalsAgainst, goalDiff, points, clubBadge, clubName, leagueNameJson, divisionName, leagueLogoJson, seasonName);
//            
//            NSLog(@"league logo:%@", leagueLogoJson);
//            [self setLeagueLogoUrl:leagueLogoJson];
//
//
//            [self setLeagueName:[leagueNameJson stringByAppendingFormat:@" %@ %@",seasonName, divisionName]];

//            team = [[Team alloc] initWithClubName:name AndClubBadge:nil AndPlayed:played AndWins:wins AndDraws:draws AndLosses:losses AndGoalsFor:gf AndGoalsAgainst:ga AndGoalDiff:gd AndPoints:points AndTeamId:nil];
            
            team = [[Team alloc] initWithTeamName:name AndPosition:position AndPlayed:played AndWins:wins AndDraws:draws AndLosses:losses AndGoalsFor:gf AndGoalsAgainst:ga AndGoalDiff:gd AndPoints:points];
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
//    cell.badge.image = [[UIImage alloc]initWithData:imageData];
//    NSString *wins = [NSString stringWithFormat:@"%d", team.wins.intValue];
//    NSString *draws = [NSString stringWithFormat:@"%d", team.draws.intValue];
//    NSString *losses = [NSString stringWithFormat:@"%d", team.losses.intValue];
//    NSString *goalsFor = [NSString stringWithFormat:@"%d", team.goalsFor.intValue];
//    NSString *goalsAgainst = [NSString stringWithFormat:@"%d", team.goalsAgainst.intValue];
//    NSString *goalDiff = [NSString stringWithFormat:@"%d", team.goalDiff.intValue];
//    NSString *points = [NSString stringWithFormat:@"%d", team.points.intValue];
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
