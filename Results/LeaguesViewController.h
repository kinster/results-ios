//
//  LeaguesViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaguesViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, copy) NSMutableArray *leaguesList;
@property (strong, nonatomic) NSMutableArray* filteredLeaguesList;
@property (nonatomic, assign) Boolean isFiltered;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@end
