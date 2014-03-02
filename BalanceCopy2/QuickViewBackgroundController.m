//
//  QuickViewBackgroundController.m
//  BalanceCopy2
//
//  Created by Robert Miller on 2/9/13.
//  Copyright (c) 2013 Gables Engineering. All rights reserved.
//

#import "QuickViewBackgroundController.h"
#import "AppDelegate.h"
#import "QVCustomCell.h"

@interface QuickViewBackgroundController ()

@end

@implementation QuickViewBackgroundController

@synthesize accountFour, accountOne, accountThree, accountTwo;
@synthesize alertViewStringSwitch;


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
    
    NSLog(@"quick view background controller view did load");
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeTop;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"qv background view will disappear");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"quick view background controller cell for row at index path");
    static NSString *CellIdentifier = @"qvCustomCell";
    QVCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //QVCustomCell *cell = [[QVCustomCell alloc] init];
    // Configure the cell...
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:dataCenter.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:4];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:dataCenter.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) { 
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    else    {}
    
    NSLog(@"count: %lu row: %ld",(unsigned long)[[aFetchedResultsController fetchedObjects] count], (long)indexPath.row);
    
    if ([[aFetchedResultsController fetchedObjects] count] < indexPath.row) {
        
        NSLog(@"count is less than row");
    
        cell.bankAccountButton.hidden = NO;
        
    }
        
    //else if ([[aFetchedResultsController fetchedObjects] count] > indexPath.row)    {
    
    else if ([[aFetchedResultsController fetchedObjects] count] > indexPath.row)   {
        
        NSLog(@"count is not less than row");
        
        NSLog(@"name is: %@",[[[aFetchedResultsController fetchedObjects] objectAtIndex:indexPath.row] accountName]);
        Account *tempAccount = [[aFetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
        cell.bankAccountButton.hidden = YES;
        cell.accountNameLabel.text = [tempAccount accountName];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        //amountLabel.text = [numberFormatter stringFromNumber:[cellTransaction transactionAmount]];
        if ([[tempAccount accountBalance] floatValue] < 0) {
            NSString *useThis = @"-";
            cell.balanceLabel.text = [useThis stringByAppendingString:[numberFormatter stringFromNumber:[tempAccount accountBalance]]];
        }
        else    {
            cell.balanceLabel.text = [numberFormatter stringFromNumber:[tempAccount accountBalance]];
        }

        
        //cell.balanceLabel.text = [[[[aFetchedResultsController fetchedObjects] objectAtIndex:indexPath.row] accountBalance] stringValue];
        
        
    }
    
    return cell;
    
}

/*
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:dataCenter.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:4];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:dataCenter.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    else    {}
    
    if ([[aFetchedResultsController fetchedObjects] count] - 1 < indexPath.row) {
        
        //Do Nothing
        
    }
    
    else    {
        
        dataCenter.dataCenterAccount = [[aFetchedResultsController fetchedObjects] objectAtIndex:indexPath.row];
        dataCenter.accountName = [dataCenter.dataCenterAccount accountName];
        dataCenter.appBalance = [dataCenter.dataCenterAccount accountBalance];
        dataCenter.lastPaycheck = [dataCenter.dataCenterAccount lastPaycheck];
        dataCenter.lastDeposit = [dataCenter.dataCenterAccount lastDeposit];
        dataCenter.lastAccountUsed = [[NSNumber alloc] initWithInt:indexPath.row];
        
    }
    
    [self.tableView reloadData];

}

-(IBAction)addBankAccount:(id)sender     {
    
    UIAlertView *newAlert = [[UIAlertView alloc] initWithTitle:@"New Account" message:nil delegate:self cancelButtonTitle:@"Done" otherButtonTitles: nil];
    newAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    [[newAlert textFieldAtIndex:1] setSecureTextEntry:NO];
    [[newAlert textFieldAtIndex:0] setPlaceholder:@"Account Name"];
    [[newAlert textFieldAtIndex:1] setPlaceholder:@"Initial Balance"];
    
    [newAlert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex   {
    
    //int i = [alertViewStringSwitch intValue];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    dataCenter.dataCenterAccount.accountBalance = dataCenter.appBalance;
    
    NSError *error = nil;
    
    if(![dataCenter.dataCenterAccount.managedObjectContext save:&error])   {
        
        NSLog(@"Something's gone wrong");
        
    }
    
    NSString *temporaryAccountName = [[alertView textFieldAtIndex:0] text];
    NSNumber *temporaryAccountBalance = [[NSNumber alloc] initWithFloat:[[[alertView textFieldAtIndex:1] text] floatValue]];
    dataCenter.accountName = temporaryAccountName;
    dataCenter.appBalance = temporaryAccountBalance;
    dataCenter.lastDeposit = temporaryAccountBalance;
    dataCenter.lastPaycheck = 0;
    
    dataCenter.dataCenterAccount = (Account *)[NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:dataCenter.managedObjectContext];
    [dataCenter.dataCenterAccount setAccountName:temporaryAccountName];
    [dataCenter.dataCenterAccount setAccountBalance:temporaryAccountBalance];
    [dataCenter.dataCenterAccount setLastDeposit:temporaryAccountBalance];
    [dataCenter.dataCenterAccount setLastPaycheck:0];
    [dataCenter.dataCenterAccount setTimeStamp:[NSDate date]];
    
    [self.tableView reloadData];
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
}

@end
