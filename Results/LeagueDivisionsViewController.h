//
//  LeagueDetailsViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class League, Season;

@interface LeagueDivisionsViewController : UITableViewController
@property (nonatomic, copy) NSMutableArray *divisionsList;
@property (weak, nonatomic) League *league;
@property (weak, nonatomic) Season *season;
@end
