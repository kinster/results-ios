//
//  LeagueTableViewController.h
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamDetailsViewController.h"

@class CustomTableCell, Division;

@interface LeagueTableViewController : UITableViewController
@property (nonatomic, copy) IBOutlet UIImageView *leagueLogo;
@property (copy, nonatomic) NSString *leagueName;
@property (nonatomic, copy) NSMutableArray *teamList;
@property (nonatomic, assign) int leagueSeasonDivisionId;
@property (nonatomic, copy) NSString *leagueLogoUrl;
@property (nonatomic, copy) NSString *leagueId;
@property (nonatomic, copy) NSString *seasonId;
@property (weak, nonatomic) Division *division;
@end
