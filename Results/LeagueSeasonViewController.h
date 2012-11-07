//
//  LeagueSeasonViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeagueSeasonViewController : UITableViewController
@property (nonatomic, copy) NSString *leagueId;
@property (nonatomic, copy) NSMutableArray *seasonsList;
@end
