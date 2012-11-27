//
//  ClubDetailsViewController.h
//  Results
//
//  Created by Kinman Li on 25/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class League, Season, Division, Team;

@interface TeamDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate>
@property (weak, nonatomic) Team *team;
@property (copy, nonatomic) NSMutableArray *playersList;
@property (weak, nonatomic) IBOutlet UIImageView *badge;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UITableView *playersTable;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@end
