//
//  TeamResultsViewController.h
//  Results
//
//  Created by Kinman Li on 10/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Team;

@interface TeamResultsViewController : UITableViewController
@property (nonatomic, copy) NSMutableArray *resultsList;
@property (nonatomic, copy) NSString *leagueId;
@property (nonatomic, copy) NSString *seasonId;
@property (nonatomic, copy) NSString *divisionId;
@property (nonatomic, weak) Team *team;
@end
