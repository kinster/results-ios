//
//  League.m
//  Results
//
//  Created by Kinman Li on 24/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "League.h"

@implementation League

-(id)initWithIdAndName:(NSString *)leagueId AndName:(NSString *)name {
    if (self = [super init]) {
        _leagueId = leagueId;
        _name = name;
        return self;
    }
    return self;
}
@end
