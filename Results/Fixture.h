//
//  Fixture.h
//  Results
//
//  Created by Kinman Li on 03/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Team;

@interface Fixture : NSObject
@property (nonatomic, copy) NSString *fixtureId;
@property (nonatomic, copy) NSString *dateTime;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) Team *homeTeam;
@property (nonatomic, copy) Team *awayTeam;

- (id)initWithIdDateTimeLocationHomeAway:(NSString *)fixtureId AndDateTime:(NSString *)dateTime AndLocation:(NSString *)location AndHomeTeam:(Team *)homeTeam andAwayTeam:(Team *)awayTeam;

@end
