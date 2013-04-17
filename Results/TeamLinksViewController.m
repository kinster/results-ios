//
//  TeamResultsViewController.m
//  Results
//
//  Created by Kinman Li on 10/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "TeamLinksViewController.h"
#import "ReportsViewController.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "Result.h"
#import "Team.h"
#import "Report.h"
#import "ServerManager.h"
#import "MBProgressHUD.h"

@interface TeamLinksViewController ()

@end

@implementation TeamLinksViewController

@synthesize teamLinksTable, division, result, team;

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


- (void)loadData {
    @try {
        NSError *error;
        
        Season *season = [division season];
        
        ServerManager *serverManager = [ServerManager sharedServerManager];
        NSString *serverName = [serverManager serverName];
        NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/results/%@.json", [season league].leagueId, season.seasonId, division.divisionId, result.resultId];
        DLog(@"%@", urlString);
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        NSString *homeBadge = [jsonData objectForKey:@"home_badge"];
        NSString *awayBadge = [jsonData objectForKey:@"away_badge"];
        NSString *homeId = [jsonData objectForKey:@"home_id"];
        NSString *awayId = [jsonData objectForKey:@"away_id"];
        
        result.homeId = homeId;
        result.awayId = awayId;
        result.homeBadge = homeBadge;
        result.awayBadge = awayBadge;
        
        NSMutableArray *reports = [jsonData objectForKey:@"reports"];
        NSMutableArray *reps = [[NSMutableArray alloc] init];
        for (NSDictionary *report in reports) {
            NSString *type = [report objectForKey:@"type"];
            NSString *name = [report objectForKey:@"name"];
            NSString *url = [report objectForKey:@"url"];
            NSString *summary = [report objectForKey:@"summary"];
            Report *report = [[Report alloc] initSummary:summary AndTeamLink:url AndTeamName:name];
            [report setType:type];
            [reps addObject:report];
        }
        result.reports = reps;
    } @catch (NSException *exception) {
        NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
        [self loadNetworkExceptionAlert];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DLog(@"TeamLinksViewController");
    
    [self setNavTitle];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.teamLinksTable reloadData];
        });
    });
}

- (void)setNavTitle {
    self.title = @"Match Reports";
}

- (void)viewWillAppear:(BOOL)animated {
    DLog(@"table appeared");
    [self setNavTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [result.reports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TeamLinkCell";
    UITableViewCell *cell = [teamLinksTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Report *report = [result.reports objectAtIndex:indexPath.row];
    cell.textLabel.text = [report teamName];
    cell.detailTextLabel.text = [report teamLink];
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DLog(@"In prepareForSegue");
    if ([[segue identifier] isEqualToString:@"ShowReport"]) {
        NSIndexPath *indexPath = [self.teamLinksTable indexPathForSelectedRow];
        Report *report = [result.reports objectAtIndex:indexPath.row];
        ReportsViewController *destinationController = [segue destinationViewController];
        DLog(@"%@", segue.destinationViewController);
        [destinationController setReport:report];
    }
    DLog(@"end of prepareForSegue");
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
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
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

- (void)viewDidUnload {
    [self setTeamLinksTable:nil];
    [super viewDidUnload];
}
@end
