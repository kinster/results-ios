//
//  SavedDivisionsViewController.h
//  nel
//
//  Created by Kinman Li on 24/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

@interface SavedDivisionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *divisionsTableView;
@property (copy, nonatomic) NSMutableArray *divisionsList;
@end
