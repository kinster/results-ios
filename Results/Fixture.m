//
//  Fixture.m
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Fixture.h"

@implementation Fixture

- (id)initWithType:(NSString *)type AndDateTime:(NSString *)dateTime AndHomeTeam:(NSString *)homeTeam AndAwayTeam:(NSString *)awayTeam AndLocation:(NSString *)location AndCompetition:(NSString *)competition AndStatusNote:(NSString *)statusNote AndFixtureId:(NSString *)fixtureId {
    if (self = [super init]) {
        _type = type;
        _dateTime = dateTime;
        _homeTeam = homeTeam;
        _awayTeam = awayTeam;
        _location = location;
        _competition = competition;
        _statusNote = statusNote;
        _fixtureId = fixtureId;
    }
    return self;
}
@end
