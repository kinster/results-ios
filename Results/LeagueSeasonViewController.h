//
//  LeagueSeasonViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class League;

@interface LeagueSeasonViewController : UITableViewController
@property (nonatomic, copy) NSMutableArray *seasonsList;
@property (weak, nonatomic) League *league;
@end
