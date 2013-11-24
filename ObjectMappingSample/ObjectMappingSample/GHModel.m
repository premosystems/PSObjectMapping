//
//  GHModel.h
//
//  Created by Vincil Bishop on 11/24/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import "GHModel.h"

#define kSQLiteDBName @"GHModel.sqlite"

@implementation GHModel

static GHModel *_sharedModel;

+ (GHModel *) sharedModel
{
    if (!_sharedModel) {
        _sharedModel = [[GHModel alloc] init];
    }
    return _sharedModel;
}

- (id) init
{
    self = [super init];
    
    if (self) {
        [self performSelectorOnMainThread:@selector(setup) withObject:nil waitUntilDone:YES];
    }
    
    return self;
}

#pragma mark - Setup Methods -

- (void) setup
{
    NSManagedObjectModel *model = [NSManagedObjectModel  MR_newManagedObjectModelNamed:@"GHModel.momd"];
    
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:model];
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:kSQLiteDBName];
}

- (void) tearDown
{
    [MagicalRecord cleanUp];
}

@end
