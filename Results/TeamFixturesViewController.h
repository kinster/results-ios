//
//  TeamFixturesViewController.h
//  Results
//
//  Created by Kinman Li on 09/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

@class Division, Team;

@interface TeamFixturesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) NSMutableArray *fixtureList;
@property (weak, nonatomic) Division *division;
@property (retain, nonatomic) Team *team;
@property (weak, nonatomic) IBOutlet UIImageView *leagueBadge;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UITableView *teamFixturesTable;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@end
