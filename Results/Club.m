//
//  Club.m
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Club.h"

@implementation Club

@synthesize teams;

- (id) initWithName:(NSString *)name AndBadge:(NSString *)badge AndWins:(NSString *)wins AndDraws:(NSString *)draws AndLosses:(NSString *)losses AndGoalsFor:(NSString *)goalsFor AndGoalsAgainst:(NSString *)goalsAgainst AndGoalDiff:(NSString *)goalDiff AndPoints:(NSString *)points AndTeamId:(NSString *)teamId {
    if (self = [super init]) {
        _name = name;
        _badge = badge;
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

- (id)initWithName:(NSString *)name AndBadge:(NSString *)badge {
    return [self initWithName:name AndBadge:badge AndWins:nil AndDraws:nil AndLosses:nil AndGoalsFor:nil AndGoalsAgainst:nil AndGoalDiff:nil AndPoints:nil AndTeamId:nil];
}

- (id)initWithName:(NSString *)name {
    return [self initWithName:name AndBadge:nil];
}

@end
