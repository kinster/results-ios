//
//  LeaguesViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaguesViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (copy, nonatomic) NSMutableArray *leaguesList;
@property (strong, nonatomic) NSMutableArray* filteredLeaguesList;
@property (assign, nonatomic) Boolean isFiltered;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSDictionary *sections;
@property (nonatomic, retain) NSArray *alphabet;
@end
