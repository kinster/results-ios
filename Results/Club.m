//
//  Club.m
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Club.h"

@implementation Club

- (id) initWithIdAndName:(NSString *)clubId AndName:(NSString *)name {
    if (self = [super init]) {
        _clubId = clubId;
        _name = name;
    }
    return self;
}
@end
