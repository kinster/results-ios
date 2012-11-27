//
//  CustomDivisionCell.m
//  nel
//
//  Created by Kinman Li on 22/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "CustomDivisionCell.h"

@implementation CustomDivisionCell

@synthesize radioButton;

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        // Initialization code
        DLog(@"init division cell");
        radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [radioButton setFrame:CGRectMake(0, 8, 30, 30)];
        [radioButton setBackgroundImage:[UIImage imageNamed:@"deselected.png"] forState:UIControlStateNormal];
        radioButton.tag = 1;
        [self.contentView addSubview:radioButton];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect b = [self bounds];
    b.size.height -= 1; // leave room for the separator line
    b.size.width += 5; // allow extra width to slide for editing
    b.origin.x -= (self.editing) ? -15 : 30; // start 30px left unless editing
    [self.contentView setFrame:b];

    if (self.editing) {
        DLog(@"editing subview");
        CGRect lb = [self.textLabel bounds];
        lb.origin.x = 41;
        [self.textLabel setFrame:lb];
    }
}

@end
