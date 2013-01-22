//
//  FixturesViewController.h
//  Results
//
//  Created by Kinman Li on 02/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

@class Division;

@interface LeagueFixturesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) NSMutableArray *fixtureList;
@property (weak, nonatomic) Division *division;
@property (retain, nonatomic) IBOutlet UITableView *fixturesTable;
@property (weak, nonatomic) IBOutlet UIImageView *leagueBadge;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@end
