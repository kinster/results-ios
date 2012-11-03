//
//  Team.m
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Team.h"

@implementation Team

- (id) initWithClubName:(NSString *)clubName AndClubBadge:(NSString *)clubBadge AndWins:(NSString *)wins AndDraws:(NSString *)draws AndLosses:(NSString *)losses AndGoalsFor:(NSString *)goalsFor AndGoalsAgainst:(NSString *)goalsAgainst AndGoalDiff:(NSString *)goalDiff AndPoints:(NSString *)points AndTeamId:(NSString *)teamId {
    if (self = [super init]) {
        _clubName = clubName;
        _clubBadge = clubBadge;
        _wins = wins;
        _draws = draws;
        _losses = losses;
        _goalsFor = goalsFor;
        _goalsAgainst = goalsAgainst;
        _goalDiff = goalDiff;
        _points = points;
        _teamId = teamId;
    }
    return self;
}

- (id)initWithClubName:(NSString *)clubName AndClubBadge:(NSString *)clubBadge {
    return [self initWithClubName:clubName AndClubBadge:clubBadge AndWins:nil AndDraws:nil AndLosses:nil AndGoalsFor:nil AndGoalsAgainst:nil AndGoalDiff:nil AndPoints:nil AndTeamId:nil];
}

- (id)initWithClubName:(NSString *)clubName {
    return [self initWithClubName:clubName AndClubBadge:nil];
}
@end
