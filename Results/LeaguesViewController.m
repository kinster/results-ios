//
//  LeaguesViewController.m
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "LeaguesViewController.h"
#import "League.h"
#import "LeagueSeasonViewController.h"
#import "MBProgressHUD.h"
#import "ServerManager.h"
#import "Reachability.h"

@interface LeaguesViewController ()

@end

@implementation LeaguesViewController

@synthesize leaguesList, sections, leagueTablesView, club;

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ServerManager *serverManager = [ServerManager sharedServerManager];
    NSString *serverName = [serverManager serverName];
    NSString *clubId = [serverManager clubId];
    
    club = [[Club alloc] initWithIdAndName:clubId AndName:nil];
    
    NSString *urlString = [serverName stringByAppendingFormat:@"/clubs/%@/leagues.json", [club clubId]];
    
    DLog(@"%@", urlString);
    [self createTableSections:urlString AndServerName:serverName];
}

-(void)createTableSections:(NSString *)urlString AndServerName:(NSString *)serverName {
    NSError *error;
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    leaguesList = [[NSMutableArray alloc] init];
    League *league = nil;
    
    if (!jsonData) {
        NSLog(@"%@", error);
    } else {
        for (NSDictionary *entry in jsonData) {
            NSString *theId = [entry objectForKey:@"id"];
            NSString *theName = [entry objectForKey:@"name"];
            
            DLog(@"%@ %@", theId, theName);
            league = [[League alloc] initWithIdAndName:theId AndName:theName];
            [leaguesList addObject: league];
        }
    }
    
    sections = [[NSMutableDictionary alloc] init];
    
    BOOL found;
    
    for (League *league in leaguesList) {
        NSString *c = [league.name substringToIndex:1];
        found = NO;
        for (NSString *str in [sections allKeys]) {
            if ([str isEqualToString:c]) {
                found = YES;
            }
        }
        if (!found) {
            [sections setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    for (League *league in leaguesList) {
        [[sections objectForKey:[league.name substringToIndex:1]] addObject:league];
    }
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
}

- (void)setNavTitle {
    self.tabBarController.title = @"Leagues";
}

- (void)viewWillAppear:(BOOL)animated {
    DLog(@"table appeared");
    [self setNavTitle];
    self.tabBarController.navigationItem.rightBarButtonItem = nil;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[sections allKeys]count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LeagueCell";
    UITableViewCell *cell = [self.leagueTablesView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    NSString *name = [[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] name];
    
    cell.textLabel.text = name;
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DLog(@"LeaguesViewController prepareForSegue");
    NSIndexPath *indexPath = [self.leagueTablesView indexPathForSelectedRow];
    DLog(@"LeaguesViewController indexPath: %d", indexPath.row);
    League *league = nil;
    if ([[segue identifier] isEqualToString:@"ShowSeasons"]) {
        LeagueSeasonViewController *viewController = [segue destinationViewController];
        league = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        DLog(@"league: %@", league.leagueId);
        [viewController setLeague:league];
        [viewController setClub:club];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    LeagueSeasonViewController *viewController = [[LeagueSeasonViewController alloc] init];
    League *league = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [viewController setLeague:league];

    [self.navigationController pushViewController:viewController animated:YES];
}

@end