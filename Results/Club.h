//
//  Club.h
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Club : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, copy) NSArray *teams;


-(id)initWithName:(NSString *)name AndBadge:(NSString *)badge;
-(id)initWithName:(NSString *)name;

@end
