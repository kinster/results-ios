//
//  LeagueDetailsViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class League, Season;

@interface LeagueDivisionsViewController : UIViewController<ADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSMutableArray *divisionsList;
@property (weak, nonatomic) League *league;
@property (weak, nonatomic) Season *season;
@property (weak, nonatomic) IBOutlet UITableView *divisionsTableView;
@property (copy, nonatomic) NSMutableArray *readDivisions;
@property (copy, nonatomic) NSMutableArray *selectedDivisions;
@end
