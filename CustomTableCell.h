//
//  CustomTableCell.h
//  Results
//
//  Created by Kinman Li on 21/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *team;
@property (weak, nonatomic) IBOutlet UILabel *played;
@property (weak, nonatomic) IBOutlet UILabel *wins;
@property (weak, nonatomic) IBOutlet UILabel *draws;
@property (weak, nonatomic) IBOutlet UILabel *losses;
@property (weak, nonatomic) IBOutlet UILabel *goalsFor;
@property (weak, nonatomic) IBOutlet UILabel *goalsAgainst;
@property (weak, nonatomic) IBOutlet UILabel *goalDiff;
@property (weak, nonatomic) IBOutlet UILabel *points;
@end
