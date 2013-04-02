//
//  TeamLinksViewController.h
//  Grass Roots Premium
//
//  Created by Kinman Li on 02/04/2013.
//  Copyright (c) 2013 Kinman Li. All rights reserved.
//

@class Division, Result, Team;

@interface TeamLinksViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) Division *division;
@property (weak, nonatomic) Result *result;
@property (weak, nonatomic) Team *team;
@property (weak, nonatomic) IBOutlet UITableView *teamLinksTable;
@end
