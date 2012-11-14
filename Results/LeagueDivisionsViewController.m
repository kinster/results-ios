//
//  LeagueDetailsViewController.m
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "LeagueDivisionsViewController.h"
#import "LeagueTableViewController.h"
#import "LeagueFixturesViewController.h"
#import "LeagueResultsViewController.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "ServerManager.h"
#import "MBProgressHUD.h"

@interface LeagueDivisionsViewController ()

@end

@implementation LeagueDivisionsViewController

@synthesize divisionsList, league, season;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIImage *)getLeagueImage:(NSString *)serverName AndLeagueId:(NSString *)leagueId {
    NSError *error;
    NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@.json", leagueId];
    NSLog(@"%@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSString *image = [jsonData objectAtIndex:0];
    
    NSURL *imageUrl = [NSURL URLWithString:image];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageUrl];
    
    UIImage *leagueBadge = [[UIImage alloc]initWithData:imageData];
    return leagueBadge;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        NSError *error;
        ServerManager *serverManager = [ServerManager sharedServerManager];
        NSString *serverName = [serverManager serverName];
        
        UIImage *image = [self getLeagueImage:serverName AndLeagueId:league.leagueId];
        league.image = image;
        
        NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@.json", league.leagueId, season.seasonId];
        NSLog(@"%@", urlString);
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

        divisionsList = [[NSMutableArray alloc] init];
        Division *division = nil;
        
        for (NSDictionary *entry in jsonData) {
            NSString *theId = [entry objectForKey:@"id"];
            NSString *theName = [entry objectForKey:@"name"];
            division = [[Division alloc] initWithIdAndName:theId AndName:theName];
            
            [divisionsList addObject: division];
        }
        
        // done
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.tableView reloadData];
        });
    });

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [divisionsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DivisionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Division *division = [divisionsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [division name];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"LeagueDivisionsViewController prepareForSegue");
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%d", indexPath.row);
    Division *division = [divisionsList objectAtIndex:indexPath.row];
    UITabBarController *tabBarController = [segue destinationViewController];
    NSLog(@"controllers: %d", [tabBarController.viewControllers count]);
    LeagueTableViewController *viewController0 = [tabBarController.viewControllers objectAtIndex:0];
    NSLog(@"controller 0: %@", viewController0);
    [viewController0 setLeague:league];
    [viewController0 setSeason:season];
    [viewController0 setDivision:division];
    NSLog(@"ShowFixtures");
    LeagueFixturesViewController *viewController1 = [tabBarController.viewControllers objectAtIndex:1];
    NSLog(@"controller 1: %@", viewController1);
    [viewController1 setLeague:league];
    [viewController1 setSeason:season];
    [viewController1 setDivision:division];
    LeagueResultsViewController *viewController2 = [tabBarController.viewControllers objectAtIndex:2];
    NSLog(@"controller 2: %@", viewController2);
    [viewController2 setLeague:league];
    [viewController2 setSeason:season];
    [viewController2 setDivision:division];
    NSLog(@"end");
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
