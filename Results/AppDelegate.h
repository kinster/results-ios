//
//  ResultsAppDelegate.h
//  Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeagueTableViewController.h"
#import "LeagueFixturesViewController.h"

@interface AppDelegate : UIResponder <UITableViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end