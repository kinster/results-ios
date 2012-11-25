//
//  CustomDivisionCell.m
//  nel
//
//  Created by Kinman Li on 22/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "CustomDivisionCell.h"

@implementation CustomDivisionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)willTransitionToState:(UITableViewCellStateMask)state {
    NSString *logStr = @"Invoked";
    if ((state & UITableViewCellStateShowingEditControlMask) != 0) {
        // you need to move the controls in left
        logStr = [NSString stringWithFormat:@"%@%@",logStr,@"UITableViewCellStateShowingEditControlMask"];
    }
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) != 0) {
        // you need to hide the controls for the delete button
        logStr = [NSString stringWithFormat:@"%@%@",logStr,@"UITableViewCellStateShowingDeleteConfirmationMask"];
    }
    DLog(@"%@",logStr);
    [super willTransitionToState:state];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (animated) {
        [UIView beginAnimations:@"setEditingAnimation" context:nil];
        [UIView setAnimationDuration:0.3];
    }
    
    if (editing) {
        /* do your offset and resize here */
        DLog(@"editing");
        
    } else {
        /* return to the original here*/
        DLog(@"not editing");
    }
    
    if (animated)
        [UIView commitAnimations];
}
@end
