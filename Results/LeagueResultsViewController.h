//
//  LeagueResultsViewController.h
//  Results
//
//  Created by Kinman Li on 06/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class Division;

@interface LeagueResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) NSMutableArray *resultsList;
@property (weak, nonatomic) Division *division;
@property (weak, nonatomic) IBOutlet UIImageView *leagueBadge;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UITableView *resultsTable;
@end
