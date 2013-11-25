//
//  NSManagedObject+PSObjectMapping.h
//  PSObjectMapping
//
//  Created by Vincil Bishop on 11/23/13.
//
//

#import <CoreData/CoreData.h>

@protocol PSMappableObject;

typedef id<PSMappableObject> (^PSMappingBlock)(id<PSMappableObject> object, NSDictionary *allValues, id values);

@interface NSManagedObject (PSObjectMapping)

+ (NSManagedObject<PSMappableObject>*) objectWithDictionary:(NSDictionary*)dict;
+ (NSManagedObject<PSMappableObject>*) objectWithDictionary:(NSDictionary*)dict mapRelationships:(BOOL)mapRelationships;

+ (NSArray*) mapWithCollection:(id)arrayOrDictionary rootObjectKey:(NSString*)rootObjectKey customObjectMappingBlock:(void (^)(NSDictionary *keyedValues, id object))customObjectMappingBlock mapRelationships:(BOOL)mapRelationships;

- (void)mapWithDictionary:(NSDictionary *)keyedValues;
- (void)mapWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;

+ (void) mapCustomPropertiesWithObject:(id<PSMappableObject>)object andDictionary:(NSDictionary*)dictionary;

- (NSString*) getPropertyMappingForAttribute:(NSString*)attribute;

- (id) refreshedObject;

@end
