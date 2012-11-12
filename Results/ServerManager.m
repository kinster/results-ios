//
//  ServerManager.m
//  Results
//
//  Created by Kinman Li on 12/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import "ServerManager.h"

@implementation ServerManager
@synthesize serverName;

+ (id)sharedServerManager {
    static ServerManager *sharedServerManager = nil;
    @synchronized(self) {
        if (sharedServerManager == nil)
            sharedServerManager = [[self alloc] init];
    }
    return sharedServerManager;    
}

- (id)init {
    if (self = [super init]) {
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        serverName = [infoDict objectForKey:@"jsonServer"];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}
@end
