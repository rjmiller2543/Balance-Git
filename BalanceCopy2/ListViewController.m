//
//  ListViewController.m
//  BalanceCopy2
//
//  Created by Robert Miller on 7/4/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "ListViewController.h"
#import "AppDelegate.h"
#import "QuartzCore/CALayer.h"
#import "Event.h"
#import "TransactionCell.h"
#import "NewTransactionView.h"
#import "MonthOverview.h"
#import "TransactionDetailViewController.h"

@interface ListViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation ListViewController
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize backgroundView;
@synthesize backgroundViewController;
@synthesize dataArray;
@synthesize saveDate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    self.tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = dataCenter.managedObjectContext;
    
    NSLog(@"list view controller acount name is: %@", [dataCenter.dataCenterAccount accountName]);
    
    
    dataArray = [[NSArray alloc] init];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *backgroundButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(showBackground)];
    
    self.navigationItem.leftBarButtonItem = backgroundButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //self.title = [dataCenter.dataCenterAccount accountName];
    
    self.navigationController.navigationBar.topItem.title = [dataCenter.dataCenterAccount accountName];
    
    NSLog(@"ListViewController ViewDidAppear");
    //if (self.backgroundViewController == nil) {
        self.backgroundViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"backgroundNIB"];
        [self.navigationController.view.superview addSubview:backgroundViewController.view];
        [self.navigationController.view.superview sendSubviewToBack:backgroundViewController.view];
        backgroundViewController.view.alpha = 0.75;
        backgroundViewController.delegate = self;
    //}
    
    //[self.tableView reloadData];
    [self updateToFullList:self.backgroundViewController];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.backgroundViewController = nil;
    [[self.navigationController.view.superview.subviews objectAtIndex:0] removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Update Functions

-(void)updateToDaily:(TransactionViewController*)controller    {
    NSLog(@"update to daily");
    
    //[NSFetchedResultsController deleteCacheWithName:@"Master"];
    
    //NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    //[request setEntity:entity];
    
    NSDate *referenceDate;
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit startDate:&referenceDate interval:nil forDate:[NSDate date]];
    NSLog(@"%@",[referenceDate description]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp > %@",referenceDate];
    //[request setPredicate:predicate];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    //[self.managedObjectContext executeFetchRequest:self.fetchedResultsController.fetchRequest error:&error];
    //[self.tableView reloadSections:<#(NSIndexSet *)#> withRowAnimation:<#(UITableViewRowAnimation)#>];
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToWeekly:(TransactionViewController *)controller   {
    NSLog(@"update to weekly");
    
    NSDate *referenceDate = [NSDate date];
    [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit startDate:&referenceDate interval:nil forDate:[NSDate date]];
    NSLog(@"%@",[referenceDate description]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp > %@",referenceDate];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToMonthly:(TransactionViewController *)controller  {
    NSLog(@"update to monthly");
    
    NSDate *referenceDate;
    [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&referenceDate interval:nil forDate:[NSDate date]];
    NSLog(@"%@",[referenceDate description]);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timeStamp > %@", referenceDate];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresoled Error %@, %@",error, [error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToFullList:(TransactionViewController *)controller {
    NSLog(@"update to full list");
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountName == %@",[dataCenter.dataCenterAccount accountName]];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToCarPayment:(TransactionViewController *)controller   {
    NSLog(@"update to Car Payment");
    
    NSString *referenceString = @"Car Payment";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"transactionType == %@",referenceString];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToCreditCard:(TransactionViewController *)controller   {
    NSLog(@"update to Credit Card");
    
    NSString *referenceString = @"Credit Card";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"transactionType == %@",referenceString];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToFood:(TransactionViewController *)controller {
    NSLog(@"update to Food");
    
    NSString *referenceString = @"Dining Out";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"transactionType == %@",referenceString];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToGrocery:(TransactionViewController *)controller  {
    NSLog(@"update to Grocery");
    
    NSString *referenceString = @"Grocery";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"transactionType == %@",referenceString];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToInsurance:(TransactionViewController *)controller    {
    NSLog(@"update to Insurance");
    
    NSString *referenceString = @"Insurance";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"transactionType == %@",referenceString];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToOther:(TransactionViewController *)controller    {
    NSLog(@"update to Other");
    
    NSString *referenceString = @"Other";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"transactionType == %@",referenceString];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToPaycheck:(TransactionViewController *)controler  {
    NSLog(@"update to Paycheck");
    
    NSString *referenceString = @"Paycheck";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"transactionType == %@",referenceString];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

-(void)updateToUtility:(TransactionViewController *)controller  {
    NSLog(@"update to Utility");
    
    NSString *referenceString = @"Utility";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"transactionType == %@",referenceString];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error,[error userInfo]);
        abort();
    }
    
    [self.tableView reloadData];
    
    [self hideBackground];
}

/*
-(void)showBackground   {
    CGRect destination = self.navigationController.view.frame;
    
    if(destination.origin.x > 0)  {
        destination.origin.x = 0;
    }
    else {
        destination.origin.x = 240;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.navigationController.view.frame = destination;
        
    } completion:^(BOOL finished) {
        
        self.view.userInteractionEnabled = !(destination.origin.x > 0);
        
    }];
}
*/

-(void)showBackground   {
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.75];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    
    //backgroundViewController.view.alpha = 0.75;
    //[UIView commitAnimations];
    
    CGRect destination = self.navigationController.view.frame;
    
    
    destination.origin.x = 280;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.navigationController.view.frame = destination;
        
    } completion:^(BOOL finished) {
        
        self.view.userInteractionEnabled = !(destination.origin.x > 0);
        
    }];
    
}



-(void)hideBackground    {
    
    CGRect destination = self.navigationController.view.frame;
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.25];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    
    //    backgroundViewController.view.alpha = 0;
    //[UIView commitAnimations];
    
    destination.origin.x = 0;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.navigationController.view.frame = destination;
        
    } completion:^(BOOL finished) {
        
        self.view.userInteractionEnabled = !(destination.origin.x > 0);
        
    }];
    
}

#pragma mark    - Saving View Stuff

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    //return 0;
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 0;
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TransactionCell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    TransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionCell"];
    
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[TransactionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.cellTransaction = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"%@",[[self.fetchedResultsController objectAtIndexPath:indexPath] transactionName]);
    
    // Configure the cell...
    //[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commit editing style");
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        Transaction *editedTransaction = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self updateMonthOverview:editedTransaction];
        if (indexPath.row == 0) {
            NSLog(@"row: %d",indexPath.row);
            AppDelegate *dataCenter = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            if([[editedTransaction withdrawal] boolValue])  {
                NSLog(@"was a Withdrawal");
                float saveData = [dataCenter.appBalance floatValue] + [[editedTransaction transactionAmount] floatValue];
                dataCenter.appBalance = [NSNumber numberWithFloat:saveData];
            }
            else    {
                NSLog(@"was a deposit");
                float saveData = [dataCenter.appBalance floatValue] - [[editedTransaction transactionAmount] floatValue];
                dataCenter.appBalance = [NSNumber numberWithFloat:saveData];
            }
            NSLog(@"appBalance: %@",dataCenter.appBalance);
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setFloat:[dataCenter.appBalance floatValue] forKey:@"key"];
        }
        else    {
            [self updateTransactions:indexPath byAmount:[editedTransaction transactionAmount] addAmount:[[editedTransaction withdrawal] boolValue]];
        }
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"addSegue"]) {
        
    }
    else    {
        TransactionDetailViewController *detailView = [segue destinationViewController];
        Transaction *detailTransaction = (Transaction*)[[self.fetchedResultsController fetchedObjects] objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        NSLog(@"transaction name: %@",[detailTransaction transactionName]);
        detailView.detailTransaction = detailTransaction;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     { *detailViewController = [[ alloc] initWithNibName:@"" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    //[self performSegueWithIdentifier:@"transactionDetail" sender:self];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"account name is: %@",[dataCenter.dataCenterAccount accountName]);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountName == %@", [dataCenter.dataCenterAccount accountName]];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    self.dataArray = [NSMutableArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    //NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = [[managedObject valueForKey:@"timeStamp"] description];
    //NSManagedObject *managedObject = [self.dataArray objectAtIndex:indexPath.row];
    //cell.textLabel.text = [[managedObject valueForKey:@"timeStamp"] description];
}

- (void)insertNewObject
{
    // Create a new instance of the entity managed by the fetched results controller.
    /*
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    */
    // Save the context.
    
    //NSError *error = nil;
    //if (![context save:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         */
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
    //}
    [self performSegueWithIdentifier:@"addSegue" sender:self];
}

#pragma mark - Updating Methods

-(void)updateMonthOverview:(Transaction*)deletedTransaction {
    
    NSLog(@"delete month overview part");
    AppDelegate *dataCenter = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MonthOverview" inManagedObjectContext:dataCenter.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    NSLog(@"saveDate is: %@",[[deletedTransaction timeStamp] description]);
    NSDate *referenceDate = [deletedTransaction timeStamp];
    //[[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&referenceDate interval:nil forDate:saveDate];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ >= startDate && %@ < endDate", referenceDate, referenceDate];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:dataCenter.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSError *secondError = nil;
    [fetchedResultsController performFetch:&secondError];
    MonthOverview *overview = (MonthOverview*)[[fetchedResultsController fetchedObjects] objectAtIndex:0];
    NSString *referenceString = [deletedTransaction transactionType];
    //NSArray *monthArray = [fetchedResultsController fetchedObjects];
    NSLog(@"delete part from this month: %@",[overview monthString]);
    NSLog(@"referenceString is: %@",[deletedTransaction transactionType]);
    if([referenceString isEqualToString: @"Car Payment"])    {
        NSLog(@"setCarPayments");
        [overview setCarPayments:[NSNumber numberWithFloat:[[overview carPayments] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    if([referenceString isEqualToString:@"Credit Card"])    {
        NSLog(@"adding to credit card");
        [overview setCreditCards:[NSNumber numberWithFloat:[[overview creditCards] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    if([referenceString isEqualToString:@"Dining Out"])    {
        NSLog(@"adding to food");
        
        [overview setFood:[NSNumber numberWithFloat:[[overview food] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    if([referenceString isEqualToString:@"Gas"])    {
        NSLog(@"adding to gas");

        [overview setGas:[NSNumber numberWithFloat:[[overview gas] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    if([referenceString isEqualToString:@"Grocery"])    {
        NSLog(@"adding to grocery");

        [overview setGrocery:[NSNumber numberWithFloat:[[overview grocery] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    if([referenceString isEqualToString:@"Insurance"])    {
        NSLog(@"adding to insurance");

        NSLog(@"adding to insurnace");
        
        [overview setInsurance:[NSNumber numberWithFloat:[[overview insurance] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    if([referenceString isEqualToString:@"Loan"])    {
        NSLog(@"adding to loan");
        
        [overview setLoan:[NSNumber numberWithFloat:[[overview loan] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    if([referenceString isEqualToString:@"Mortgage"])    {
        NSLog(@"adding to mortgage");
        
        [overview setMortgage:[NSNumber numberWithFloat:[[overview mortgage] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    if([referenceString isEqualToString:@"Other"])    {
        NSLog(@"adding to other");
        
        [overview setOther:[NSNumber numberWithFloat:[[overview other] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    if([referenceString isEqualToString:@"Student Loan"])    {
        NSLog(@"adding to student loan");
        
        [overview setStudentLoan:[NSNumber numberWithFloat:[[overview studentLoan] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    if([referenceString isEqualToString:@"Utility"])    {
        NSLog(@"adding to utility");
        
        [overview setUtilities:[NSNumber numberWithFloat:[[overview utilities] floatValue] - [[deletedTransaction transactionAmount] floatValue]]];
    }
    NSError *nextError = nil;
    if(![overview.managedObjectContext save:&nextError])    {
        
    }
}

-(void)updateTransactions:(NSIndexPath*)indexPath byAmount:(NSNumber*)amount addAmount:(BOOL)withDrawal    {
    Transaction *tempTransaction;
    NSLog(@"indexPath:%@",indexPath);
    for (int i = indexPath.row - 1; i >= 0; i--) {
        //[indexPath setValue:[NSNumber numberWithInt:i] forKey:@"row"];
        NSUInteger index [] = {0, i};
        NSIndexPath *tempPath = [[NSIndexPath alloc] initWithIndexes:index length:2];
        NSLog(@"tempPath:%@",tempPath);
        tempTransaction =  [self.fetchedResultsController objectAtIndexPath:tempPath];
        if (withDrawal) {
            [tempTransaction setBalanceAfterTransaction:[NSNumber numberWithFloat:[amount floatValue] + [[tempTransaction balanceAfterTransaction] floatValue]]];
        }
        else    {
            [tempTransaction setBalanceAfterTransaction:[NSNumber numberWithFloat:[[tempTransaction balanceAfterTransaction] floatValue] - [amount floatValue]]];

        }
        //[tempTransaction setBalanceAfterTransaction:[NSNumber numberWithFloat:[amount floatValue] + [[tempTransaction balanceAfterTransaction] floatValue]]];
        NSError *error = nil;
        if(![tempTransaction.managedObjectContext save:&error]) {
            
        }
    }
    AppDelegate *dataCenter = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"balanceAfterTrans: %@",[tempTransaction balanceAfterTransaction]);
    dataCenter.appBalance = [tempTransaction balanceAfterTransaction];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:[dataCenter.appBalance floatValue] forKey:@"key"];
    
    [self.tableView reloadData];
}


@end
