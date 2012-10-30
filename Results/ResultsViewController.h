//
//  ResultsViewController.h
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubDetailsViewController.h"

@class CustomTableCell;

@interface ResultsViewController : UITableViewController
@property (nonatomic, retain) IBOutlet UIImageView *leagueLogo;
@property (copy, nonatomic) NSString *leagueName;
@property (nonatomic, copy) NSMutableArray *clubList;
@property (strong, nonatomic) ClubDetailsViewController *clubDetailsViewController;
@end
