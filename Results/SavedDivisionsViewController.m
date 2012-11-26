//
//  SavedDivisionsViewController.m
//  nel
//
//  Created by Kinman Li on 24/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "SavedDivisionsViewController.h"
#import "LeagueTableViewController.h"
#import "LeagueFixturesViewController.h"
#import "LeagueResultsViewController.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "ServerManager.h"

@interface SavedDivisionsViewController ()

@end

@implementation SavedDivisionsViewController

@synthesize divisionsTableView, divisionsList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSavedData];

}

- (void)loadSavedData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Saved-Divisions.plist"];
    
    NSMutableArray *divisions = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    divisionsList = [[NSMutableArray alloc] init];
    
    League *league = nil;
    Season *season = nil;
    Division *division = nil;
    for (NSDictionary *dict in divisions) {
        NSString *leagueId = [dict objectForKey:@"LeagueId"];
        NSString *leagueName = [dict objectForKey:@"LeagueName"];
        league = [[League alloc] initWithIdAndName:leagueId AndName:leagueName];
        
        NSString *seasonId = [dict objectForKey:@"SeasonId"];
        NSString *seasonName = [dict objectForKey:@"SeasonName"];
        season = [[Season alloc] initWithIdAndName:seasonId AndName:seasonName];
        
        NSString *divisionId = [dict objectForKey:@"DivisionId"];
        NSString *divisionName = [dict objectForKey:@"DivisionName"];
        division = [[Division alloc] initWithIdAndName:divisionId AndName:divisionName];
        
        NSMutableArray *innerArray = [[NSMutableArray alloc] init];
        [innerArray addObject:league];
        [innerArray addObject:season];
        [innerArray addObject:division];
        
        [divisionsList addObject:innerArray];
        
        DLog(@"plist: %@ %@ %@ %@", [league leagueId], [season seasonId], [division divisionId], [division name]);
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavTitle {
    self.tabBarController.title = @"Following";
}

- (void)viewWillAppear:(BOOL)animated {
    DLog(@"table appeared");
    [self setNavTitle];
    self.tabBarController.editButtonItem.title = @"Edit";
    self.tabBarController.navigationItem.rightBarButtonItem = [self editButtonItem];
    [self loadSavedData];
    [self.divisionsTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [divisionsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"cell");
    static NSString *CellIdentifier = @"SelectedDivisionCell";
    UITableViewCell *cell = [divisionsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSMutableArray *array = [divisionsList objectAtIndex:indexPath.row];
    
    Division *division = [array objectAtIndex:2];
    
    DLog(@"Divisions name: %@", [division name]);
    cell.textLabel.text = [division name];
    
    return cell;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    DLog(@"editing");
    [super setEditing:editing animated:animated];
    [divisionsTableView setEditing:editing animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DLog(@"LeagueDivisionsViewController prepareForSegue");
    
    NSIndexPath *indexPath = [self.divisionsTableView indexPathForSelectedRow];
    DLog(@"%d", indexPath.row);
    NSMutableArray *array = [divisionsList objectAtIndex:indexPath.row];
    League *league = [array objectAtIndex:0];
    
    ServerManager *serverManager = [ServerManager sharedServerManager];
    NSString *serverName = [serverManager serverName];
    UIImage *image = [self getLeagueImage:serverName AndLeagueId:league.leagueId];
    league.image = image;

    Season *season = [array objectAtIndex:1];
    Division *division = [array objectAtIndex:2];
    UITabBarController *tabBarController = [segue destinationViewController];
    DLog(@"controllers: %d", [tabBarController.viewControllers count]);
    LeagueTableViewController *viewController0 = [tabBarController.viewControllers objectAtIndex:0];
    DLog(@"controller 0: %@", viewController0);
    [viewController0 setLeague:league];
    [viewController0 setSeason:season];
    [viewController0 setDivision:division];
    DLog(@"ShowFixtures");
    LeagueFixturesViewController *viewController1 = [tabBarController.viewControllers objectAtIndex:1];
    DLog(@"controller 1: %@", viewController1);
    [viewController1 setLeague:league];
    [viewController1 setSeason:season];
    [viewController1 setDivision:division];
    LeagueResultsViewController *viewController2 = [tabBarController.viewControllers objectAtIndex:2];
    DLog(@"controller 2: %@", viewController2);
    [viewController2 setLeague:league];
    [viewController2 setSeason:season];
    [viewController2 setDivision:division];
    DLog(@"end");
}


- (UIImage *)getLeagueImage:(NSString *)serverName AndLeagueId:(NSString *)leagueId {
    NSError *error;
    NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@.json", leagueId];
    DLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSString *image = [jsonData objectAtIndex:0];
    
    NSURL *imageUrl = [NSURL URLWithString:image];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    UIImage *leagueBadge = [[UIImage alloc]initWithData:imageData];
    return leagueBadge;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"%d %d", indexPath.row, [divisionsList count]);
    [divisionsList removeObjectAtIndex:indexPath.row];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSMutableArray *rootArray = [[NSMutableArray alloc] init];

    for (NSMutableArray *array in divisionsList) {
        League *league = [array objectAtIndex:0];
        DLog(@"League: %@", [league name]);
        Season *season = [array objectAtIndex:1];
        DLog(@"Season: %@", [season name]);
        Division *division = [array objectAtIndex:2];
        DLog(@"Division: %@", [division name]);
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:league.leagueId forKey:@"LeagueId"];
        [dict setObject:league.name forKey:@"LeagueName"];
        [dict setObject:season.name forKey:@"SeasonId"];
        [dict setObject:season.name forKey:@"SeasonName"];
        [dict setObject:division.divisionId forKey:@"DivisionId"];
        [dict setObject:division.name forKey:@"DivisionName"];
        [rootArray addObject:dict];
    }
    DLog(@"Count: %d", [rootArray count]);
    
    for (NSMutableDictionary *dict in rootArray) {
        DLog(@"%@ %@", dict, [dict class]);
        NSString *leagueId = [dict valueForKey:@"LeagueId"];
        NSString *leagueName = [dict valueForKey:@"LeagueName"];
        NSString *seasonId = [dict valueForKey:@"SeasonId"];
        NSString *seasonName = [dict valueForKey:@"SeasonName"];
        NSString *divisionId = [dict valueForKey:@"DivisionId"];
        NSString *divisionName = [dict valueForKey:@"DivisionName"];
        DLog(@"plist: %@ %@ %@ %@ %@ %@", leagueId, leagueName, seasonId, seasonName, divisionId, divisionName);
    }
    BOOL success = [rootArray writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Saved-Divisions.plist"] atomically:YES];
    
    if (success) {
        DLog(@"written to plist");
    } else {
        DLog(@"Failed");
    }

    [self.divisionsTableView reloadData];
}

@end
