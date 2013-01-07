//
//  SavedDivisionsViewController.h
//  Grass Roots
//
//  Created by Kinman Li on 26/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

@class League, Season;

@interface SavedDivisionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *divisionsTableView;
@property (copy, nonatomic) NSMutableArray *divisionsList;
@end
