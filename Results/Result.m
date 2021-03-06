//
//  Result.m
//  Results
//
//  Created by Kinman Li on 06/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Result.h"

@implementation Result

@synthesize homeBadge, awayBadge, homeId, awayId;

- (id)initWithType:(NSString *)type AndDateTime:(NSString *)dateTime AndHomeTeam:(NSString *)homeTeam AndScore:(NSString *)score AndAwayTeam:(NSString *)awayTeam AndCompetition:(NSString *)competition AndStatusNote:(NSString *)statusNote AndResultId:(NSString *)resultId {
    if (self = [super init]) {
        _type = type;
        _dateTime = dateTime;
        _homeTeam = homeTeam;
        _score = score;
        _awayTeam = awayTeam;
        _competition = competition;
        _statusNote = statusNote;
        _resultId = resultId;
    }
    return self;
}
@end
