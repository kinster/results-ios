//
//  Season.m
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Season.h"

@implementation Season

@synthesize league;

-(id)initWithIdAndName:(NSString *)seasonId AndName:(NSString *)name {
    if (self = [super init]) {
        _seasonId= seasonId;
        _name = name;
        return self;
    }
    return self;
}
@end
