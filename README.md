PSObjectMapping
===============

Overview
========
========

PSObjectMapping maps NSDictionary and NSArray collections to CoreData NSManagedObjects.

The solution consists of a category on NSManagedObject and a protocol describing a PSMappableObject.

The development of PSObjectMapping came out of a personal need, and although it is being used in production, it is still very much a work in progress.

## Example Setup
![XCode Data Model Primary Key Setup](https://raw.github.com/premosystems/PSObjectMapping/gh-pages/xcdatamodel-primary-key-screenshot.png)

Example Usage
=============
=============

To use PSObjectMapping there exists a class method applied to all PSMappableObjects:

```objective-c
+ (NSArray*) mapWithCollection:(id)arrayOrDictionary rootObjectKey:(NSString*)rootObjectKey customObjectMappingBlock:(void (^)(NSDictionary *keyedValues, id object))customObjectMappingBlock mapRelationships:(BOOL)mapRelationships;
```

Pass the NSArray or NSDictionary containing keyed values to this method, and an array of NSManagedObjectIDs is returned for the objects that were mapped.



