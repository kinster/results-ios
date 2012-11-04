//
//  Fixture.m
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Fixture.h"

@implementation Fixture

- (id)initWithIdDateTimeLocationHomeAway:(NSString *)fixtureId AndDateTime:(NSString *)dateTime AndLocation:(NSString *)location AndHomeTeam:(Team *)homeTeam andAwayTeam:(Team *)awayTeam {
    if (self = [super init]) {
        _fixtureId = fixtureId;
        _dateTime = dateTime;
        _location = location;
        _homeTeam = homeTeam;
        _awayTeam = awayTeam;
    }
    return self;
}
@end
