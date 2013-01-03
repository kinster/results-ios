//
//  LeagueTableViewController.h
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class CustomTableCell, Division;

@interface LeagueTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate>
@property (copy, nonatomic) NSMutableArray *teamList;
@property (retain, nonatomic) IBOutlet UITableView *leagueTable;
@property (weak, nonatomic) Division *division;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *leagueBadge;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;
@end
