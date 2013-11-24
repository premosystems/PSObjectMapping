//
//  GHCommitsTableViewCell.h
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/24/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHCommitsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *shaLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;

@end
