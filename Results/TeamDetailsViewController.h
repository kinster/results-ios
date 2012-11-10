//
//  ClubDetailsViewController.h
//  Results
//
//  Created by Kinman Li on 25/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Team;

@interface TeamDetailsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) NSString *leagueId;
@property (weak, nonatomic) NSString *seasonId;
@property (weak, nonatomic) NSString *divisionId;
@property (weak, nonatomic) Team *team;
@property (nonatomic, copy) NSMutableArray *playersList;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UIImageView *badge;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UITableView *playersTable;
@end
