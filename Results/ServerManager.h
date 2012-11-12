//
//  ServerManager.h
//  Results
//
//  Created by Kinman Li on 12/11/2012.
//  Copyright (c) 2012 Kinman Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject
@property (retain, nonatomic) NSString *serverName;
+(id)sharedServerManager;
@end
