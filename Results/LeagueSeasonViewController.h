//
//  LeagueSeasonViewController.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

@class League;

@interface LeagueSeasonViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSMutableArray *seasonsList;
@property (weak, nonatomic) League *league;
@property (weak, nonatomic) IBOutlet UITableView *seasonsTableView;
@end
