//
//  LeagueSeasonViewController.m
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "LeagueSeasonViewController.h"
#import "LeagueDivisionsViewController.h"
#import "League.h"
#import "Season.h"
#import "ServerManager.h"
#import "MBProgressHUD.h"

@interface LeagueSeasonViewController ()

@end

@implementation LeagueSeasonViewController

@synthesize league, seasonsList;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...

        @try {
            NSError *error;
            
            ServerManager *serverManager = [ServerManager sharedServerManager];
            NSString *serverName = [serverManager serverName];
            NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons.json", league.leagueId];
            NSLog(@"%@", urlString);
            
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            
            seasonsList = [[NSMutableArray alloc] init];
            Season *season = nil;
            
            if (!jsonData) {
                NSLog(@"%@", error);
            } else {
                for (NSDictionary *entry in jsonData) {
                    NSString *theId = [entry objectForKey:@"id"];
                    NSString *theName = [entry objectForKey:@"name"];
                    NSLog(@"id: %@", theId);
                    NSLog(@"name: %@", theName);
                    
                    season = [[Season alloc] initWithIdAndName:theId AndName:theName];
                    [seasonsList addObject: season];
                }
            }
            // done
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [seasonsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SeasonCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Season *season = [seasonsList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [season name];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"LeagueSeasonViewController prepareForSegue");
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%d", indexPath.row);
    Season *season = [seasonsList objectAtIndex:indexPath.row];
    //    UINavigationController *navigationController = [segue destinationViewController];
    
    if ([[segue identifier] isEqualToString:@"ShowDivisions"]) {
        LeagueDivisionsViewController *viewController = [segue destinationViewController];
        [viewController setLeague:league];
        [viewController setSeason:season];
    }
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
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
