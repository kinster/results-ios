//
//  League.m
//  Results
//
//  Created by Kinman Li on 24/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "League.h"

@implementation League
-(id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        return self;
    }
    return nil;
}
@end
