//
//  Fixture.h
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Team;

@interface Fixture : NSObject
@property (nonatomic, copy) NSString *fixtureId;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) Team *homeTeam;
@property (nonatomic, copy) Team *awayTeam;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *hTeam;
@property (nonatomic, copy) NSString *aTeam;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *competition;
@property (nonatomic, copy) NSString *statusNote;


- (id)initWithIdDateTimeLocationHomeAway:(NSString *)fixtureId AndDate:(NSString *)date AndTime:(NSString *)time AndLocation:(NSString *)location AndHomeTeam:(Team *)homeTeam andAwayTeam:(Team *)awayTeam;

- (id)initWithType:(NSString *)type AndDateTime:(NSString *)dateTime AndHomeTeam:(NSString *)homeTeam AndAwayTeam:(NSString *)awayTeam AndLocation:(NSString *)location AndCompetition:(NSString *)competition AndStatusNote:(NSString *)statusNote;

@end
