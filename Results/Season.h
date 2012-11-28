//
//  Season.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class League;

@interface Season : NSObject
@property (strong, nonatomic) League *league;
@property (copy, nonatomic) NSString *seasonId;
@property (copy, nonatomic) NSString *name;
-(id)initWithIdAndName:(NSString *)seasonId AndName:(NSString *)name;
@end
