//
//  Player.h
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject {
    NSString *forename;
    NSString *surname;
}

- (void)setForename:(NSString *)newForename;
- (void)setSurname:(NSString *)newSurname;

- (NSString *)forename;
- (NSString *)surname;

@end
