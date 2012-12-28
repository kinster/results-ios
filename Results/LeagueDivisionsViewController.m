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
#import "AppDelegate.h"

@interface LeagueDivisionsViewController ()

@end

@implementation LeagueDivisionsViewController

@synthesize divisionsList, season, divisionsTableView, adBannerView;

-(UIImage *)getLeagueImage:(NSString *)serverName AndLeagueId:(NSString *)leagueId {
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

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    DLog(@"bannerViewDidLoadAd loaded %d", banner.isBannerLoaded);
    banner.hidden = NO;
    [self toggleBanner:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    DLog(@"didFailToReceiveAdWithError loaded %d", banner.isBannerLoaded);
    banner.hidden = YES;
    [self toggleBanner:banner];
}

- (void)toggleBanner:(ADBannerView *)banner {
    CGRect bannerFrame = banner.frame;
    CGRect contentFrame = self.view.frame;
    if ([banner isBannerLoaded]) {
        DLog(@"Has ad, showing");
        contentFrame.size.height -= banner.bounds.size.height;
    } else {
        DLog(@"No ad, hiding");
    }
    bannerFrame.origin.y = contentFrame.size.height;
    banner.frame = bannerFrame;
    self.divisionsTableView.frame = CGRectMake(divisionsTableView.frame.origin.x,divisionsTableView.frame.origin.y,divisionsTableView.frame.size.width,contentFrame.size.height);
    DLog(@"toggleBanner %@", adBannerView);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setAdBannerView:AppDelegate.adBannerView];
    DLog(@"LeagueDivisionsViewController viewWillAppear %@", self.adBannerView);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    [self.adBannerView removeFromSuperview];
    DLog(@"LeagueDivisionsViewController viewWillDisappear %@", self.adBannerView);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setAdBannerView:AppDelegate.adBannerView];
    DLog(@"viewDidAppear %@", adBannerView);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    [self.adBannerView removeFromSuperview];
    DLog(@"LeagueDivisionsViewController viewDidDisappear %@", self.adBannerView);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    adBannerView = [AppDelegate adBannerView];
    adBannerView.delegate = self;
    adBannerView.hidden = YES;
    
    [self toggleBanner:adBannerView];

    //    CGRect bannerFrame = adBannerView.frame;
//    bannerFrame.origin.y = self.view.frame.size.height;
//    
//    self.adBannerView.frame = bannerFrame;
//    [self.view addSubview:adBannerView];
    
    adBannerView = [AppDelegate adBannerView];
    adBannerView.delegate = self;


    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        @try {
            NSError *error;
            ServerManager *serverManager = [ServerManager sharedServerManager];
            NSString *serverName = [serverManager serverName];
            
            UIImage *image = [self getLeagueImage:serverName AndLeagueId:[season league].leagueId];
            [season league].image = image;
            
            NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@.json", [season league].leagueId, season.seasonId];
            DLog(@"%@", urlString);
            
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

            divisionsList = [[NSMutableArray alloc] init];
            Division *division = nil;
            
            for (NSDictionary *entry in jsonData) {
                NSString *theId = [entry objectForKey:@"id"];
                NSString *theName = [entry objectForKey:@"name"];
                division = [[Division alloc] initWithIdAndName:theId AndName:theName];
                [division setSeason:season];
                [divisionsList addObject: division];
            }
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
            [self loadNetworkExceptionAlert];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.divisionsTableView reloadData];
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
    DLog(@"LeagueDivisionsViewController prepareForSegue");
    
    NSIndexPath *indexPath = [self.divisionsTableView indexPathForSelectedRow];
    DLog(@"%d", indexPath.row);
    Division *division = [divisionsList objectAtIndex:indexPath.row];
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

- (void)viewDidUnload {
    [self setAdBannerView:nil];
    [super viewDidUnload];
}
@end
