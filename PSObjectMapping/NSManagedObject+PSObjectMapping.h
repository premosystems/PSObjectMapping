//
//  NSManagedObject+PSObjectMapping.h
//  PSObjectMapping
//
//  Created by Vincil Bishop on 11/23/13.
//
//

#import <CoreData/CoreData.h>

@protocol PSMappableObject;

typedef id<PSMappableObject> (^CPKMappingBlock)(id<PSMappableObject> object, NSDictionary *allValues, id values);

@interface NSManagedObject (PSObjectMapping)

+ (id) objectWithDictionary:(NSDictionary*)dict;
+ (id) objectWithDictionary:(NSDictionary*)dict mapRelationships:(BOOL)mapRelationships;

+ (void) mapWithCollection:(id)arrayOrDictionary rootObjectKey:(NSString*)rootObjectKey customObjectMappingBlock:(void (^)(NSDictionary *keyedValues, id object))customObjectMappingBlock mapRelationships:(BOOL)mapRelationships;

- (void)mapWithDictionary:(NSDictionary *)keyedValues;
- (void)mapWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;

+ (void) mapCustomPropertiesWithObject:(id<PSMappableObject>)object andDictionary:(NSDictionary*)dictionary;

- (NSString*) getPropertyMappingForAttribute:(NSString*)attribute;

- (id) refreshedObject;

@end
