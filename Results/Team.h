//
//  Team.h
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject
@property (nonatomic, copy) NSString *clubName;
@property (nonatomic, copy) NSString *clubBadge;
@property (nonatomic, copy) NSString *played;
@property (nonatomic, copy) NSString *wins;
@property (nonatomic, copy) NSString *draws;
@property (nonatomic, copy) NSString *losses;
@property (nonatomic, copy) NSString *goalsFor;
@property (nonatomic, copy) NSString *goalsAgainst;
@property (nonatomic, copy) NSString *goalDiff;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *teamId;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *name;

-(id)initWithClubName:(NSString *)clubName AndClubBadge:(NSString *)clubBadge AndPlayed:(NSString *)played AndWins:(NSString *)wins AndDraws:(NSString *) draws AndLosses:(NSString *)losses AndGoalsFor:(NSString *)goalsFor AndGoalsAgainst:(NSString *)goalsAgainst AndGoalDiff:(NSString *)goalDiff AndPoints:(NSString *)points AndTeamId:(NSString *)teamId;
-(id)initWithClubName:(NSString *)clubName AndClubBadge:(NSString *)clubBadge;
-(id)initWithClubName:(NSString *)clubName;

-(id)initWithTeamName:(NSString *)name AndPosition:(NSString *)position AndPlayed:(NSString *)played AndWins:(NSString *)wins AndDraws:(NSString *) draws AndLosses:(NSString *)losses AndGoalsFor:(NSString *)gf AndGoalsAgainst:(NSString *)ga AndGoalDiff:(NSString *)gd AndPoints:(NSString *)points;

@end
