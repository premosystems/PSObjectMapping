//
//  GHModel.h
//
//  Created by Vincil Bishop on 11/24/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHModelObjects.h"

@interface GHModel : NSObject

+ (GHModel *) sharedModel;

- (void) tearDown;

@end
