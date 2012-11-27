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

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToWidget:other];
}

- (BOOL)isEqualToWidget:(Division *)aWidget {
    if (self == aWidget)
        return YES;
    if (![(id)[self divisionId] isEqual:[aWidget divisionId]])
        return NO;
    if (![[self name] isEqualToString:[aWidget name]])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash += [[self divisionId] hash];
    hash += [[self name] hash];
    return hash;
}

@end
