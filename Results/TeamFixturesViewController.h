//
//  TeamFixturesViewController.h
//  Results
//
//  Created by Kinman Li on 09/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamFixturesViewController : UITableViewController
@property (nonatomic, copy) NSMutableArray *fixtureList;
@property (nonatomic, copy) NSString *leagueId;
@property (nonatomic, copy) NSString *seasonId;
@property (nonatomic, copy) NSString *divisionId;
@property (nonatomic, copy) NSString *teamId;
@end
