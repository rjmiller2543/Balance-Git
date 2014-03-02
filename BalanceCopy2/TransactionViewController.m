//
//  TransactionViewController.m
//  BalanceCopy2
//
//  Created by Robert Miller on 7/17/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "TransactionViewController.h"
#import "ListViewController.h"
#import "DetailViewController.h"

@interface TransactionViewController ()

@end

@implementation TransactionViewController
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     //DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     //[self.navigationController pushViewController:detailViewController animated:YES];
    NSLog(@"TransactionViewController didSelectRowAtIndexPath");
    if(indexPath.row == 0 && indexPath.section == 0)   {
        [[self delegate] updateToDaily:self];
    }
    if(indexPath.row == 1 && indexPath.section == 0)  {
        [[self delegate] updateToWeekly:self];
    }
    if(indexPath.row == 2 && indexPath.section == 0)  {
        [[self delegate] updateToMonthly:self];
    }
    if(indexPath.row == 3 && indexPath.section == 0)  {
        [[self delegate] updateToFullList:self];
    }
    if(indexPath.row == 0 && indexPath.section == 1)    {
        [[self delegate] updateToCarPayment:self];
    }
    if(indexPath.row == 1 && indexPath.section == 1)    {
        [[self delegate] updateToCreditCard:self];
    }
    if(indexPath.row == 2 && indexPath.section == 1)    {
        [[self delegate] updateToFood:self];
    }
    if(indexPath.row == 3 && indexPath.section == 1)    {
        [[self delegate] updateToGrocery:self];
    }
    if(indexPath.row == 4 && indexPath.section == 1)    {
        [[self delegate] updateToInsurance:self];
    }
    if(indexPath.row == 5 && indexPath.section == 1)    {
        [[self delegate] updateToOther:self];
    }
    if(indexPath.row == 6 && indexPath.section == 1)    {
        [[self delegate] updateToPaycheck:self];
    }
    if(indexPath.row == 7 && indexPath.section == 1)    {
        [[self delegate] updateToUtility:self];
    }
}

@end
