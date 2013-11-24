//
//  GHCommit+RemoteLogic.m
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/23/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import "GHCommit+RemoteLogic.h"
#import "GHCommit+PSObjectMapping.h"
#import "NSManagedObject+PSObjectMapping.h"
#import "GHAPIClient.h"


@implementation GHCommit (RemoteLogic)

+ (void) getCommitsForOwner:(NSString*)owner repo:(NSString*)repo completionBlock:(GHRemoteLogicCompletionBlock)completionBlock
{
    // repos/AFNetworking/AFNetworking/
    NSString *path = [NSString stringWithFormat:@"repos/%@/%@/commits",owner,repo];
    
    [[GHAPIClient sharedClient] GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"responseObject: %@",responseObject);
        
        [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            
            NSArray *objectIDs = [GHCommit mapWithCollection:responseObject rootObjectKey:nil customObjectMappingBlock:nil mapRelationships:YES];
            
            if (completionBlock) {
                completionBlock(objectIDs,nil);
            }
            
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"error: %@",[error localizedDescription]);
        
        if (completionBlock) {
            completionBlock(nil,error);
        }
        
    }];
}

@end
