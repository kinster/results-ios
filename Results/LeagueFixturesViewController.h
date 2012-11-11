//
//  FixturesViewController.h
//  Results
//
//  Created by Kinman Li on 02/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class League, Season, Division;

@interface LeagueFixturesViewController : UITableViewController
@property (copy, nonatomic) NSMutableArray *fixtureList;
@property (weak, nonatomic) League *league;
@property (weak, nonatomic) Season *season;
@property (weak, nonatomic) Division *division;
@end
