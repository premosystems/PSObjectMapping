//
//  GHCommit+PSObjectMapping.m
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/23/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import "GHCommit+PSObjectMapping.h"

@implementation GHCommit (PSObjectMapping)

+ (NSDictionary*) propertyMappings
{
    return @{
             @"sha":@"sha",
             @"url":@"url"
             };
}

+ (NSDictionary*) relationshipMappings
{
    return @{
             @"author":@"author",
             @"files":@"files"
             };
}

@end
