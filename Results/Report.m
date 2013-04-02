//
//  Report.m
//  Grass Roots Premium
//
//  Created by Kinman Li on 27/03/2013.
//  Copyright (c) 2013 Kinman Li. All rights reserved.
//

#import "Report.h"

@implementation Report

@synthesize type;

-(id)initSummary:(NSString *)summary AndTeamLink:(NSString *)teamLink AndTeamName:(NSString *)teamName {
    if (self = [super init]) {
        _summary = summary;
        _teamLink = teamLink;
        _teamName = teamName;
    }
    return self;
}
@end
