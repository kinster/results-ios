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
#import "AppDelegate.h"

@interface LeagueSeasonViewController ()

@end

@implementation LeagueSeasonViewController

@synthesize league, seasonsList, seasonsTableView, adBannerView;

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
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
    self.seasonsTableView.frame = CGRectMake(seasonsTableView.frame.origin.x,seasonsTableView.frame.origin.y,seasonsTableView.frame.size.width,contentFrame.size.height);
    DLog(@"toggleBanner %@", adBannerView);
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

- (void)viewDidUnload {
    [super viewDidUnload];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    [self setSeasonsTableView:nil];
    DLog(@"LeagueSeasonsViewController viewDidUnload %@", self.adBannerView);
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setAdBannerView:AppDelegate.adBannerView];
    DLog(@"LeagueSeasonsViewController viewWillAppear %@", self.adBannerView);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setAdBannerView:AppDelegate.adBannerView];
    DLog(@"viewDidAppear %@", adBannerView);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    [self.adBannerView removeFromSuperview];
    DLog(@"LeagueSeasonsViewController viewWillDisappear %@", self.adBannerView);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.adBannerView setDelegate:nil];
    [self setAdBannerView:nil];
    [self.adBannerView removeFromSuperview];
    DLog(@"LeagueSeasonsViewController viewDidDisappear %@", self.adBannerView);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    adBannerView.delegate = self;
    adBannerView.hidden = YES;
    
//    [self toggleBanner:adBannerView];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

        @try {
            NSError *error;
            
            ServerManager *serverManager = [ServerManager sharedServerManager];
            NSString *serverName = [serverManager serverName];
            NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons.json", league.leagueId];
            DLog(@"%@", urlString);
            
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
                    DLog(@"id: %@", theId);
                    DLog(@"name: %@", theName);
                    
                    season = [[Season alloc] initWithIdAndName:theId AndName:theName];
                    [season setLeague:league];
                    [seasonsList addObject: season];
                }
            }
            // done
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [self.seasonsTableView reloadData];
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
    DLog(@"LeagueSeasonViewController prepareForSegue");
    
    NSIndexPath *indexPath = [self.seasonsTableView indexPathForSelectedRow];
    DLog(@"%d", indexPath.row);
    Season *season = [seasonsList objectAtIndex:indexPath.row];
    
    if ([[segue identifier] isEqualToString:@"ShowDivisions"]) {
        LeagueDivisionsViewController *viewController = [segue destinationViewController];
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

@end
