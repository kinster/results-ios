//
//  Report.h
//  Grass Roots Premium
//
//  Created by Kinman Li on 27/03/2013.
//  Copyright (c) 2013 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Report : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *teamLink;
@property (nonatomic, copy) NSString *summary;
- (id)initSummary:(NSString *)summary AndTeamLink:(NSString *)teamLink AndTeamName:(NSString *)teamName;
@end
