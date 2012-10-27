//
//  Club.m
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Club.h"

@implementation Club

- (void)setName:(NSString *)newName {
    name = newName;
}

- (void)setBadge:(NSString *)newBadge {
    badge = newBadge;
}

- (void)setTeams:(NSArray *)newTeams {
    teams = newTeams;
}

- (NSString *)name {
    return name;
}

- (NSString *)badge {
    return badge;
}

- (NSArray *)teams {
    return teams;
}

@end
