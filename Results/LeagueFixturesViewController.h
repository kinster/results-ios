//
//  FixturesViewController.h
//  Results
//
//  Created by Kinman Li on 02/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeagueFixturesViewController : UITableViewController
@property (nonatomic, copy) NSMutableArray *fixtureList;
@property (weak, nonatomic) NSString *leagueSeasonDivisionId;
@end
