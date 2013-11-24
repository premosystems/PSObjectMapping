//
//  GHCommitFilesViewController.m
//  ObjectMappingSample
//
//  Created by Vincil Bishop on 11/24/13.
//  Copyright (c) 2013 Premier Mobile Systems. All rights reserved.
//

#import "GHCommitFilesViewController.h"
#import "GHModel.h"

@interface GHCommitFilesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GHCommitFilesViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Update Methods -

- (void) updateWithCommit:(GHCommit*)commit
{
    self.commit = commit;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.commit) {
        
        return [self.commit.files count];
        
    } else {
        
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    GHFile *file = [[self.commit.files allObjects] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = file.filename;
    cell.detailTextLabel.text = file.sha;
    
    return cell;
}

@end
