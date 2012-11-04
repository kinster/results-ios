//
//  LeagueFixtureDetailsViewController.m
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "LeagueFixtureDetailsViewController.h"

@interface LeagueFixtureDetailsViewController ()

@end

@implementation LeagueFixtureDetailsViewController

@synthesize fixtureId, dateTime, location, homeTeam, homeBadge, awayTeam, awayBadge;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    
    NSLog(@"LeagueFixtureDetailsViewController");
    NSString *fixtureUrl = [NSString stringWithFormat:@"%s%@%s", "http://localhost:3000/leagues/1/seasons/1/divisions/1/fixtures/", fixtureId, ".json"];
    
    NSLog(@"fixtureUrl: %@", fixtureUrl);
    
    NSURL *url = [NSURL URLWithString:fixtureUrl];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSDictionary *detailsJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"Deails json: %@", detailsJson);
    
    NSString *locationJson = [detailsJson objectForKey:@"location"];
    NSString *dateTimeJson = [detailsJson objectForKey:@"date_time_short"];
    NSDictionary *homeTeamJson = [detailsJson objectForKey:@"home_club_team"];
    NSDictionary *awayTeamJson = [detailsJson objectForKey:@"away_club_team"];
    NSDictionary *homeClub = [homeTeamJson objectForKey:@"club"];
    NSDictionary *awayClub = [awayTeamJson objectForKey:@"club"];
    NSString *homeName = [homeClub objectForKey:@"name"];
    NSString *awayName = [awayClub objectForKey:@"name"];
    NSString *homeBadgeJson = [homeClub objectForKey:@"badge"];
    NSString *awayBadgeJson = [awayClub objectForKey:@"badge"];
    
    NSURL *imageHomeUrl = [NSURL URLWithString:homeBadgeJson];
    NSData *imageHomeData = [[NSData alloc] initWithContentsOfURL:imageHomeUrl];

    NSURL *imageAwayUrl = [NSURL URLWithString:awayBadgeJson];
    NSData *imageAwayData = [[NSData alloc] initWithContentsOfURL:imageAwayUrl];

    self.dateTime.text = dateTimeJson;
    self.location.text = locationJson;
    self.homeTeam.text = homeName;
    self.awayTeam.text = awayName;
    self.homeBadge.image = [[UIImage alloc]initWithData:imageHomeData];
    self.awayBadge.image = [[UIImage alloc]initWithData:imageAwayData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
