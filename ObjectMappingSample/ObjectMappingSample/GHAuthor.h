//
//  GHAuthor.h
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/24/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GHCommit;

@interface GHAuthor : NSManagedObject

@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * avatarURLString;
@property (nonatomic, retain) NSSet *commits;
@end

@interface GHAuthor (CoreDataGeneratedAccessors)

- (void)addCommitsObject:(GHCommit *)value;
- (void)removeCommitsObject:(GHCommit *)value;
- (void)addCommits:(NSSet *)values;
- (void)removeCommits:(NSSet *)values;

@end
