//
//  ResultsAppDelegate.h
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Reachability;

@interface AppDelegate : UIResponder {
    Reachability *internetReach;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL internetActive;
@end
