//
//  LeagueDetailsViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class Season;

@interface LeagueDivisionsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, ADBannerViewDelegate>
@property (nonatomic, copy) NSMutableArray *divisionsList;
@property (weak, nonatomic) Season *season;
@property (weak, nonatomic) IBOutlet UITableView *divisionsTableView;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;
@end
