//
//  PSMappableObject.h
//  PSObjectMapping
//
//  Created by Vincil Bishop on 11/23/13.
//
//

#import <Foundation/Foundation.h>

@protocol PSMappableObject <NSObject>

@required

#pragma mark - Magical Record Methods -

+ (NSArray *) findAllInContext:(NSManagedObjectContext *)context;
+ (id) findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue;
+ (id) findFirstByAttribute:(NSString *)attribute withValue:(id)searchValue inContext:(NSManagedObjectContext *)context;

+ (id) createEntity;
+ (id) createInContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate;
+ (NSFetchedResultsController *) fetchAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm groupBy:(NSString *)groupingKeyPath delegate:(id<NSFetchedResultsControllerDelegate>)delegate inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm ascending:(BOOL)ascending withPredicate:(NSPredicate *)searchTerm;
+ (NSFetchRequest *) requestAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *) requestAllInContext:(NSManagedObjectContext *)context;

+ (NSUInteger) countOfEntitiesWithPredicate:(NSPredicate *)searchFilter inContext:(NSManagedObjectContext *)context;

@optional

#pragma mark - Mapping Methods -
+ (id) objectWithDictionary:(NSDictionary*)dict;
+ (NSString*) objectPrimaryKeyProperty;
+ (id) remotePrimaryKeyProperty;
+ (NSString*) remotePrimaryKeyWithDictionary:(NSDictionary*)dict;

+ (NSDictionary*) relationshipMappings;
+ (NSDictionary*) customMappings;

/**
 @description The first key value pair of the property mapping dictionary should be the local/remote primary key pair. This is used to check if an object already exists in CoreData when calling objectWithDictionary: so the system can make a decision as to whenter create a new object, or update an existing one.
 */
+ (NSDictionary*) propertyMappings;


- (NSEntityDescription *)entity;

@end
