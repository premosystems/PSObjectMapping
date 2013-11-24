//
//  GHCommit.h
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/24/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GHAuthor, GHFile;

@interface GHCommit : NSManagedObject

@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) GHAuthor *author;
@property (nonatomic, retain) NSSet *files;
@end

@interface GHCommit (CoreDataGeneratedAccessors)

- (void)addFilesObject:(GHFile *)value;
- (void)removeFilesObject:(GHFile *)value;
- (void)addFiles:(NSSet *)values;
- (void)removeFiles:(NSSet *)values;

@end
