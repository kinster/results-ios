//
//  SavedDivisionsViewController.m
//  Grass Roots
//
//  Created by Kinman Li on 26/11/2012.
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
        NSString *seasonId = [dict objectForKey:@"SeasonId"];
        NSString *seasonName = [dict objectForKey:@"SeasonName"];
        NSString *divisionId = [dict objectForKey:@"DivisionId"];
        NSString *divisionName = [dict objectForKey:@"DivisionName"];
        
        league = [[League alloc] initWithIdAndName:leagueId AndName:leagueName];
        season = [[Season alloc] initWithIdAndName:seasonId AndName:seasonName];
        [season setLeague:league];
        division = [[Division alloc] initWithIdAndName:divisionId AndName:divisionName];
        [division setSeason:season];
        
        [divisionsList addObject:division];
        
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

- (void)viewDidAppear:(BOOL)animated {
    DLog(@"Following viewDidAppear");
    [self setNavTitle];
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
    
    Division *division = [divisionsList objectAtIndex:indexPath.row];
    
    DLog(@"Divisions name: %@", [division name]);
    cell.textLabel.text = [division name];
    NSString *detail = [[division season].name stringByAppendingFormat:@" (%@)", [[division season].league name] ];
    cell.detailTextLabel.text = detail;
    
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
    Division *division = [divisionsList objectAtIndex:indexPath.row];
    
    Season *season = [division season];
    League *league = [season league];
    
    ServerManager *serverManager = [ServerManager sharedServerManager];
    NSString *serverName = [serverManager serverName];
    UIImage *image = [self getLeagueImage:serverName AndLeagueId:[league leagueId]];
    [league setImage:image];
    
    DLog(@"%@ %@ %@", [league leagueId], [season seasonId], [division divisionId]);
    
    UITabBarController *tabBarController = [segue destinationViewController];
    DLog(@"controllers: %d", [tabBarController.viewControllers count]);
    LeagueTableViewController *viewController0 = [tabBarController.viewControllers objectAtIndex:0];
    DLog(@"controller 0: %@", viewController0);
    [viewController0 setDivision:division];
    DLog(@"ShowFixtures");
    LeagueFixturesViewController *viewController1 = [tabBarController.viewControllers objectAtIndex:1];
    DLog(@"controller 1: %@", viewController1);
    [viewController1 setDivision:division];
    LeagueResultsViewController *viewController2 = [tabBarController.viewControllers objectAtIndex:2];
    DLog(@"controller 2: %@", viewController2);
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
    
    NSMutableDictionary *dict = nil;
    for (Division *division in divisionsList) {
        Season *season = [division season];
        League *league = [season league];
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:league.leagueId forKey:@"LeagueId"];
        [dict setObject:league.name forKey:@"LeagueName"];
        [dict setObject:season.seasonId forKey:@"SeasonId"];
        [dict setObject:season.name forKey:@"SeasonName"];
        [dict setObject:division.divisionId forKey:@"DivisionId"];
        [dict setObject:division.name forKey:@"DivisionName"];
        [rootArray addObject:dict];
    }
    DLog(@"Count: %d", [rootArray count]);
    
//    for (NSMutableDictionary *dict in rootArray) {
//        DLog(@"%@ %@", dict, [dict class]);
//        NSString *leagueId = [dict valueForKey:@"LeagueId"];
//        NSString *leagueName = [dict valueForKey:@"LeagueName"];
//        NSString *seasonId = [dict valueForKey:@"SeasonId"];
//        NSString *seasonName = [dict valueForKey:@"SeasonName"];
//        NSString *divisionId = [dict valueForKey:@"DivisionId"];
//        NSString *divisionName = [dict valueForKey:@"DivisionName"];
//        DLog(@"plist: %@ %@ %@ %@ %@ %@", leagueId, leagueName, seasonId, seasonName, divisionId, divisionName);
//    }
    BOOL success = [rootArray writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Saved-Divisions.plist"] atomically:YES];
    
    if (success) {
        DLog(@"written to plist");
    } else {
        DLog(@"Failed");
    }
    
    [self.divisionsTableView reloadData];
}

@end