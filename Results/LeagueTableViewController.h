//
//  LeagueTableViewController.h
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

@class CustomTableCell, Division;

@interface LeagueTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) NSMutableArray *teamList;
@property (retain, nonatomic) IBOutlet UITableView *leagueTable;
@property (weak, nonatomic) Division *division;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *leagueBadge;
@end
