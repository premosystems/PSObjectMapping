//
//  NSManagedObject+PSObjectMapping.m
//  PSObjectMapping
//
//  Created by Vincil Bishop on 11/23/13.
//
//

#import "NSManagedObject+PSObjectMapping.h"
#import "PSMappableObject.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@implementation NSManagedObject (PSObjectMapping)

#pragma mark - Serialization Methods -

+ (NSManagedObject<PSMappableObject>*) objectWithDictionary:(NSDictionary*)dict
{
    return [self objectWithDictionary:dict mapRelationships:YES];
}

+ (NSManagedObject<PSMappableObject>*) objectWithDictionary:(NSDictionary*)dict mapRelationships:(BOOL)mapRelationships
{
    [[NSManagedObjectContext contextForCurrentThread] setUndoManager:nil];
    
    Class<PSMappableObject> remoteObject = [self class];
    
    NSString *remotePrimaryKeyProperty = [self remotePrimaryKeyWithDictionary:dict];
    
    __block NSManagedObject *object = nil;
    
    void (^PSObjectMappingBlock)(void) = ^()
    {
        // Let's do custom mapping first in case the primary key is contained here...
        if ([[object class] respondsToSelector:@selector(customMappings)]) {
            
            if ([(id<PSMappableObject>)[object class] customMappings]) {
                [[object class] mapCustomPropertiesWithObject:(id<PSMappableObject>)object andDictionary:dict];
            }
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        [object mapWithDictionary:dict dateFormatter:dateFormatter];
        
        if (mapRelationships) {
            if ([[object class] respondsToSelector:@selector(relationshipMappings)]) {
                [object mapRelationshipsWithDictionary:dict];
            }
        }
    };
            
        // Let's just get a count instead of a query
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",[self objectPrimaryKeyProperty],[dict valueForKey:remotePrimaryKeyProperty]];
        
        NSUInteger countInDefaultConext = [remoteObject countOfEntitiesWithPredicate:predicate inContext:[NSManagedObjectContext contextForCurrentThread]];
        
        // If the object exists, then let's fetch it from the current context
        if (countInDefaultConext > 0) {
            // This is bad if we get here, because we this means we will likely hit the persistent store, that is where our slowdown is...
            object = [remoteObject findFirstByAttribute:[self objectPrimaryKeyProperty] withValue:[dict valueForKey:remotePrimaryKeyProperty] inContext:[NSManagedObjectContext contextForCurrentThread]];
            
            PSObjectMappingBlock();
        }
        
        if (!object) {
            
            object = [remoteObject createInContext:[NSManagedObjectContext contextForCurrentThread]];
            
            PSObjectMappingBlock();
        }
    
    return (NSManagedObject<PSMappableObject>*)object;
}

+ (NSArray*) mapWithCollection:(id)arrayOrDictionary rootObjectKey:(NSString*)rootObjectKey customObjectMappingBlock:(void (^)(NSDictionary *keyedValues, id object))customObjectMappingBlock mapRelationships:(BOOL)mapRelationships
{
    __block NSMutableArray *managedObjectIDs = [[NSMutableArray alloc] init];
    
    if (arrayOrDictionary == nil)
    { // when no objects were passed to the method
        
        return nil;
        
    } else { // Single Object case
        
        if (rootObjectKey == nil && [arrayOrDictionary isKindOfClass:[NSDictionary class]]) {
            
            // Map the single object
            NSManagedObject<PSMappableObject> *object = [[self class] objectWithDictionary:(NSDictionary*)arrayOrDictionary mapRelationships:mapRelationships];
            if (customObjectMappingBlock) {
                customObjectMappingBlock(arrayOrDictionary,object);
            }
            
            [managedObjectIDs addObject:object.objectID];
        }
        else // Map and array of objects
        {
            NSArray *rawArray = nil;
            
            if (rootObjectKey != nil && [arrayOrDictionary isKindOfClass:[NSDictionary class]])
            {
                rawArray = [(NSDictionary*)arrayOrDictionary objectForKey:rootObjectKey];
                
            } else if ([arrayOrDictionary isKindOfClass:[NSArray class]])
            {
                rawArray = arrayOrDictionary;
                
            } else {
                
                NSAssert(NO,@"arrayOrDictionary must be an NSArray or an NSDictionry!");
            }
            
            // Map the collection
            [rawArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                NSManagedObject<PSMappableObject> *object = [[self class] objectWithDictionary:(NSDictionary*)obj mapRelationships:mapRelationships];
                if (customObjectMappingBlock) {
                    customObjectMappingBlock(obj, object);
                }
                
                [managedObjectIDs addObject:object.objectID];
            }];
        }
    }
    
    return managedObjectIDs;
}

#pragma mark - Custom Mapping -

+ (void) mapCustomPropertiesWithObject:(id<PSMappableObject>)object andDictionary:(NSDictionary*)dictionary
{
    __block id<PSMappableObject> blockObject = object;
    
    [[[self class] customMappings] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id customValue = nil;
        NSString *propertyName = nil;
        NSString *relationshipName = nil;
        
        // Let's try to match the key to a remote JSON response property
        customValue = [dictionary valueForKey:key];
        propertyName = [((NSManagedObject*)object).entity.attributesByName objectForKey:key];
        relationshipName = [((NSManagedObject*)object).entity.relationshipsByName objectForKey:key];
        
        if (customValue || relationshipName || propertyName) {
            
            PSMappingBlock mappingBlock = (PSMappingBlock)obj;
            
            if (mappingBlock) {
                blockObject = mappingBlock(blockObject,dictionary,customValue);
            }
        }
    }];
}

#pragma mark - Property Mapping -

- (void)mapWithDictionary:(NSDictionary *)keyedValues
{
    // TODO: Add a default date formatter here
    [self mapWithDictionary:keyedValues dateFormatter:nil];
}

// TODO: We probably need to add a block exception here so that we can map Relationships entities...
- (void)mapWithDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter
{
    // Get all present remote attributes
    NSArray *allRemoteAttributes = [keyedValues allKeys];
    // Get all existing local attributes
    // NSArray *attributeNames = [[self propertyMappings] allKeys];
    NSArray *remoteAttributes = [[self propertyMappings] allKeys];
    // Get present & mapped remote attributes
    NSArray *presentMappedRemoteAttributes = [remoteAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self in %@",allRemoteAttributes]];
    NSDictionary *attributes = [[self entity] attributesByName];
    
    // Extract the intersection between local & remote
    for (NSString *mappedProperty in presentMappedRemoteAttributes) {
        
        void (^CPMappedPropertyBlock)() = ^(NSString *attribute, NSString *mappedProperty, NSDictionary *keyedValues)
        {
            id value = nil;
            value = [keyedValues objectForKey:mappedProperty];
            
            // Let's check out the property mappings on the object and see if we ned to do anything special for this attribute``
            // If the value is empty, let's just not do anything...
            if (value != nil && value != [NSNull null]) {
                NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
                if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
                    value = [value stringValue];
                } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
                    value = [NSNumber numberWithInteger:[value integerValue]];
                } else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
                    value = [NSNumber numberWithDouble:[value doubleValue]];
                } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && (dateFormatter != nil)) {
                    value = [dateFormatter dateFromString:value];
                }
                
                [self setValue:value forKey:attribute];
                
            }
            
        };
        
        id attribute = [[self propertyMappings] valueForKey:mappedProperty];
        
        // If there is more than one core data property mapped to the remote property
        if ([attribute isKindOfClass:[NSArray class]]) {
            
            for (NSString *compundAttribute in attribute) {
                
                CPMappedPropertyBlock(compundAttribute,mappedProperty,keyedValues);
            }
            
        } else { // Or in most cases it will only be a single string attribute
            
            CPMappedPropertyBlock(attribute,mappedProperty,keyedValues);
        }
    }
}

#pragma mark - Relationship Mapping -

- (void) mapRelationshipsWithDictionary:(NSDictionary*)dict
{
    NSDictionary *relationshipMappings = [self relationshipMappings];
    
    NSArray *remoteRelationships = [relationshipMappings allValues];
    
    NSArray *presentRemoteRelationships = [remoteRelationships filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self in %@",[dict allKeys]]];
    
    [presentRemoteRelationships enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *remoteRelationship = (NSString*)obj;
        
        NSDictionary *relationships = [[self entity] relationshipsByName];
        NSString *localRelationshipKey = [relationshipMappings allKeysForObject:remoteRelationship][0];
        NSRelationshipDescription *relationshipDesc = [relationships objectForKey:localRelationshipKey];
        NSEntityDescription *entity = [relationshipDesc destinationEntity];
        
        id relatedJSON = [dict objectForKey:remoteRelationship];
        
        
        if (relatedJSON != nil && relatedJSON != [NSNull null]) {
            
            void (^CPRelationshipMappingBlock)() = ^(id remotePrimaryKeyValue)
            {
                Class<PSMappableObject> mappableObject = NSClassFromString(relationshipDesc.destinationEntity.name);
                NSString *remotePrimaryKeyProperty = [mappableObject remotePrimaryKeyWithDictionary:dict];
                
                NSDictionary *objDict = @{remotePrimaryKeyProperty:remotePrimaryKeyValue};
                [self mapRelationship:relationshipDesc dictionary:objDict entity:entity];
                
                
            };
            
            
            if ([relatedJSON  isKindOfClass:[NSArray class]]) {
                
                for (id assocObj in relatedJSON) {
                    if ([assocObj isKindOfClass:[NSDictionary class]]) {
                        
                        if (relatedJSON != nil && relatedJSON != [NSNull null]) {
                            
                            [self mapRelationship:relationshipDesc dictionary:assocObj entity:entity];
                            
                        }
                    } else { // If this is an ID only relationship
                        
                        CPRelationshipMappingBlock(assocObj);
                        
                    }
                }
                
            } else if ([relatedJSON  isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *assocObj;
                
                // If this is a one to one relationship with a single JSON entity
                if ([relatedJSON  isKindOfClass:[NSDictionary class]]) {
                    
                    assocObj = relatedJSON;
                    
                }  else { // If this is an ID only relationship
                    
                    assocObj = @{[relationshipDesc.destinationEntity.userInfo valueForKey:@"primaryKey"]:relatedJSON};
                }
                
                [self mapRelationship:relationshipDesc dictionary:assocObj entity:entity];
                
            } else { // 1:1 mapping
                CPRelationshipMappingBlock(relatedJSON);
            }
        }
        
    }];
}

- (void) mapRelationship:(NSRelationshipDescription*)relationshipDescription dictionary:(NSDictionary*)assocObj entity:(NSEntityDescription*)entity
{
    NSAssert(assocObj, @"Must have related object!");
    
    NSString *relationshipName = relationshipDescription.name;
    
    Class<PSMappableObject> theClass = NSClassFromString(relationshipDescription.destinationEntity.managedObjectClassName);
    id tempObject = [theClass objectWithDictionary:assocObj];
    
    // Let's uppercase the first letter of the relationship name so that we can form the right selector
    NSString *upperCaseRelationshipName = [relationshipName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[relationshipName substringToIndex:1] uppercaseString]];
    
    NSString *relationshipSetter = nil;
    
    if (relationshipDescription.maxCount == 1) { // To One Relationship
        
        relationshipSetter = [NSString stringWithFormat:@"set%@:",upperCaseRelationshipName];
        
    } else { // To Many Relationship
        
        relationshipSetter = [NSString stringWithFormat:@"add%@Object:",upperCaseRelationshipName];
    }
    
    SEL relationshipSelector = NSSelectorFromString(relationshipSetter);
    
    if (relationshipSetter) {
        // For some reason, NSManagedObject always responds yes to this call..
        if ([self respondsToSelector:relationshipSelector]) {
            
            @try {
                SuppressPerformSelectorLeakWarning(
                                                   [self performSelector:relationshipSelector withObject:tempObject];
                                                   );
                
            }
            @catch (NSException *exception) {
                // do nothing
                NSString *logString = [NSString stringWithFormat:@"Error mappinging relationship: %@ %@ %@ %@",relationshipDescription,assocObj,entity,[exception description]];
                // DDLogVerbose(@"%@",logString);
                NSAssert(NO,logString);
            }
            @finally {
                // nothing
            }
        }
    }
}

- (NSString*) getAssociationMappingForRelationship:(NSString*)relationship
{
    NSString *relationshipName = nil;
    if ([[self class] respondsToSelector:@selector(relationshipMappings)]) {
        NSDictionary *relationshipMappings = [self relationshipMappings];
        if (relationshipMappings) {
            relationshipName =  [relationshipMappings valueForKey:relationship];
        }
    }
    
    return relationshipName;
}

- (NSString*) getPropertyMappingForAttribute:(NSString*)attribute
{
    NSString *mappedPropertyName = nil;
    NSDictionary *propertyMappings = [self propertyMappings];
    mappedPropertyName =  [propertyMappings valueForKey:attribute];
    return mappedPropertyName;
}

#pragma mark - Mapping Helpers -

- (NSDictionary*) propertyMappings
{
    Class<PSMappableObject> remoteObjectType = [self class];
    return [[remoteObjectType propertyMappings] copy];
}

- (NSDictionary*) relationshipMappings
{
    Class<PSMappableObject> remoteObjectType = [self class];
    return [[remoteObjectType relationshipMappings] copy];
}

- (NSDictionary*) customMappings
{
    Class<PSMappableObject> remoteObjectType = [self class];
    return [[remoteObjectType customMappings] copy];
}


#pragma mark - Primary key helper methods -

+ (NSString*) objectPrimaryKeyProperty
{
    NSString *objectPrimaryKey = [[self entityDescription].userInfo valueForKey:@"primaryKey"];
    return objectPrimaryKey;
}

+ (id) remotePrimaryKeyProperty
{
    NSDictionary *propertyMappings = [(Class<PSMappableObject>)self propertyMappings];
    NSArray *remotePrimaryKeyArray = [propertyMappings allKeysForObject:[self objectPrimaryKeyProperty]];
    
    if ([remotePrimaryKeyArray count] == 1) {
        return remotePrimaryKeyArray[0];
    }
    
    return remotePrimaryKeyArray;
}

+ (NSString*) remotePrimaryKeyWithDictionary:(NSDictionary*)dict
{
    __block NSString *remotePrimaryKeyProperty = nil;
    
    if ([[self remotePrimaryKeyProperty] isKindOfClass:[NSArray class]]) {
        
        [((NSArray*)[self remotePrimaryKeyProperty]) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            id remotePrimaryKeyValue = nil;
            remotePrimaryKeyValue = [dict valueForKey:obj];
            
            if (remotePrimaryKeyValue) {
                
                remotePrimaryKeyProperty = obj;
                
                *stop = YES;
            }
        }];
        
    } else {
        remotePrimaryKeyProperty = [self remotePrimaryKeyProperty];
    }
    
    return remotePrimaryKeyProperty;
    
}

- (NSString*) objectPrimaryKeyProperty
{
    return [[self class] objectPrimaryKeyProperty];
}

- (NSString*) remotePrimaryKeyProperty
{
    return [[self class] remotePrimaryKeyProperty];
}

#pragma mark - Convenience Methods -

- (Class<PSMappableObject>) staticType
{
    return (Class<PSMappableObject>)[self class];
}

- (BOOL) isRemotableObject
{
    return ([self conformsToProtocol:@protocol(PSMappableObject)]);
}

- (id) refreshedObject
{
    [[NSManagedObjectContext contextForCurrentThread] refreshObject:self mergeChanges:YES];
    
    return self;
}

@end
