//
//  Player.h
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
@property (nonatomic, copy) NSString *name;
- (id)initPlayer:(NSString *)name;
@end
