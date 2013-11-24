//
//  GHCommit+PSObjectMapping.m
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/23/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import "GHCommit+PSObjectMapping.h"
#import "NSManagedObject+PSObjectMapping.h"

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

+ (NSDictionary*) customMappings
{
    return @{
             @"commit":[self commitSubPropertiesMapping]
             };
}



#pragma mark - Custom Mapping Blocks -

+ (PSMappingBlock) commitSubPropertiesMapping
{
    return ^id<PSMappableObject>(id<PSMappableObject> object, NSDictionary *allValues, id values) {
        
        GHCommit *commit = (GHCommit*)object;
       
        // Message
        NSString *message = [values objectForKey:@"message"];
        commit.message = message;
        
        // Date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 2013-11-19T23:46:08Z
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        NSString *dateString = [[values objectForKey:@"author"] objectForKey:@"date"];
        
        NSDate *date = [formatter dateFromString:dateString];
        commit.date = date;
        
        return commit;
    };
}





@end
