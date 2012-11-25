//
//  Division.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Division : NSObject
@property (copy, nonatomic) NSString *divisionId;
@property (copy, nonatomic) NSString *name;
@property (nonatomic) BOOL selected;
-(id)initWithIdAndName:(NSString *)divisionId AndName:(NSString *)name;
@end
