//
//  GHCommit+RemoteLogic.h
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/23/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import "GHCommit.h"
#import "GHRemoteLogic.h"

@interface GHCommit (RemoteLogic)

+ (void) getCommitsForOwner:(NSString*)owner repo:(NSString*)repo completionBlock:(GHRemoteLogicCompletionBlock)completionBlock
;

@end
