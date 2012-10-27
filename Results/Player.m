//
//  Player.m
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "Player.h"

@implementation Player

- (void)setForename:(NSString *)newForename {
    forename = newForename;
}

- (void)setSurname:(NSString *)newSurname {
    surname = newSurname;
}

- (NSString *)forename {
    return forename;
}

- (NSString *)surname {
    return surname;
}

@end
