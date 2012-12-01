//
//  ResultDetailsViewController.m
//  nel
//
//  Created by Kinman Li on 30/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "ResultDetailsViewController.h"
#import "League.h"
#import "Season.h"
#import "Division.h"
#import "Result.h"
#import "ServerManager.h"
#import "Team.h"
#import "MBProgressHUD.h"
#import "CustomResultCell.h"

@interface ResultDetailsViewController ()

@end

@implementation ResultDetailsViewController

@synthesize result, scrollView, reportWebView, homeLabel, awayLabel, homeScore, awayScore;

- (void)loadNetworkExceptionAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Searching...";
    
    [self.navigationController.view addSubview:hud];


    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{

        @try {
            NSError *error;
            
            Division *division = [result division];
            Season *season = [division season];
            
            ServerManager *serverManager = [ServerManager sharedServerManager];
            NSString *serverName = [serverManager serverName];
            NSString *urlString = [serverName stringByAppendingFormat:@"/leagues/%@/seasons/%@/divisions/%@/teams/%@/results/%@.json", [season league].leagueId, season.seasonId, division.divisionId, [result team].teamId, [result resultId]];
            DLog(@"%@", urlString);
            
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *data = [NSData dataWithContentsOfURL:url];
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSString *details = [jsonData objectForKey:@"details"];
            [self result].details = details;
            

            NSString *bodyHtml = [NSString stringWithFormat:@"<html>\n"
                                  "<head> \n"
                                  "<style type=\"text/css\"> \n"
                                  "body {font-family: \"%@\"; font-size: %@;}\n"
                                  "</style> \n"
                                  "</head> \n"
                                  "<body>%@</body> \n"
                                  "</html>", @"helvetica", [NSNumber numberWithInt:17], result.details];
            [reportWebView loadHTMLString:bodyHtml baseURL:nil];
            
        } @catch (NSException *exception) {
            NSLog(@"Exception: %@ %@", [exception name], [exception reason]);
            [self loadNetworkExceptionAlert];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *array = [result.score componentsSeparatedByString:@" - "];
            NSString *hScore = [array objectAtIndex:0];
            NSString *aScore = [array objectAtIndex:1];
            homeLabel.text = [result homeTeam];
            awayLabel.text = [result awayTeam];
            homeScore.text = hScore;
            awayScore.text = aScore;

            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setReportWebView:nil];
    [self setHomeLabel:nil];
    [self setAwayLabel:nil];
    [self setHomeScore:nil];
    [self setAwayScore:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}

@end
