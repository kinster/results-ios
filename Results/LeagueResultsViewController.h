//
//  LeagueResultsViewController.h
//  Results
//
//  Created by Kinman Li on 06/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeagueResultsViewController : UITableViewController
@property (nonatomic, copy) NSMutableArray *resultsList;
@property (nonatomic, copy) NSString *leagueId;
@property (nonatomic, copy) NSString *seasonId;
@property (nonatomic, copy) NSString *divisionId;
@end
