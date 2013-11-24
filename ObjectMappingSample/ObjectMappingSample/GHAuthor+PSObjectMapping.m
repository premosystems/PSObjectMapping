//
//  GHAuthor+PSObjectMapping.m
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/23/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import "GHAuthor+PSObjectMapping.h"

@implementation GHAuthor (PSObjectMapping)

+ (NSDictionary*) propertyMappings
{
    return @{
             @"login":@"login",
              @"avatar_url":@"avatarURLString"
             };
}

@end
