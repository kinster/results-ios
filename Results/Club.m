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

-(id)initWithName:(NSString *)name AndBadge:(NSString *)badge {
    if (self = [super init]) {
        _name = name;
        _badge = badge;
    }
    return self;
}

-(id)initWithName:(NSString *)name {
    return [self initWithName:name AndBadge:nil];
}

@end
