//
//  Club.h
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Club : NSObject {
    NSString *name;
    NSString *badge;
    NSArray *teams;
}

- (void)setName:(NSString *)newName;
- (void)setBadge:(NSString *)newBadge;
- (void)setTeams:(NSArray *)teams;

- (NSString *)name;
- (NSString *)badge;
- (NSArray *)teams;

@end
