//
//  Fixture.m
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Fixture.h"

@implementation Fixture

- (id)initWithIdDateTimeLocationHomeAway:(NSString *)fixtureId AndDate:(NSString *)date AndTime:(NSString *)time AndLocation:(NSString *)location AndHomeTeam:(Team *)homeTeam andAwayTeam:(Team *)awayTeam {
    if (self = [super init]) {
        _fixtureId = fixtureId;
        _date = date;
        
        _location = location;
        _homeTeam = homeTeam;
        _awayTeam = awayTeam;
    }
    return self;
}

- (id)initWithType:(NSString *)type AndDateTime:(NSString *)dateTime AndHomeTeam:(NSString *)homeTeam AndAwayTeam:(NSString *)awayTeam AndLocation:(NSString *)location AndCompetition:(NSString *)competition AndStatusNote:(NSString *)statusNote {
    if (self = [super init]) {
        _type = type;
        _dateTime = dateTime;
        _hTeam = homeTeam;
        _aTeam = awayTeam;
        _location = location;
        _competition = competition;
        _statusNote = statusNote;
    }
    return self;
}
@end
