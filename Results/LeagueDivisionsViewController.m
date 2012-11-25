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
#import "Club.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "ServerManager.h"
#import "MBProgressHUD.h"
#import "CustomDivisionCell.h"

@interface LeagueDivisionsViewController ()

@end

@implementation LeagueDivisionsViewController {
    ADBannerView *_bannerView;
    BOOL editMode;
}

@synthesize divisionsList, league, season, divisionsTableView, club, selectedDivisions;

- (void)loadBanner {
    _bannerView = [[ADBannerView alloc] init];
    _bannerView.delegate = self;
    
    [self.view addSubview:_bannerView];
}

- (void) readInSavedDivisions {
    selectedDivisions = [[NSMutableArray alloc] init];
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

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.editButtonItem.title = @"Edit";
//    self.navigationItem.rightBarButtonItem = [self editButtonItem];
    [self readInSavedDivisions];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

        [self loadBanner];

        @try {
            NSError *error;
            ServerManager *serverManager = [ServerManager sharedServerManager];
            NSString *serverName = [serverManager serverName];
            
            UIImage *image = [self getLeagueImage:serverName AndLeagueId:league.leagueId];
            league.image = image;
            
            // get out of plist saved ones instead
            
            NSString *urlString = [serverName stringByAppendingFormat:@"/clubs/%@/leagues/%@/seasons/%@.json", club.clubId, league.leagueId, season.seasonId];
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
                NSLog(@"%@ %@ %@", [club clubId], [season seasonId], [division divisionId]);
                
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

- (void)viewDidAppear:(BOOL)animated {
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
    DLog(@"cell");
    static NSString *CellIdentifier = @"CustomDivisionCell";
    CustomDivisionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomDivisionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Division *division = [divisionsList objectAtIndex:indexPath.row];
    
    DLog(@"Divisions name: %@", [division name]);
    cell.name.text = [division name];
//    cell.textLabel.text = [division name];

    if (editMode) {
        DLog(@"isEditing");
        [cell setEditing:TRUE];
        cell.radioButton.hidden=NO;
        if ([self.selectedDivisions containsObject:division]) {
            [cell.radioButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateSelected];
            
        } else {
            [cell.radioButton setBackgroundImage:[UIImage imageNamed:@"deselected.png"] forState:UIControlStateNormal];
        }
        divisionsTableView.allowsSelection=NO;
        cell.accessoryType=UITableViewCellAccessoryNone;
    } else {
        cell.radioButton.hidden=YES;
        divisionsTableView.allowsSelection=YES;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    DLog(@"Edit mode? %d", editMode);

//    if ([selectedDivisions containsObject:division]) {
//        cell.imageView.image = [UIImage imageNamed:@"checked.png"];
//    }
//    else {
//        cell.checkBox.titleLabel.text = @"x";
//        cell.imageView.image = [UIImage imageNamed:@"unchecked.png"];
//    }
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleChecking:)];
//    [cell.imageView addGestureRecognizer:tap];
//    cell.imageView.userInteractionEnabled = YES;

    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"editingStyleForRowAtIndexPath");
    // Detemine if it's in editing mode

    static NSString *CellIdentifier = @"CustomDivisionCell";
    CustomDivisionCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];

    [cell.imageView setHidden:YES];
    
    if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

//- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    DLog(@"Beginning editing");
//
//    CustomDivisionCell *cell = (CustomDivisionCell *)[tableView cellForRowAtIndexPath:indexPath];
//    
//    Division *division = [divisionsList objectAtIndex:indexPath.row];
//
//    cell.name.text = [division name];
//    
//    [cell.radioButton setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
//    
//}

//- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
//    DLog(@"End editing");
//}
- (IBAction)switchToAdd:(id)sender {
    UIBarButtonItem *button = sender;
    DLog(@"switchToEdit %@", [button title]);
    if ([button.title isEqualToString:@"Add"]) {
        [button setTitle:@"Save"];
        editMode = YES;
    } else {
        [button setTitle:@"Add"];
        editMode = NO;
        [self saveDivisions];
        DLog(@"Saved...");
    }
    NSLog(@"%d", editMode);
    [self.divisionsTableView reloadData];
}

- (void)saveDivisions {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *leagueId = [league leagueId];
    NSString *leagueName = [league name];
    NSString *seasonId = [season seasonId];
    NSString *seasonName = [season name];

    for (Division *division in selectedDivisions) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:leagueId forKey:@"LeagueId"];
        [dict setObject:leagueName forKey:@"LeagueName"];
        [dict setObject:seasonId forKey:@"SeasonId"];
        [dict setObject:seasonName forKey:@"SeasonName"];
        [dict setObject:division.divisionId forKey:@"DivisionId"];
        [dict setObject:division.name forKey:@"DivisionName"];
        DLog(@"%@ %@ %@ %@ %@ %@", leagueId, leagueName, seasonId, seasonName, division.divisionId, division.name);
        [array addObject:dict];
    }
    DLog(@"Array size %d", [array count]);
    
//    for (NSMutableDictionary *dict in array) {
//        DLog(@"%@ %@", dict, [dict class]);
//        NSString *leagueId = [dict valueForKey:@"LeagueId"];
//        NSString *leagueName = [dict valueForKey:@"LeagueName"];
//        NSString *seasonId = [dict valueForKey:@"SeasonId"];
//        NSString *seasonName = [dict valueForKey:@"SeasonName"];
//        NSString *divisionId = [dict valueForKey:@"DivisionId"];
//        NSString *divisionName = [dict valueForKey:@"DivisionName"];
//        DLog(@"plist: %@ %@ %@ %@ %@ %@", leagueId, leagueName, seasonId, seasonName, divisionId, divisionName);
//    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];

    BOOL success = [array writeToFile:[documentsDirectory stringByAppendingPathComponent:@"Saved-Divisions.plist"] atomically:YES];

    if (success) {
        DLog(@"written to plist");
    } else {
        DLog(@"Failed");
    }

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
    [viewController0 setLeague:league];
    [viewController0 setSeason:season];
    [viewController0 setDivision:division];
    DLog(@"ShowFixtures");
    LeagueFixturesViewController *viewController1 = [tabBarController.viewControllers objectAtIndex:1];
    DLog(@"controller 1: %@", viewController1);
    [viewController1 setLeague:league];
    [viewController1 setSeason:season];
    [viewController1 setDivision:division];
    LeagueResultsViewController *viewController2 = [tabBarController.viewControllers objectAtIndex:2];
    DLog(@"controller 2: %@", viewController2);
    [viewController2 setLeague:league];
    [viewController2 setSeason:season];
    [viewController2 setDivision:division];
    DLog(@"end");
}

- (void)viewDidLayoutSubviews {
    [_bannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        contentFrame.size.height -= _bannerView.frame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    _bannerView.frame = bannerFrame;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerViewActionWillBegin" object:self];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BannerViewActionDidFinish" object:self];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    DLog(@"editing");
    [super setEditing:editing animated:animated];
    [divisionsTableView setEditing:editing animated:YES];
}

- (IBAction)rowSelected:(id)sender {
    NSIndexPath *indexPath = [self.divisionsTableView indexPathForCell:(UITableViewCell *)
                              [[sender superview] superview]];

    Division *division = [divisionsList objectAtIndex:indexPath.row];
    UIButton *button = sender;
    
    if ([self.selectedDivisions containsObject:division]) {
        DLog(@"Deselected %@", [division name]);
        [self.selectedDivisions removeObject:division];
        [button setBackgroundImage:[UIImage imageNamed:@"deselected.png"] forState:UIControlStateNormal];
        
    } else {
        DLog(@"Selected %@", [division name]);
        [self.selectedDivisions addObject:division];
        [button setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
    DLog(@"Size %d", [selectedDivisions count]);
}

 // Override to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//     DLog(@"canEditRowAtIndexPath");
//
// // Return NO if you do not want the specified item to be editable.
// return YES;
// }

 // Override to support editing the table view.
// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
// if (editingStyle == UITableViewCellEditingStyleDelete) {
// // Delete the row from the data source
// [divisionsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//     DLog(@"delete");
//
// }
// else if (editingStyle == UITableViewCellEditingStyleInsert) {
// // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//     DLog(@"editstyle");
//
// }
// }
// 

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
