//
//  LeagueDetailsViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

@class Season;

@interface LeagueDivisionsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) NSMutableArray *divisionsList;
@property (weak, nonatomic) Season *season;
@property (weak, nonatomic) IBOutlet UITableView *divisionsTableView;
@property (copy, nonatomic) NSMutableArray *selectedDivisions;
@property (copy, nonatomic) NSMutableArray *otherDivisions;
@end
