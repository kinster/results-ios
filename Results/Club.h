//
//  Club.h
//  Football Results
//
//  Created by Kinman Li on 20/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Club : NSObject

@property (retain, nonatomic) NSString *clubId;
@property (retain, nonatomic) NSString *name;
-(id)initWithIdAndName:(NSString *)clubId AndName:(NSString *)name;
@end
