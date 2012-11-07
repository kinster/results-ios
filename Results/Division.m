//
//  Division.m
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Division.h"

@implementation Division
- (id)initWithIdAndName:(NSString *)divisionId AndName:(NSString *)divisionName {
    if (self = [super init]) {
        _divisionId = divisionId;
        _divisionName = divisionName;
        return self;
    }
    return self;
}
@end
