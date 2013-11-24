# PSObjectMapping


## Overview

PSObjectMapping maps NSDictionary and NSArray collections to CoreData NSManagedObjects.

The solution consists of a category on NSManagedObject and a protocol describing a PSMappableObject.

The development of PSObjectMapping came out of a personal need, and although it is being used in production, it is still very much a work in progress.

## Example Setup

To support object mapping, you must tell PSObjectMapping whih property on your XCDataModel is the object's primary key. An example is depicted in the screenshot below.

![XCode Data Model Primary Key Setup](https://raw.github.com/premosystems/PSObjectMapping/gh-pages/xcdatamodel-primary-key-screenshot.png)

For PSObjectMapping to know how to map data from an NSDictionary to NSManagedObject attributes, create a category on each NSManagedObject subclass with methods similar to the following.

```objective-c
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
```

## Example Usage

To use PSObjectMapping there exists a class method applied to all PSMappableObjects:

```objective-c
+ (NSArray*) mapWithCollection:(id)arrayOrDictionary rootObjectKey:(NSString*)rootObjectKey customObjectMappingBlock:(void (^)(NSDictionary *keyedValues, id object))customObjectMappingBlock mapRelationships:(BOOL)mapRelationships;
```

Pass the NSArray or NSDictionary containing keyed values to this method, and an array of NSManagedObjectIDs is returned for the objects that were mapped.

```objective-c
NSArray *objectIDs = [GHCommit mapWithCollection:responseObject rootObjectKey:nil customObjectMappingBlock:nil mapRelationships:YES];
```

Where responseObject is an NSArray of dictionaries. If the collection is a dictionary with an array inside one of its keys, just tell PSObjectMapping what the rootObjectKey is and it will automatically extract it.

## Contact

For questions or issues with PSObjectMapping please contact [premosystems](https://github.com/premosystems)


