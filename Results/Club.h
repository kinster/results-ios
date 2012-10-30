//
//  Club.h
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Club : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, copy) NSArray *teams;
@property (nonatomic, copy) NSString *wins;
@property (nonatomic, copy) NSString *draws;
@property (nonatomic, copy) NSString *losses;
@property (nonatomic, copy) NSString *goalsFor;
@property (nonatomic, copy) NSString *goalsAgainst;
@property (nonatomic, copy) NSString *goalDiff;
@property (nonatomic, copy) NSString *points;

-(id)initWithName:(NSString *)name AndBadge:(NSString *)badge AndWins:(NSString *)wins AndDraws:(NSString *) draws AndLosses:(NSString *)losses AndGoalsFor:(NSString *)goalsFor AndGoalsAgainst:(NSString *)goalsAgainst AndGoalDiff:(NSString *)goalDiff AndPoints:(NSString *)points;
-(id)initWithName:(NSString *)name AndBadge:(NSString *)badge;
-(id)initWithName:(NSString *)name;

@end
