//
//  Player.m
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Player.h"

@implementation Player

-(id)initPlayer:(NSString *)name {
    if (self = [super init]) {
    _name = name;
    }
    return self;
}
@end
