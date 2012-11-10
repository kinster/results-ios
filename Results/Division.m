//
//  Division.m
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Division.h"

@implementation Division
- (id)initWithIdAndName:(NSString *)divisionId AndName:(NSString *)name {
    if (self = [super init]) {
        _divisionId = divisionId;
        _name = name;
    }
    return self;
}
@end
