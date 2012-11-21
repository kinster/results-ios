//
//  LeaguesViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Club.h"

@interface LeaguesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate>

@property (copy, nonatomic) NSMutableArray *leaguesList;
@property (retain, nonatomic) NSDictionary *sections;
@property (strong, nonatomic) IBOutlet UITableView *leagueTablesView;
@property (retain, nonatomic) Club *club;
@end
