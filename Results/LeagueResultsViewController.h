//
//  LeagueResultsViewController.h
//  Results
//
//  Created by Kinman Li on 06/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class League, Season, Division;

@interface LeagueResultsViewController : UITableViewController
@property (copy, nonatomic) NSMutableArray *resultsList;
@property (weak, nonatomic) League *league;
@property (weak, nonatomic) Season *season;
@property (weak, nonatomic) Division *division;
@end
