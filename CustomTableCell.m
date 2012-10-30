//
//  CustomTableCell.m
//  Results
//
//  Created by Kinman Li on 21/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "CustomTableCell.h"

@implementation CustomTableCell

@synthesize position, name, badge, wins, draws, losses;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
