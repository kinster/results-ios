//
//  Result.h
//  Results
//
//  Created by Kinman Li on 06/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *homeTeam;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *awayTeam;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *competition;
@property (nonatomic, copy) NSString *statusNote;
@property (nonatomic, copy) NSString *resultId;

@property (nonatomic, copy) NSString *homeBadge;
@property (nonatomic, copy) NSString *awayBadge;
@property (nonatomic, copy) NSString *homeId;
@property (nonatomic, copy) NSString *awayId;
@property (nonatomic, copy) NSMutableArray *reports;

- (id)initWithType:(NSString *)type AndDateTime:(NSString *)dateTime AndHomeTeam:(NSString *)homeTeam AndScore:(NSString *)score AndAwayTeam:(NSString *)awayTeam AndCompetition:(NSString *)competition AndStatusNote:(NSString *)statusNote AndResultId:(NSString *)resultId;
@end
