//
//  GHFile.h
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/24/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GHCommit;

@interface GHFile : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * sha;
@property (nonatomic, retain) GHCommit *commit;

@end
