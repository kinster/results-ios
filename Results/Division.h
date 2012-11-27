//
//  Division.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Season;

@interface Division : NSObject
@property (strong, nonatomic) Season *season;
@property (copy, nonatomic) NSString *divisionId;
@property (copy, nonatomic) NSString *name;
-(id)initWithIdAndName:(NSString *)divisionId AndName:(NSString *)name;
@end
