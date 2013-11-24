//
//  GHCommitDetailsViewController.m
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/24/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import "GHCommitDetailsViewController.h"
#import "GHModel.h"
#import "GHCommitFilesViewController.h"


@interface GHCommitDetailsViewController ()

@property (strong, nonatomic) IBOutlet UILabel *shaLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

@end

@implementation GHCommitDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.shaLabel.text = self.commit.sha;
    self.authorLabel.text = self.commit.author.login;
    self.dateLabel.text = [self.commit.date description];
    
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:self.commit.author.avatarURLString]];
    
    [self.commit getDetailsWithCompletionBlock:^(NSArray *result, NSError *error) {
        
        NSManagedObjectID *objectID = result[0];
        GHCommit *commit = (GHCommit*)[[NSManagedObjectContext defaultContext] objectWithID:objectID];
        
        GHCommitFilesViewController *filesViewController = [self.childViewControllers objectAtIndex:0];
        [filesViewController updateWithCommit:commit];
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
