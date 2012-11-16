//
//  LeaguesViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface LeaguesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, ADBannerViewDelegate>

@property (copy, nonatomic) NSMutableArray *leaguesList;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSDictionary *sections;
@property (strong, nonatomic) IBOutlet UITableView *leagueTablesView;
@end
