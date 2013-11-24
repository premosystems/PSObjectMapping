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
#import "GHConstants.h"

@implementation GHCommit (RemoteLogic)

// See: http://developer.github.com/v3/repos/commits/

+ (void) getCommitsWithCompletionBlock:(GHRemoteLogicCompletionBlock)completionBlock
{
    // /repos/:owner/:repo/commits
    NSString *path = [NSString stringWithFormat:@"repos/%@/%@/commits",kGHRepoOwnerName,kGHRepoName];
    
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

- (void) getDetailsWithCompletionBlock:(GHRemoteLogicCompletionBlock)completionBlock
{
    // /repos/:owner/:repo/commits/:sha
    NSString *path = [NSString stringWithFormat:@"repos/%@/%@/commits/%@",kGHRepoOwnerName,kGHRepoName,self.sha];
    
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
