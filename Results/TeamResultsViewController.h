//
//  TeamResultsViewController.h
//  Results
//
//  Created by Kinman Li on 10/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class Team;

@interface TeamResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate>
@property (copy, nonatomic) NSMutableArray *resultsList;
@property (weak, nonatomic) Team *team;
@property (weak, nonatomic) IBOutlet UIImageView *leagueBadge;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITableView *teamResultsTable;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@end
