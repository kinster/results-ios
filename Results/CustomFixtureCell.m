//
//  CustomFixtureCell.m
//  Results
//
//  Created by Kinman Li on 04/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "CustomFixtureCell.h"

@implementation CustomFixtureCell

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
