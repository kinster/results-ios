//
//  TeamFixturesViewController.h
//  Results
//
//  Created by Kinman Li on 09/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class League, Season, Division, Team;

@interface TeamFixturesViewController : UITableViewController
@property (copy, nonatomic) NSMutableArray *fixtureList;
@property (weak, nonatomic) League *league;
@property (weak, nonatomic) Season *season;
@property (weak, nonatomic) Division *division;
@property (weak, nonatomic) Team *team;
@end
