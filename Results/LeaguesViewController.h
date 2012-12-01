//
//  LeaguesViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Club.h"

@interface LeaguesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) NSMutableArray *leaguesList;
@property (retain, nonatomic) NSDictionary *sections;
@property (strong, nonatomic) IBOutlet UITableView *leagueTablesView;
@property (retain, nonatomic) Club *club;
@end
