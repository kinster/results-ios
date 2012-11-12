//
//  League.h
//  Results
//
//  Created by Kinman Li on 24/10/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface League : NSObject
@property (copy, nonatomic) NSString *leagueId;
@property (copy, nonatomic) NSString *name;
@property (retain, nonatomic) UIImage *image;
-(id)initWithIdAndNameAndImage:(NSString *)leagueId AndName:(NSString *)name AndImage:(UIImage *)image;
-(id)initWithIdAndName:(NSString *)leagueId AndName:(NSString *)name;
@end
