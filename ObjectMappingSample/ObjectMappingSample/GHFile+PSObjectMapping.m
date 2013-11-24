//
//  GHFile+PSObjectMapping.m
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/23/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import "GHFile+PSObjectMapping.h"

@implementation GHFile (PSObjectMapping)

+ (NSDictionary*) propertyMappings
{
    return @{
             @"url":@"raw_url",
             @"filename":@"filename",
             @"sha":@"sha"
             };
}


@end
