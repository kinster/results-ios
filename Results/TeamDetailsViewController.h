//
//  ClubDetailsViewController.h
//  Results
//
//  Created by Kinman Li on 25/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamDetailsViewController : UIViewController
@property (weak, nonatomic) NSString *teamId;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UIImageView *badge;
@property (weak, nonatomic) IBOutlet UILabel *name;
@end
