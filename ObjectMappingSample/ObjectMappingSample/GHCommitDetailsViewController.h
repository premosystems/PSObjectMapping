//
//  GHCommitDetailsViewController.h
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/24/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GHCommit;

@interface GHCommitDetailsViewController : UIViewController

@property (nonatomic,strong) GHCommit *commit;

@end
