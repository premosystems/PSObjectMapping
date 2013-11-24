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

+ (void) getCommitsWithCompletionBlock:(GHRemoteLogicCompletionBlock)completionBlock
;

- (void) getDetailsWithCompletionBlock:(GHRemoteLogicCompletionBlock)completionBlock;

@end
