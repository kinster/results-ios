//
//  LeagueViewController.m
//  Results
//
//  Created by Kinman Li on 14/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "LeagueViewController.h"
#import "ServerManager.h"
#import "League.h"

@interface LeagueViewController ()

@end

@implementation LeagueViewController

@synthesize leaguesList, searchBar, sections, leagueTablesView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
            NSLog(@"%@ %@", theId, theName);
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ServerManager *serverManager = [ServerManager sharedServerManager];
    NSString *serverName = [serverManager serverName];
    NSString *urlString = [serverName stringByAppendingFormat:@"/leagues.json"];
    NSLog(@"%@", urlString);
    
    [self createTableSections:urlString AndServerName:serverName];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    NSLog(@"search button clicked");
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    ServerManager *serverManager = [ServerManager sharedServerManager];
    NSString *serverName = [serverManager serverName];
    NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/search/%@.json", theSearchBar.text];
    NSLog(@"%@", urlString);
    
    [self createTableSections:urlString AndServerName:serverName];
    
    [self.leagueTablesView reloadData];
    NSLog(@"searchBarSearchButtonClicked");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[sections allKeys]count];
//    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
//    return [leaguesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LeagueCell";
    UITableViewCell *cell = [self.leagueTablesView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    NSString *name = [[[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row] name];
    
//    NSString *name = [[leaguesList objectAtIndex:indexPath.row] name];
    
    cell.textLabel.text = name;
    
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return [[[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
