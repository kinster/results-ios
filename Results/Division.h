//
//  Division.h
//  Results
//
//  Created by Kinman Li on 07/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Division : NSObject
@property (nonatomic, copy) NSString *theId;
@property (nonatomic, copy) NSString *name;
-(id)initWithIdAndName:(NSString *)theId AndName:(NSString *)name;
@end
