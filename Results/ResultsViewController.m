//
//  ResultsViewController.m
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "ResultsViewController.h"
#import "Club.h"
#import "CustomTableCell.h"
#import "ClubDetailsViewController.h"

@interface ResultsViewController ()

@end

@implementation ResultsViewController

@synthesize clubList, leagueLogo, leagueName, clubDetailsViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    clubList = [[NSMutableArray alloc] init];
    Club *club = nil;
    
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
        for (NSDictionary *team in jsonTeams) {
            NSString *teamId = [team objectForKey:@"id"];
            NSString *wins = [team objectForKey:@"wins"];
            NSString *draws = [team objectForKey:@"draws"];
            NSString *losses = [team objectForKey:@"losses"];
            NSString *goalsFor = [team objectForKey:@"goals_for"];
            NSString *goalsAgainst = [team objectForKey:@"goals_against"];
            NSString *goalDiff = [team objectForKey:@"goal_diff"];
            NSString *points = [team objectForKey:@"points"];
            NSDictionary *clubJson = [team objectForKey:@"club"];
            NSString *badge = [clubJson objectForKey:@"badge"];
            NSString *clubName = [clubJson objectForKey:@"name"];
            NSDictionary *leagueSeasonDivision = [team objectForKey:@"league_season_division"];
            NSDictionary *leagueSeason = [leagueSeasonDivision objectForKey:@"league_season"];
            NSDictionary *league = [leagueSeason objectForKey:@"league"];
            NSDictionary *season = [leagueSeason objectForKey:@"season"];
            NSString *leagueNameJson = [league objectForKey:@"name"];
            NSString *leagueLogoJson = [league objectForKey:@"logo"];
            NSString *seasonName = [season objectForKey:@"name"];
            NSDictionary *division = [leagueSeasonDivision objectForKey:@"division"];
            NSString *divisionName = [division objectForKey:@"name"];
            NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", wins, draws, losses, goalsFor, goalsAgainst, goalDiff, points, badge, clubName, leagueNameJson, divisionName, leagueLogoJson, seasonName);
            
            NSURL *imageUrl = [NSURL URLWithString:leagueLogoJson];
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];

            leagueLogo.image = [[UIImage alloc]initWithData:imageData];

            [self setLeagueName:[leagueNameJson stringByAppendingFormat:@" %@ %@",seasonName, divisionName]];

            club = [[Club alloc] initWithName:clubName AndBadge:badge AndWins:wins AndDraws:draws AndLosses:losses AndGoalsFor:goalsFor AndGoalsAgainst:goalsAgainst AndGoalDiff:goalDiff AndPoints:points AndTeamId:teamId];
            [clubList addObject: club];

        }
    }
    [self setLeagueLogo:leagueLogo];
    NSLog(@"League set: %@ %@", leagueName, leagueLogo);
    [self loadView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [clubList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"CustomClubCell";
    
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSURL *imageUrl = [NSURL URLWithString:[[clubList objectAtIndex:indexPath.row]badge]];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    Club *club = [clubList objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.position.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    cell.badge.image = [[UIImage alloc]initWithData:imageData];
    cell.name.text = [club name];
    NSString *wins = [NSString stringWithFormat:@"%d", club.wins.intValue];
    NSString *draws = [NSString stringWithFormat:@"%d", club.draws.intValue];
    NSString *losses = [NSString stringWithFormat:@"%d", club.losses.intValue];
    NSString *goalsFor = [NSString stringWithFormat:@"%d", club.goalsFor.intValue];
    NSString *goalsAgainst = [NSString stringWithFormat:@"%d", club.goalsAgainst.intValue];
    NSString *goalDiff = [NSString stringWithFormat:@"%d", club.goalDiff.intValue];
    NSString *points = [NSString stringWithFormat:@"%d", club.points.intValue];
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
    Club *selectedClub = [clubList objectAtIndex:indexPath.row];

    if ([[segue identifier] isEqualToString:@"ShowClubDetails"]) {
        NSLog(@"%@", selectedClub.name);
        NSLog(@"%@", segue.destinationViewController);
        UITabBarController *tabBarViewController = [segue destinationViewController];
        ClubDetailsViewController *clubDetailsViewController = [tabBarViewController.viewControllers objectAtIndex:0];
        [clubDetailsViewController setTeamId:selectedClub.teamId];
//        [segue.destinationViewController setClub:selectedClub];

    } else {
//        [segue.destinationViewController setTeamId:selectedClub.teamId];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return leagueName;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSLog(@"League logo: %@", leagueLogo);
    UIImage *myImage = [UIImage imageNamed:@"garforthleague.jpg"];
    // create the imageView with the image in it
    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
    imageView.frame = CGRectMake(0,0,320,144);
    return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"In accessoryButtonTappedForRowWithIndexPath");
    NSLog(@"%d", indexPath.row);
    Club *selectedClub = [clubList objectAtIndex:indexPath.row];
    NSLog(@"%@", selectedClub.name);
    NSLog(@"%@", selectedClub.teamId);

    if (clubDetailsViewController == nil) {
        clubDetailsViewController = [[ClubDetailsViewController alloc] initWithNibName:@"ClubDetailsController" bundle:nil];
    }
    [clubDetailsViewController setTeamId:selectedClub.teamId];
    [self performSegueWithIdentifier:@"ShowClubDetails" sender:selectedClub.teamId];
}
@end
