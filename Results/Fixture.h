//
//  Fixture.h
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Division;

@interface Fixture : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *homeTeam;
@property (nonatomic, copy) NSString *awayTeam;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *competition;
@property (nonatomic, copy) NSString *statusNote;
@property (nonatomic, copy) NSString *fixtureId;
@property (nonatomic, strong) Division *division;

- (id)initWithType:(NSString *)type AndDateTime:(NSString *)dateTime AndHomeTeam:(NSString *)homeTeam AndAwayTeam:(NSString *)awayTeam AndLocation:(NSString *)location AndCompetition:(NSString *)competition AndStatusNote:(NSString *)statusNote AndFixtureId:(NSString *)fixtureId;

@end
