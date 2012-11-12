//
//  League.m
//  Results
//
//  Created by Kinman Li on 24/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "League.h"

@implementation League

-(id)initWithIdAndNameAndImage:(NSString *)leagueId AndName:(NSString *)name AndImage:(UIImage *)image {
    if (self = [super init]) {
        _leagueId = leagueId;
        _name = name;
        _image = image;
        return self;
    }
    return self;
}

-(id)initWithIdAndName:(NSString *)leagueId AndName:(NSString *)name {
    return [self initWithIdAndNameAndImage:leagueId AndName:name AndImage:nil];
}
@end
