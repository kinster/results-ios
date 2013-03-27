//
//  ReportsViewController.m
//  Grass Roots Premium
//
//  Created by Kinman Li on 26/03/2013.
//  Copyright (c) 2013 Kinman Li. All rights reserved.
//

#import "ReportsViewController.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "Result.h"
#import "CustomResultCell.h"
#import "ServerManager.h"
#import "MBProgressHUD.h"

@interface ReportsViewController ()

@end

@implementation ReportsViewController

@synthesize division, result, detailView;

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
        
        NSMutableArray *reports = [jsonData objectForKey:@"details"];
        NSString *detailString =[[NSString alloc] init];
        for (NSString *report in reports) {
            detailString = [detailString stringByAppendingFormat:@"%@", report];
        }
        result.reports = reports;
        NSString *bodyHtml = [NSString stringWithFormat:@"<html>\n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {font-family: \"%@\"; font-size: %@;}\n"
                              "</style> \n"
                              "</head> \n"
                              "<body>%@</body> \n"
                              "</html>", @"helvetica", [NSNumber numberWithInt:17], detailString];
        [detailView loadHTMLString:bodyHtml baseURL:nil];

    } @catch (NSException *exception) {
        NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
        [self loadNetworkExceptionAlert];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DLog(@"ReportsViewController");
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self loadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            DLog(@"done");
        });
    });
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [self setDetailView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
