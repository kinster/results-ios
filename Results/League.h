//
//  League.h
//  Results
//
//  Created by Kinman Li on 24/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface League : NSObject
@property (nonatomic, copy) NSString *leagueId;
@property (nonatomic, copy) NSString *name;
-(id)initWithIdAndName:(NSString *)leagueId AndName:(NSString *)name;
@end
