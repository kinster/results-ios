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
        
        NSURL *imageUrl = [NSURL URLWithString:leagueLogoJson];
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
        
        leagueLogo.image = [[UIImage alloc]initWithData:imageData];
        
        [self setLeagueName:[leagueNameJson stringByAppendingFormat:@" %@",seasonNameJson]];
        
        NSLog(@"league: %@ %@ %@", leagueLogoJson, leagueNameJson, seasonNameJson);
        
        NSArray *jsonArray = [jsonObjects objectForKey:@"clubs"];
        for (NSDictionary *object in jsonArray) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *name = [object objectForKey:@"name"];
                NSString *badge = [object objectForKey:@"badge"];
                NSLog(@"Club team: %@ %@", name, badge);
                club = [[Club alloc] initWithName:name AndBadge:badge];
                [clubList addObject: club];
            } else {
                NSLog(@"%s", "Not a dictionary");
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
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.position.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
    cell.badge.image = [[UIImage alloc]initWithData:imageData];
    cell.name.text = [[clubList objectAtIndex:indexPath.row]name];
    
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
