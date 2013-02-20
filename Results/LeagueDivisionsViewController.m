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
#import "CustomDivisionCell.h"

@interface LeagueDivisionsViewController ()

@end

@implementation LeagueDivisionsViewController

@synthesize divisionsList, season, divisionsTableView, selectedDivisions, otherDivisions;

- (void) readInSavedDivisions {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Saved-Divisions.plist"];
    
    NSMutableArray *divisions = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    selectedDivisions = [[NSMutableArray alloc] init];
    otherDivisions = [[NSMutableArray alloc] init];
    
    League *newLeague = nil;
    Season *newSeason = nil;
    Division *division = nil;
    for (NSDictionary *dict in divisions) {
        NSString *leagueId = [dict objectForKey:@"LeagueId"];
        NSString *leagueName = [dict objectForKey:@"LeagueName"];
        NSString *seasonId = [dict objectForKey:@"SeasonId"];
        NSString *seasonName = [dict objectForKey:@"SeasonName"];
        BOOL isLeague = [[NSString stringWithFormat:@"%@", leagueId] isEqualToString:[NSString stringWithFormat:@"%@", [season league].leagueId]];
        BOOL isSeason = [[NSString stringWithFormat:@"%@", seasonId] isEqualToString:[NSString stringWithFormat:@"%@", season.seasonId]];

        NSString *divisionId = [dict objectForKey:@"DivisionId"];
        NSString *divisionName = [dict objectForKey:@"DivisionName"];
        newLeague = [[League alloc] initWithIdAndName:leagueId AndName:leagueName];
        newSeason = [[Season alloc] initWithIdAndName:seasonId AndName:seasonName];
        [newSeason setLeague:newLeague];
        division = [[Division alloc] initWithIdAndName:divisionId AndName:divisionName];
        
        [division setSeason:newSeason];

        if (isLeague && isSeason) {
            DLog(@"selectedDivisions %@ %@", selectedDivisions, division);
            [selectedDivisions addObject:division];
        }
        else {
            [otherDivisions addObject:division];
        }
        DLog(@"seasonName: %@", [division.season name]);

        DLog(@"selectedDivisions: %@ otherDivisions: %@", selectedDivisions, otherDivisions);
        DLog(@"plist: %@ %@ %@ %@", [[season league] leagueId], [season seasonId], [division divisionId], [division name]);
    }
    DLog(@"selectedDivisions: %@ otherDivisions: %@", selectedDivisions, otherDivisions);
}

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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.editButtonItem.title = @"Follow";
    self.navigationItem.rightBarButtonItem = [self editButtonItem];
    selectedDivisions = [[NSMutableArray alloc] init];
    [self readInSavedDivisions];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.view addSubview:hud];
    
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

            League *newLeague = [[League alloc] initWithIdAndName:[season league].leagueId AndName:[season league].name];
            Season *newSeason = [[Season alloc] initWithIdAndName:[season seasonId] AndName:[season name]];
            
            [newSeason setLeague:newLeague];

            divisionsList = [[NSMutableArray alloc] init];
            Division *division = nil;
            
            for (NSDictionary *entry in jsonData) {
                NSString *theId = [entry objectForKey:@"id"];
                NSString *theName = [entry objectForKey:@"name"];
                division = [[Division alloc] initWithIdAndName:theId AndName:theName];
                [division setSeason:newSeason];
                DLog(@"%@ %@", [newLeague leagueId], [newSeason seasonId]);
                [divisionsList addObject: division];
            }
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
            [self loadNetworkExceptionAlert];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.divisionsTableView reloadData];
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
    return [divisionsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomDivisionCell";
    CustomDivisionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomDivisionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Division *division = [divisionsList objectAtIndex:indexPath.row];
    
//    cell.clearsContextBeforeDrawing = YES;
//    cell.textLabel.text = nil;

    cell.textLabel.text = [division name];
    
    if ([self isDivisionSaved:division]) {
        // add this to list if not already in selectedDivisions
//        [self addToSelectedDivisions:division];
        [cell.radioButton setBackgroundImage:[UIImage imageNamed:@"selected2.png"] forState:UIControlStateNormal];
    } else {
        [cell.radioButton setBackgroundImage:[UIImage imageNamed:@"deselected.png"] forState:UIControlStateNormal];        
    }
    UIButton *radioButton = (UIButton *)[cell viewWithTag:1];
    [radioButton addTarget:self action:@selector(radioButtonSelected:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (BOOL)isDivisionSaved:(Division *)division {
    
    for (Division *inDivision in selectedDivisions) {
        DLog(@"%@", inDivision.divisionId);
        BOOL isDivision = [[NSString stringWithFormat:@"%@", inDivision.divisionId] isEqualToString:[NSString stringWithFormat:@"%@", division.divisionId]];
        if (isDivision) {
            return YES;
        }
    }
    return NO;
}

- (void)addToSelectedDivisions:(Division *)division {
    if (![self.selectedDivisions containsObject:division]) {
        DLog(@"Selected %@", [division name]);
        [self.selectedDivisions addObject:division];
    }
}

- (IBAction)radioButtonSelected:(id)sender {
    DLog(@"radioButtonSelected");
    NSIndexPath *indexPath = [self.divisionsTableView indexPathForCell:(UITableViewCell *)
                              [[sender superview] superview]];
    
    Division *division = [divisionsList objectAtIndex:indexPath.row];
    
    DLog(@"radioButtonSelected %@ %@ %@", [division.season league], [division season], division.divisionId);

    UIButton *button = sender;
    
    if ([self.selectedDivisions containsObject:division]) {
        DLog(@"Deselected %@", [division name]);
        [self.selectedDivisions removeObject:division];
        [button setBackgroundImage:[UIImage imageNamed:@"deselected.png"] forState:UIControlStateNormal];
    } else {
        DLog(@"Selected %@", [division name]);
        [self.selectedDivisions addObject:division];
        [button setBackgroundImage:[UIImage imageNamed:@"selected2.png"] forState:UIControlStateNormal];
    }
    DLog(@"Size %d", [selectedDivisions count]);
    [self saveDivisions];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 3;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (self.editing) {
    //        return UITableViewCellEditingStyleDelete;
    //    }
    return UITableViewCellEditingStyleNone;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    DLog(@"editing");
    [divisionsTableView setEditing:editing animated:YES];
    [super setEditing:editing animated:animated];
    if (!editing) {
//        [self saveDivisions];
        DLog(@"Done leave editmode");
        self.editButtonItem.title = @"Follow";
    }
}

- (void)saveDivisions {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];

    
    NSMutableDictionary *dict = nil;
    for (Division *division in selectedDivisions) {
        DLog(@"save division %@ %@ %@", [division.season league].leagueId, [division season].seasonId, division.divisionId);
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[division.season league].leagueId forKey:@"LeagueId"];
        [dict setObject:[division.season league].name forKey:@"LeagueName"];
        [dict setObject:[season seasonId] forKey:@"SeasonId"];
        [dict setObject:[season name] forKey:@"SeasonName"];
        [dict setObject:division.divisionId forKey:@"DivisionId"];
        [dict setObject:division.name forKey:@"DivisionName"];
        DLog(@"seasonName: %@", [division.season name]);
        [array addObject:dict];
    }
    for (Division *division in otherDivisions) {
        dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[division.season league].leagueId forKey:@"LeagueId"];
        [dict setObject:[division.season league].name forKey:@"LeagueName"];
        [dict setObject:[season seasonId] forKey:@"SeasonId"];
        [dict setObject:[season name] forKey:@"SeasonName"];
        [dict setObject:division.divisionId forKey:@"DivisionId"];
        [dict setObject:division.name forKey:@"DivisionName"];
        DLog(@"seasonName: %@", [division.season name]);
        [array addObject:dict];
    }
    DLog(@"Array size %d", [array count]);
        
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
    [division setSeason:season];
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

@end
