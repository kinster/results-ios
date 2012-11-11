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

@interface LeaguesViewController ()

@end

@implementation LeaguesViewController

@synthesize leaguesList, filteredLeaguesList, searchBar, isFiltered;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSError *error;

    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* jsonServer = [infoDict objectForKey:@"jsonServer"];
    NSString *urlString = [jsonServer stringByAppendingFormat:@"/leagues.json"];
    NSLog(@"%@", urlString);

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
            NSLog(@"id: %@", theId);
            NSLog(@"name: %@", theName);
            
            league = [[League alloc] initWithIdAndName:theId AndName:theName];
            [leaguesList addObject: league];
            
        }
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text {
    
//    if (text.length == 0) {
//        NSLog(@"no text");
//        isFiltered = FALSE;
//        // The user clicked the [X] button or otherwise cleared the text.
//        [self.searchBar performSelector: @selector(resignFirstResponder)
//                        withObject: nil
//                        afterDelay: 0.1];
//    }
//    else {
//        isFiltered = TRUE;
//        filteredLeaguesList = [[NSMutableArray alloc] init];
//        for (League *league in leaguesList) {
//            NSRange nameRange = [league.name rangeOfString:text options:NSCaseInsensitiveSearch];
//            if (nameRange.location != NSNotFound) {
//                [filteredLeaguesList addObject:league];
//            }
//
//        }
//    }
//    NSLog(@"filteredLeagueList: %d", [filteredLeaguesList count]);
//    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
//    [self.searchBar becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text=@"";
    NSLog(@"searchBarCancelButtonClicked");
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    self.tableView.scrollEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    NSLog(@"search button clicked");
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";

    [self.navigationController.view addSubview:hud];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        NSError *error;
        
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString* jsonServer = [infoDict objectForKey:@"jsonServer"];
        NSString *urlString = [jsonServer stringByAppendingFormat:@"/leagues/search/%@.json", theSearchBar.text];
        NSLog(@"%@", urlString);
        
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
                NSLog(@"id: %@", theId);
                NSLog(@"name: %@", theName);
                
                league = [[League alloc] initWithIdAndName:theId AndName:theName];
                [leaguesList addObject: league];
                
            }
        }
        
        self.isFiltered = FALSE;
        // done

        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowCount;
    if (isFiltered) {
        rowCount = [filteredLeaguesList count];
    }
    else {
        rowCount = [leaguesList count];
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LeagueCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    League *league = nil;

    if (isFiltered) {
        league = [filteredLeaguesList objectAtIndex:indexPath.row];
        NSLog(@"In filtered List");
    }
    else {
        league = [leaguesList objectAtIndex:indexPath.row];
        NSLog(@"In Full List");
    }
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [league name];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"LeaguesViewController prepareForSegue");
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"%d", indexPath.row);
    League *league = nil;
    if  (isFiltered) {
        league = [filteredLeaguesList objectAtIndex:indexPath.row];
    } else {
        league = [leaguesList objectAtIndex:indexPath.row];
    }

    if ([[segue identifier] isEqualToString:@"ShowSeasons"]) {
        LeagueSeasonViewController *viewController = [segue destinationViewController];
        [viewController setLeague:league];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
