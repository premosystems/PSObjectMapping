//
//  GHFile.h
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/23/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GHFile : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSManagedObject *commit;

@end
