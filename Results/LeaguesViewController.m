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

@implementation LeaguesViewController {
    ADBannerView *_bannerView;
}

@synthesize leaguesList, searchBar, sections, leagueTablesView;

- (void)loadBanner {
    _bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];

    CGRect bannerFrame = _bannerView.frame;
    bannerFrame.origin.y = self.view.frame.size.height;
    _bannerView.frame = bannerFrame;
    
    _bannerView.delegate = self;
//    _bannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];

    if ([_bannerView isBannerLoaded]) {
        CGRect contentFrame = self.view.bounds;
        // knock the banner off screen when not loaded
        contentFrame.size.height -= _bannerView.frame.size.height;
        self.view.frame = contentFrame;
        DLog(@"LeaguesViewController viewDidLoad banner %f", self.view.bounds.size.height);
    }
    [self.view addSubview:_bannerView];
}

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)viewDidLoad {
    DLog(@"LeaguesViewController viewDidLoad %f", self.view.bounds.size.height);
    [super viewDidLoad];
    [self loadBanner];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.leagueTablesView = nil;

}

- (void)viewWillAppear:(BOOL)animated {
//    DLog(@"LeaguesViewController viewWillAppear %f", self.view.bounds.size.height);
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self layoutAnimated:NO];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.text=@"";
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    self.leagueTablesView.scrollEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    DLog(@"search button clicked");
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    NSCharacterSet *alphanumericSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_ &"];

    alphanumericSet = [alphanumericSet invertedSet];

    NSRange range = [theSearchBar.text rangeOfCharacterFromSet:alphanumericSet];
    if (range.location != NSNotFound) {
        DLog(@"the string contains illegal characters");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Must contain valid characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }

    if ([theSearchBar.text length] < 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Type in first 3 letters of League name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSRange whiteSpaceRange = [theSearchBar.text rangeOfCharacterFromSet:[NSCharacterSet whitespaceCharacterSet]];
    if (whiteSpaceRange.location != NSNotFound) {
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        @try {
            ServerManager *serverManager = [ServerManager sharedServerManager];
            NSString *serverName = [serverManager serverName];
            NSString *escapedText = [theSearchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/search/%@.json", escapedText];
            DLog(@"%@", urlString);
            [self createTableSections:urlString AndServerName:serverName];
        } @catch (NSException *exception) {
            NSLog(@"Exception%@ %@", [exception name], [exception reason]);
            [self loadNetworkExceptionAlert];
        }
        // done
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.leagueTablesView reloadData];
        });
    });
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
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    LeagueSeasonViewController *viewController = [[LeagueSeasonViewController alloc] init];
    League *league = [[sections valueForKey:[[[sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    [viewController setLeague:league];

    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)getTop500:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        @try {
            ServerManager *serverManager = [ServerManager sharedServerManager];
            NSString *serverName = [serverManager serverName];
            NSString *urlString = [serverName stringByAppendingFormat:@"/leagues.json"];
            [self createTableSections:urlString AndServerName:serverName];
        } @catch (NSException *exception) {
            NSLog(@"Exception%@ %@", [exception name], [exception reason]);
            [self loadNetworkExceptionAlert];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.leagueTablesView reloadData];
            [self layoutAnimated:YES];
        });
    });
}

- (void)layoutAnimated:(BOOL)animated
{
    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    CGRect contentFrame = self.view.bounds;
    if (contentFrame.size.width < contentFrame.size.height) {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
//        self.view.frame = contentFrame;
//        [self.view layoutIfNeeded];
        _bannerView.frame = bannerFrame;
    }];
    DLog(@"layoutAnimated: %d %f %f", _bannerView.bannerLoaded, self.view.bounds.size.height, _bannerView.frame.size.height);
}

- (void)viewDidLayoutSubviews {
    [self layoutAnimated:[UIView areAnimationsEnabled]];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    DLog(@"bannerViewDidLoadAd: %d %f %f", banner.bannerLoaded, self.view.bounds.size.height, banner.frame.size.height);
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    DLog(@"didFailToReceiveAdWithError banner not shown: %f", self.view.bounds.size.height);
    [self layoutAnimated:YES];
    DLog(@"didFailToReceiveAdWithError NO AD: %d %f %f", banner.bannerLoaded, self.view.bounds.size.height, banner.frame.size.height);
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