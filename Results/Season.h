//
//  Season.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Season : NSObject
@property (nonatomic, copy) NSString *seasonId;
@property (nonatomic, copy) NSString *name;
-(id)initWithIdAndName:(NSString *)seasonId AndName:(NSString *)name;
@end
