//
//  Team.m
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Team.h"

@implementation Team

- (id) initWithTeam:(NSString *)name AndPosition:(NSString *)position AndPlayed:(NSString *)played AndWins:(NSString *)wins AndDraws:(NSString *)draws AndLosses:(NSString *)losses AndGoalsFor:(NSString *)gf AndGoalsAgainst:(NSString *)ga AndGoalDiff:(NSString *)gd AndPoints:(NSString *)points AndTeamId:(NSString *)teamId {
    if (self = [super init]) {
        _position = position;
        _name = name;
        _played = played;
        _wins = wins;
        _draws = draws;
        _losses = losses;
        _goalsFor = gf;
        _goalsAgainst = ga;
        _goalDiff = gd;
        _points = points;
        _teamId = teamId;
    }
    return self;
}

@end
