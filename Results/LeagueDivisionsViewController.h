//
//  LeagueDetailsViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

@class Season, Club;

@interface LeagueDivisionsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (copy, nonatomic) NSMutableArray *divisionsList;
@property (weak, nonatomic) Season *season;
@property (weak, nonatomic) IBOutlet UITableView *divisionsTableView;
@property (weak, nonatomic) Club *club;
@property (copy, nonatomic) NSMutableArray *selectedDivisions;
@end
