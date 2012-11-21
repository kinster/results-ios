//
//  LeagueSeasonViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Club.h"

@class League;

@interface LeagueSeasonViewController : UIViewController<ADBannerViewDelegate>
@property (nonatomic, copy) NSMutableArray *seasonsList;
@property (weak, nonatomic) League *league;
@property (weak, nonatomic) IBOutlet UITableView *seasonsTableView;
@property (weak, nonatomic) Club *club;
@end
