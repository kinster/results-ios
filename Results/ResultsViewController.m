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

@synthesize clubList, leagueLogo, leagueName;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    clubList = [[NSMutableArray alloc] init];
    Club *club = nil;
    
    NSError *error;

    NSString *urlString = [NSString stringWithFormat:@"http://localhost:3000/league_season_teams/1.json"];
    
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];

    NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (!jsonObjects) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"How many? %d", [jsonObjects count]);
        NSDictionary *jsonLeagueSeason = [jsonObjects objectForKey:@"league_season"];
        NSDictionary *league = [jsonLeagueSeason objectForKey:@"league"];
        NSDictionary *jsonSeason = [jsonLeagueSeason objectForKey:@"season"];
        NSString *seasonNameJson = [jsonSeason objectForKey:@"name"];
        NSString *leagueLogoJson = [league objectForKey:@"logo"];
        NSString *leagueNameJson = [league objectForKey:@"name"];

        NSDictionary *jsonTeam = [jsonObjects objectForKey:@"team"];
        NSString *teamName = [jsonTeam objectForKey:@"name"];

        NSURL *imageUrl = [NSURL URLWithString:leagueLogoJson];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
        
        leagueLogo.image = [[UIImage alloc]initWithData:imageData];
        
        [self setLeagueName:[leagueNameJson stringByAppendingFormat:@" %@ %@",seasonNameJson, teamName]];
        
        NSLog(@"league: %@ %@ %@", leagueLogoJson, leagueNameJson, seasonNameJson);

        NSArray *jsonLeagueDetails = [jsonObjects objectForKey:@"league_season_club_teams"];
        for (NSDictionary *entry in jsonLeagueDetails) {
            NSString *clubId = [entry objectForKey:@"club_id"];
            // get the club team now
            NSString *wins = [entry objectForKey:@"wins"];
            NSString *draws = [entry objectForKey:@"draws"];
            NSString *losses = [entry objectForKey:@"losses"];
            NSString *goalsFor = [entry objectForKey:@"goals_for"];
            NSString *goalsAgainst = [entry objectForKey:@"goals_against"];
            NSString *goalDiff = [entry objectForKey:@"goals_diff"];
            NSString *points = [entry objectForKey:@"points"];
            NSLog(@"%@ %@ %@ %@ %@ %@", clubId, wins, draws, losses, goalsFor, goalsAgainst);

            
            NSArray *clubs = [jsonObjects objectForKey:@"clubs"];
            for (NSDictionary *clubEntry in clubs) {
               if ([clubEntry isKindOfClass:[NSDictionary class]]) {
                    NSString *clubEntryId = [clubEntry objectForKey:@"id"];
                    if (clubId == clubEntryId) {
                        NSString *name = [clubEntry objectForKey:@"name"];
                        NSString *badge = [clubEntry objectForKey:@"badge"];
                        NSLog(@"Club: %@ %@", name,  badge);
                        club = [[Club alloc] initWithName:name AndBadge:badge AndWins:wins AndDraws:draws AndLosses:losses AndGoalsFor:goalsFor AndGoalsAgainst:goalsAgainst AndGoalDiff:goalDiff AndPoints:points];
                        [clubList addObject: club];
                    }
                } else {
                    NSLog(@"%s", "Not a dictionary");
                }
            }
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
    
    if ([[segue identifier] isEqualToString:@"ShowClubDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSLog(@"%d", indexPath.row);
        Club *selectedClub = [clubList objectAtIndex:indexPath.row];
        NSLog(@"%@", selectedClub.name);
        NSLog(@"%@", segue.destinationViewController);
        [segue.destinationViewController setClub:selectedClub];
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

@end
