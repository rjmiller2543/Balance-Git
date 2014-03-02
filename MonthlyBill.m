//
//  MonthlyBill.m
//  BalanceCopy2
//
//  Created by Alexander Arias on 8/2/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

//#import "MonthlyBill.h"

//@implementation MonthlyBill

#import "MonthlyBill.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import <EventKit/EventKit.h>

@interface MonthlyBill ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end



@implementation MonthlyBill
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize secondView;

@synthesize title;
@synthesize category;
@synthesize amount;
@synthesize date;
@synthesize wDrwal;
@synthesize deposit;
@synthesize wcheck;
@synthesize dcheck;
//@synthesize onOff;
@synthesize reminder, daysAway, pickerBool;

//TEST
@synthesize pickerView;
@synthesize dataArray;
@synthesize datePicker;
@synthesize temp;
@synthesize saveDate;
@synthesize toGo;
@synthesize repeat;
float num;
bool transaction;
bool billReminder;


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
    //secondView.scrollEnabled = YES;
    //secondView.contentSize = CGSizeMake(320, 1300); //Expand Inductance/Capacitance 1020 (620)
    [secondView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    date.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = dataCenter.managedObjectContext;
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //Adding Bill
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBill)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    [self updateTableView];
    
    
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
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateTableView];
}

-(void)updateTableView  {
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountName == %@",[dataCenter.dataCenterAccount accountName]];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        NSLog(@"Unresolved Error %@, %@",error,[error userInfo]);
        abort();
    }
    
    dataCenter.billArray = [[NSArray alloc] initWithArray:[self.fetchedResultsController fetchedObjects]];
    
    [self.tableView reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

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
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
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
    if([[segue identifier] isEqualToString:@"detailSegue"])  {
        DetailViewController *detailViewController = [segue destinationViewController];
        //detailViewController.detailBill = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        Bill *tempBill = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        NSLog(@"%@",[tempBill currentBill]);
        detailViewController.detailBill = tempBill;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSLog(@"We Here");
    //DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    //DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    //detailViewController.detailBill = (Bill*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    //NSLog(@"%@",[detailViewController.detailBill currentBill]);
    // NSManagedObject *selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    //detailViewController.selectedObject = selectedObject;
    
    // ...
    // Pass the selected object to the new view controller.
    //[self.navigationController pushViewController:detailViewController animated:YES];
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
    
    //NSLog(@"We Here");
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bill" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"accountName == %@", dataCenter.accountName];
    [fetchRequest setPredicate:predicate];
    
    // Edit the sort key as appropriate.
    //NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:NO];
    // NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"currentBill" ascending:NO];
    // NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"currentBill" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
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
    }
}
/*
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
 */
/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */
//TESTING STAMP BEFORE ANIMATION
/*
 - (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
 {
 NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
 cell.textLabel.text = [[managedObject valueForKey:@"timeStamp"] description];
 }
 */
- (void)insertNewObject
{
    [self addCancel];
    [self.toGo removeFromSuperview];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    //[newManagedObject setValue:[NSDate date] forKey:@"timeStamp"];
    //test
    [newManagedObject setValue:title.text forKey:@"currentBill"];
    [newManagedObject setValue:category.text forKey:@"billType"];
    //[newManagedObject setValue:num forKey:@"billAmount"];
    
    [newManagedObject setValue:[NSNumber numberWithFloat:[amount.text floatValue]] forKey:@"billAmount"];
    [newManagedObject setValue:saveDate forKey:@"billDate"];
    [newManagedObject setValue:repeat.text forKey:@"billRepeat"];
    [newManagedObject setValue:toGo.text forKey:@"billAlert"];
    [newManagedObject setValue:[NSNumber numberWithBool:transaction] forKey:@"transaction"];
    [newManagedObject setValue:[NSNumber numberWithBool:billReminder] forKey:@"billReminder"];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [newManagedObject setValue:[dataCenter.dataCenterAccount accountName] forKey:@"accountName"];
    
    //[newManagedObject setValue: forKey:<#(NSString *)#>]
    //[newManagedObject setValue:date.text forKey:@"billDate"];
    //[newManagedObject setValue:@"Doe" forKey:@"firstName"
    //[newManagedObject setValue:title.text];
    //[newManagedObject setValue:[NSDate date] forKey:title.text];
    //[newManagedObject setValue:[NSDate date] forKey:@"test"];
    
    
    
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
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            //Animation before Inserting object
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
//TESTING
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString* instance = [NSString stringWithFormat:@"%@",[[managedObject valueForKey:@"currentBill"] description]];
    
    cell.textLabel.text = instance;
    
    
    //cell.textLabel.text = [[managedObject valueForKey:@"timeStamp"] description];
    //cell.textLabel.text = [[managedObject valueForKey:category.text] description];
    //cell.textLabel.text = [[category.text] description];
}

-(void)addBill
{
    [self.view addSubview:secondView];
    secondView.alpha = 1;
    secondView.scrollEnabled = YES;
    secondView.contentSize = CGSizeMake(320, 430); //Expand Inductance/Capacitance 1020 (620)
    
    [secondView setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    [secondView setFrame:CGRectMake(0, 480, 320, 480)];
    [secondView setBounds:CGRectMake(0, 0, 320, 480)];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [secondView setFrame:CGRectMake(0, 0, 320, 480)];
    
    
    //NAME textField
    self.title = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 235, 31)];
    title.borderStyle = UITextBorderStyleRoundedRect;
    [title addTarget:self
              action:@selector(editable)
    forControlEvents:UIControlEventEditingDidEndOnExit];
    title.placeholder = @"Name";
    //NSLog(title.placeholder);
    NSLog(@"the text field is %@",title.text);
    
    [self.secondView addSubview:title];
    
    //Type textField
    self.category = [[UITextField alloc] initWithFrame:CGRectMake(20, 59, 176, 31)];
    category.borderStyle = UITextBorderStyleRoundedRect;
    category.placeholder = @"Type";
    [category addTarget:self
                 action:@selector(picker)
       forControlEvents:UIControlEventAllEvents];
    
    [self.secondView addSubview:category];
    
    //Amount textField
    self.amount = [[UITextField alloc] initWithFrame:CGRectMake(20, 98, 176, 31)];
    amount.borderStyle = UITextBorderStyleRoundedRect;
    amount.placeholder = @"Amount";
    amount.keyboardType = UIKeyboardTypeDecimalPad;
    [amount addTarget:self
               action:@selector(editable)
     forControlEvents:UIControlEventEditingDidEndOnExit];
    
    [self.secondView addSubview:amount];
    
    //Schedule date
    self.date = [[UITextField alloc] initWithFrame:CGRectMake(20, 137, 176, 31)];
    date.borderStyle = UITextBorderStyleRoundedRect;
    date.placeholder = @"Due Date";
    date.delegate = self;
    
    [self.secondView addSubview:date];
    
    //Repeat
    self.repeat = [[UITextField alloc] initWithFrame:CGRectMake(20, 176, 176, 31)];
    repeat.borderStyle = UITextBorderStyleRoundedRect;
    repeat.placeholder = @"Repeat Every";
    [repeat addTarget:self
               action:@selector(pickerRepeat)
     forControlEvents:UIControlEventAllEvents];
    //repeat.delegate = self;
    
    [self.secondView addSubview:repeat];
    
    
    //Withdrawal Label
    self.wDrwal = [[UILabel alloc] initWithFrame:CGRectMake(72, 220, 85, 21)];
    [wDrwal setText:@"Withdrawal"];
    [wDrwal setTextColor:[UIColor blackColor]];
    [wDrwal setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self.secondView addSubview:wDrwal];
    //Deposti label
    self.deposit = [[UILabel alloc] initWithFrame:CGRectMake(71, 250, 59, 21)];
    [deposit setText:@"Deposit"];
    [deposit setTextColor:[UIColor blackColor]];
    [deposit setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self.secondView addSubview:deposit];
    
    //withdrawalChecK
    self.wcheck = [[UITextField alloc] initWithFrame:CGRectMake(205, 215, 35, 27)];
    wcheck.borderStyle = UITextBorderStyleRoundedRect;
    [self.secondView addSubview:wcheck];
    
    
    //depostiCheck
    self.dcheck = [[UITextField alloc] initWithFrame:CGRectMake(205, 250, 35, 27)];
    dcheck.borderStyle = UITextBorderStyleRoundedRect;
    [self.secondView addSubview:dcheck];
    
    self.onOff = [[UISwitch alloc] initWithFrame:CGRectMake(185, 285, 79, 27)];
    [_onOff addTarget: self action: @selector(flip) forControlEvents:UIControlEventValueChanged];
    // Set the desired frame location of onoff here
    [self.secondView addSubview:_onOff];
    
    
    
    //Reminder Label
    self.reminder = [[UILabel alloc] initWithFrame:CGRectMake(72, 285, 97, 21)];
    [reminder setText:@"Reminder"];
    [reminder setTextColor:[UIColor blackColor]];
    [reminder setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self.secondView addSubview:reminder];
    
    [UIScrollView commitAnimations];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(insertNewObject)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    if((title.text==NULL)||[title.text isEqualToString:@""])
        saveButton.enabled = NO;
    else
        saveButton.enabled = YES;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(addCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    
}

-(void)addCancel
{
    [self.pickerView removeFromSuperview];
    [category resignFirstResponder];
    [title resignFirstResponder];
    [amount resignFirstResponder];
    [date resignFirstResponder];
    [repeat resignFirstResponder];
    [toGo resignFirstResponder];
    
    //[super viewDidLoad];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    
    
    //TESTING
    //secondView.contentSize = CGSizeMake(320, 1300);
    [secondView setFrame:CGRectMake(0, 0, 320, 480)];
    [secondView setBounds:CGRectMake(0, 0, 320, 480)];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [secondView setFrame:CGRectMake(0, 480, 320, 480)];
    
    secondView.alpha = 0;
    
    
    [UIView commitAnimations];
    
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = nil;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBill)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //[self viewDidLoad];
}

-(void)editable    {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(addCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(insertNewObject)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [secondView setFrame:CGRectMake(0, 0, 320, 480)];
    
    if((title.text==NULL)||[title.text isEqualToString:@""])
        saveButton.enabled = NO;
    else
        saveButton.enabled = YES;
    
    
    title.text = title.text;
    NSLog(@"title is %@",title.text);
    
    category.text = category.text;
    NSLog(@"category is %@",category.text);
    
    num = [amount.text floatValue];
    //NSLog(@"amount is %f",num);
    //NSLog(@"amount.text is %@", amount.text);
    
    //amount.text = amount.text;
    
    date.text = date.text;
    NSLog(@"date  is %@",date.text);
    
    
}

// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [dataArray count];
    
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [dataArray objectAtIndex: row];
    
    
}

// Do something with the selected row.

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSLog(@"You selected this: %@", [dataArray objectAtIndex: row]);
    if ([pickerBool isEqualToString:@"ReminderPicker"]) {
        NSLog(@"picker alert did select row");
        pickerBool = @"";
        switch (row) {
            case 0:
                daysAway = [[NSNumber alloc] initWithDouble:0];
                break;
            case 1:
                daysAway = [[NSNumber alloc] initWithDouble:1];
                break;
            case 2:
                daysAway = [[NSNumber alloc] initWithDouble:2];
                break;
            case 3:
                daysAway = [[NSNumber alloc] initWithDouble:3];
                break;
            case 4:
                daysAway = [[NSNumber alloc] initWithDouble:4];
                break;
            case 5:
                daysAway = [[NSNumber alloc] initWithDouble:5];
                break;
                
        }
    }
    
    temp = [[NSString alloc] initWithFormat:@"%@",[dataArray objectAtIndex:row]];

}

-(void)picker{
    
    wcheck.text = NULL;
    dcheck.text = NULL;
    
    dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:@""];
    [dataArray addObject:@"Car Payment"];
    [dataArray addObject:@"Credit Card"];
    [dataArray addObject:@"Insurance"];
    [dataArray addObject:@"Loan"];
    [dataArray addObject:@"Mortgage"];
    [dataArray addObject:@"Other"];
    [dataArray addObject:@"PayCheck"];
    [dataArray addObject:@"Student Loan"];
    [dataArray addObject:@"Utility"];
    
    // Init the picker view.
    pickerView = [[UIPickerView alloc] init];
    //category.inputView = pickerView;
    
    // Set the delegate and datasource. Don't expect picker view to work
    // correctly if you don't set it.
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    
    // Set the picker's frame. We set the y coordinate to 50px.
    //[pickerView setFrame: CGRectMake(0, 240, 320, 200)];
    
    // Before we add the picker view to our view, let's do a couple more
    // things. First, let the selection indicator (that line inside the
    // picker view that highlights your selection) to be shown.
    pickerView.showsSelectionIndicator = YES;
    
    // Allow us to pre-select the third option in the pickerView.
    [pickerView selectRow:0 inComponent:0 animated:YES];
    
    // OK, we are ready. Add the picker in our view.
    [self.view addSubview: pickerView];
    category.inputView = pickerView;
    //[pickerView addObject:category.text];
    [self.pickerView removeFromSuperview];
    
    //TESTING Done Button in UIToolbar
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(donePicker)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPicker)];
    
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton,spacer,doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    [self.view addSubview:keyboardDoneButtonView];
    category.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView removeFromSuperview];
    
    NSLog(@"TESTING%@",category.text);
}
-(void)pickerDate{
    
    [date resignFirstResponder];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    
    
    
    saveDate = [datePicker date];
    
    NSLog(@"Check date from picker:%@",[df stringFromDate:saveDate] );
    
    date.text = [df stringFromDate:datePicker.date];
    
    NSLog(@"TESTING%@",saveDate);
    NSLog(@"Testing date.text %@",date.text);
    NSLog(@"Testing NSDATE %@",[NSDate date]);
    
    [self.datePicker removeFromSuperview];
}

-(void)cancelPicker{
    
    [category resignFirstResponder];
    [date resignFirstResponder];
    [repeat resignFirstResponder];
    [toGo resignFirstResponder];
    
}
-(void)donePicker{
    [category resignFirstResponder];
    //[repeat resignFirstResponder];
    
    category.text = temp;
    NSLog(@"TESTING%@",category.text);
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(insertNewObject)];
    
    self.navigationItem.rightBarButtonItem = saveButton;
    
    saveButton.enabled = YES;
    
    if([category.text isEqualToString:@"PayCheck"]){
        dcheck.text = @"\u2611";
        transaction = TRUE;
        NSLog(@"BOOL is: %d@",transaction);
    }
    else{
        wcheck.text = @"\u2611";
        transaction = FALSE;
        NSLog(@"BOOL is: %d@",transaction);
    }
    if((category.text==NULL)||[category.text isEqualToString:@""])
        saveButton.enabled = NO;
    else
        saveButton.enabled = YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, 320, 325)];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    //self.datePicker.datePickerMode = UIDatePickerModeTime;
    date.inputView = datePicker;
    
    //toolbar
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(pickerDate)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPicker)];
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton,spacer,doneButton, nil]];
    
    [self.view addSubview:keyboardDoneButtonView];
    date.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView removeFromSuperview];
    //datePicker.datePickerMode = UIDatePickerModeDate;
    
}
-(void)flip{
    if (self.onOff.on){
        NSLog(@"On");
        self.toGo = [[UITextField alloc] initWithFrame:CGRectMake(72, 320, 100, 31)];
        //[toGo setText:@"Alert"];
        toGo.borderStyle = UITextBorderStyleRoundedRect;
        toGo.placeholder = @"Alert";
        [toGo addTarget:self
                 action:@selector(pickerAlert)
       forControlEvents:UIControlEventAllEvents];
        //[toGo setTextColor:[UIColor lightGrayColor]];
        //[toGo setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
        [self.secondView addSubview:toGo];
        billReminder = TRUE;
        
        //Testing reminders.
        if(_eventStore == nil)
        {
            _eventStore = [[EKEventStore alloc] init];
            [_eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
                if(!granted)
                    NSLog(@"shit of reminders aint working");
            }];
            
        }
        if(_eventStore != nil){
            //[self createReminder];
            NSLog(@"event is created testing");
        }
        
    }
    else { NSLog(@"Off");
        [self.toGo removeFromSuperview];
        billReminder = FALSE;
    }
    
    
}

-(void)pickerRepeat{
    dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:@""];
    [dataArray addObject:@"Week"];
    [dataArray addObject:@"Bi-Weekly"];
    [dataArray addObject:@"Month"];
    //[dataArray addObject:@"Mortgage"];
    //[dataArray addObject:@"Other"];
    //[dataArray addObject:@"PayCheck"];
    //[dataArray addObject:@"Utility"];
    
    // Init the picker view.
    pickerView = [[UIPickerView alloc] init];
    //category.inputView = pickerView;
    
    // Set the delegate and datasource. Don't expect picker view to work
    // correctly if you don't set it.
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    
    // Set the picker's frame. We set the y coordinate to 50px.
    //[pickerView setFrame: CGRectMake(0, 240, 320, 200)];
    
    // Before we add the picker view to our view, let's do a couple more
    // things. First, let the selection indicator (that line inside the
    // picker view that highlights your selection) to be shown.
    pickerView.showsSelectionIndicator = YES;
    
    // Allow us to pre-select the third option in the pickerView.
    [pickerView selectRow:0 inComponent:0 animated:YES];
    
    // OK, we are ready. Add the picker in our view.
    [self.view addSubview: pickerView];
    repeat.inputView = pickerView;
    //[pickerView addObject:category.text];
    [self.pickerView removeFromSuperview];
    
    //TESTING Done Button in UIToolbar
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(donePickerRepeat)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPicker)];
    
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton,spacer,doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    [self.view addSubview:keyboardDoneButtonView];
    repeat.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView removeFromSuperview];
    
}

-(void)donePickerRepeat{
    //[category resignFirstResponder];
    [repeat resignFirstResponder];
    repeat.text = temp;
    
}

#pragma mark - Reminder Days Picker

-(void)pickerAlert  {
    
    NSLog(@"pickerAlert");
    pickerBool = @"ReminderPicker";
    dataArray = [[NSMutableArray alloc] init];
    [dataArray addObject:@""];
    [dataArray addObject:@"1 day"];
    [dataArray addObject:@"2 days"];
    [dataArray addObject:@"3 days"];
    [dataArray addObject:@"4 days"];
    [dataArray addObject:@"5 days"];
    //[dataArray addObject:@"PayCheck"];
    //[dataArray addObject:@"Utility"];
    
    // Init the picker view.
    pickerView = [[UIPickerView alloc] init];
    //category.inputView = pickerView;
    
    // Set the delegate and datasource. Don't expect picker view to work
    // correctly if you don't set it.
    [pickerView setDataSource: self];
    [pickerView setDelegate: self];
    
    // Set the picker's frame. We set the y coordinate to 50px.
    //[pickerView setFrame: CGRectMake(0, 240, 320, 200)];
    
    // Before we add the picker view to our view, let's do a couple more
    // things. First, let the selection indicator (that line inside the
    // picker view that highlights your selection) to be shown.
    pickerView.showsSelectionIndicator = YES;
    
    // Allow us to pre-select the third option in the pickerView.
    [pickerView selectRow:0 inComponent:0 animated:YES];
    
    // OK, we are ready. Add the picker in our view.
    [self.view addSubview: pickerView];
    toGo.inputView = pickerView;
    //[pickerView addObject:category.text];
    [self.pickerView removeFromSuperview];
    
    //TESTING Done Button in UIToolbar
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(donePickerAlert)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelPicker)];
    
    
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton,spacer,doneButton, nil]];
    
    // Plug the keyboardDoneButtonView into the text field...
    [self.view addSubview:keyboardDoneButtonView];
    toGo.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView removeFromSuperview];
    
    //if(toGo.text isEqualToString:"1")
        
        
}

- (void)pickerAlert:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component  {
    
    NSLog(@"picker alert did select row");
    switch (row) {
        case 0:
            daysAway = [[NSNumber alloc] initWithDouble:0];
            break;
        case 1:
            daysAway = [[NSNumber alloc] initWithDouble:1];
            break;
        case 2:
            daysAway = [[NSNumber alloc] initWithDouble:2];
            break;
        case 3:
            daysAway = [[NSNumber alloc] initWithDouble:3];
            break;
        case 4:
            daysAway = [[NSNumber alloc] initWithDouble:4];
            break;
        case 5:
            daysAway = [[NSNumber alloc] initWithDouble:5];
            break;
            
    }
    
}

-(void)donePickerAlert  {
    
    NSLog(@"done picker alert with temp: %@",temp);
    [toGo resignFirstResponder];
    toGo.text = temp;
    [self createReminder];
    
}

-(IBAction)removeKeyboard:(id)sender    {
    [self.amount resignFirstResponder];
   // [transactionNameTextField resignFirstResponder];
}

//Reminders
-(void)createReminder{
    
    NSLog(@"Create Reminder");
    EKReminder *alert = [EKReminder reminderWithEventStore:self.eventStore];
    alert.title = title.text;
    alert.calendar = [_eventStore defaultCalendarForNewReminders];
    /*
    NSLog(@"toGo.text is: %@", toGo.text);
    if ([temp isEqualToString: @"1 Day"]) {
        NSLog(@"1 day");
        daysAway = [[NSNumber alloc] initWithDouble:1];
    }
    else if ([toGo.text isEqualToString:@"2 Days"]) {
        NSLog(@"two days");
        daysAway = [[NSNumber alloc] initWithDouble:2];
    }
    else if ([toGo.text isEqualToString:@"3 Days"]) {
        daysAway = [[NSNumber alloc] initWithDouble:3];
    }
    else if ([toGo.text isEqualToString:@"4 Days"]) {
        daysAway = [[NSNumber alloc] initWithDouble:4];
    }
    else if ([toGo.text isEqualToString:@"5 Days"]) {
        daysAway = [[NSNumber alloc] initWithDouble:5];
    }
    else{
        
        daysAway = [[NSNumber alloc] initWithDouble:0];
        
    } */
    
    NSTimeInterval secondsPerDay = -24 * 60 * 60 * [daysAway doubleValue];
    
    NSLog(@"toGo is: %f", secondsPerDay);
    
    NSDate *alarmDate;
    alarmDate = [saveDate dateByAddingTimeInterval: secondsPerDay];
    
    EKAlarm *alarma = [EKAlarm alarmWithAbsoluteDate:alarmDate];
    
    [alert addAlarm:alarma];
    NSError *error = nil;
    [_eventStore saveReminder:alert commit:YES error:&error];
    if(error)
        NSLog(@"error = %@", error);
    
}

@end

