//
//  DetailViewController.m
//  BalanceCopy2
//
//  Created by Alexander Arias on 8/7/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "DetailViewController.h"
#import "QuartzCore/CALayer.h"
#import "MonthlyBill.h"
#import "AppDelegate.h"
#import "NewTransactionView.h"   

@interface DetailViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation DetailViewController

//@synthesize selectedObject = __selectedObject;
@synthesize detailBill;
@synthesize editTitle;
@synthesize editCategory;
@synthesize editAmount;
@synthesize editDate;
@synthesize editWdrwal;
@synthesize editDep;
@synthesize editWcheck;
@synthesize editDcheck;
@synthesize deleteBill;
@synthesize editRepeat;
@synthesize editOnOff;
@synthesize editReminder;
@synthesize editToGo;
@synthesize secondView;
@synthesize payBill;

//TEST
@synthesize pickerView;
@synthesize dataArray;
@synthesize temp;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize tableView;
@synthesize datePicker;
@synthesize saveDate;

bool edit;





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
    editAmount.enabled= NO;
    editCategory.enabled = NO;
    editTitle.enabled = NO;
    editDate.enabled = NO;
    editRepeat.enabled = NO;
    editReminder.enabled = NO;
    editOnOff.enabled = NO;
    editToGo.enabled = NO;
    deleteBill.alpha = 0;
    
    //editCategory.text = temp;
    //[self.deleteBill removeFromSuperview];
    //[self.view removeFromSuperview];
    NSLog(@"currentBill in detailView: %@",[detailBill currentBill]);
    
    
    NSLog(@"billType/Category in detailView: %@",[detailBill billType]);
    NSLog(@"editTitle is %@",editTitle.text);
    
    
    //[detailBill setCurrentBill:editTitle.text];
    
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editBill)];
    self.navigationItem.rightBarButtonItem = edit;
    
    self.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem;
    
    
    [self.view addSubview:secondView];
    [self.secondView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    
    self.secondView.scrollEnabled = YES;
    self.secondView.contentSize = CGSizeMake(320, 430); //Expand Inductance/Capacitance 1020 (620)
    
    //NAME textField
    self.editTitle = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, 235, 31)];
    editTitle.borderStyle = UITextBorderStyleRoundedRect;
    editTitle.enabled = NO;
    
    
    editTitle.text = [detailBill currentBill];
    [self.secondView addSubview:editTitle];
    
    //Type textField
    self.editCategory = [[UITextField alloc] initWithFrame:CGRectMake(20, 59, 176, 31)];
    editCategory.borderStyle = UITextBorderStyleRoundedRect;
    editCategory.enabled = NO;
    editCategory.text = [detailBill billType];
    [self.secondView addSubview:editCategory];
    
    self.editAmount = [[UITextField alloc] initWithFrame:CGRectMake(20, 98, 176, 31)];
    editAmount.borderStyle = UITextBorderStyleRoundedRect;
    editAmount.enabled = NO;
    editAmount.text = [[detailBill billAmount] stringValue];
    
    [self.secondView addSubview:editAmount];
    
    //Schedule date
    self.editDate = [[UITextField alloc] initWithFrame:CGRectMake(20, 137, 176, 31)];
    editDate.borderStyle = UITextBorderStyleRoundedRect;
    editDate.enabled = NO;
    static NSDateFormatter *dateformatter = nil;
    if(dateformatter == nil){
        dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateStyle:NSDateFormatterMediumStyle];
    }
    editDate.text = [dateformatter stringFromDate:[detailBill billDate]];
    editDate.delegate = self;
    [self.secondView addSubview:editDate];
    
    
    //Repeat
    self.editRepeat = [[UITextField alloc] initWithFrame:CGRectMake(20, 176, 176, 31)];
    editRepeat.borderStyle = UITextBorderStyleRoundedRect;
    //editRepeat.placeholder = @"Repeat Every";
    editRepeat.enabled = NO;
    [editRepeat addTarget:self
                   action:@selector(pickerRepeat)
         forControlEvents:UIControlEventAllEvents];
    editRepeat.text = [detailBill billRepeat];
    [self.secondView addSubview:editRepeat];
    
    
    
    
    //Withdrawal Label
    self.editWdrwal = [[UILabel alloc] initWithFrame:CGRectMake(72, 220, 85, 21)];
    [editWdrwal setText:@"Withdrawal"];
    [editWdrwal setTextColor:[UIColor blackColor]];
    [editWdrwal setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self.secondView addSubview:editWdrwal];
    //Deposti label
    self.editDep = [[UILabel alloc] initWithFrame:CGRectMake(71, 250, 59, 21)];
    [editDep setText:@"Deposit"];
    [editDep setTextColor:[UIColor blackColor]];
    [editDep setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self.secondView addSubview:editDep];
    
    //withdrawalChecK
    self.editWcheck = [[UITextField alloc] initWithFrame:CGRectMake(205, 215, 35, 27)];
    editWcheck.borderStyle = UITextBorderStyleRoundedRect;
    editWcheck.enabled = NO;
    [self.secondView addSubview:editWcheck];
    
    
    //depostiCheck
    self.editDcheck = [[UITextField alloc] initWithFrame:CGRectMake(205, 250, 35, 27)];
    editDcheck.borderStyle = UITextBorderStyleRoundedRect;
    editDcheck.enabled = NO;
    [self.secondView addSubview:editDcheck];
    
    self.editOnOff = [[UISwitch alloc] initWithFrame:CGRectMake(185, 285, 79, 27)];
    [editOnOff addTarget: self action: @selector(flip) forControlEvents:UIControlEventValueChanged];
    // Set the desired frame location of onoff here
    [self.secondView addSubview:editOnOff];
    
    //Reminder Label
    self.editReminder = [[UILabel alloc] initWithFrame:CGRectMake(72, 285, 97, 21)];
    [editReminder setText:@"Reminder"];
    [editReminder setTextColor:[UIColor blackColor]];
    [editReminder setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    //editReminder.text = [detailBill billAlert];
    [self.secondView addSubview:editReminder];
    
/*
     if([[detailBill billType] isEqualToString:@"PayCheck"])
     editDcheck.text = @"\u2611";
     else
     editWcheck.text = @"\u2611";
*/    
    NSLog(@"transaction is:%@",[detailBill transaction]);
    
    if([[detailBill transaction] boolValue]){
        NSLog(@"transaction is:%@",[detailBill transaction]);
        
        editDcheck.text = @"\u2611";
        //editWcheck.text = @"\u2611";
    }
    else{
        editWcheck.text = @"\u2611";
    }
    
    if([[detailBill billReminder] boolValue]){
        //[editOnOff setOn:YES animated:YES];
        [editOnOff setOn:YES];
        editOnOff.enabled = NO;
        self.editToGo = [[UITextField alloc] initWithFrame:CGRectMake(72, 320, 100, 31)];
        editToGo.borderStyle = UITextBorderStyleRoundedRect;
        //toGo.placeholder = @"Alert";
        editToGo.text = [detailBill billAlert];
        editToGo.enabled = NO;
        [editToGo addTarget:self
                     action:@selector(pickerAlert)
           forControlEvents:UIControlEventAllEvents];
        //editToGo.text = [detailBill billAlert];
        [self.secondView addSubview:editToGo];
        
    }
    else{
        //[editOnOff setOn:NO animated:YES];
        [editOnOff setOn:NO];
        editOnOff.enabled = NO;
    }
    
    //PAY BILL
    NSArray *deleteContent = [NSArray arrayWithObjects: @"Pay Bill", nil];
    
    //UISegmentedControl *deleteBill = [[UISegmentedControl alloc] initWithItems:deleteContent];
    payBill = [[UISegmentedControl alloc] initWithItems:deleteContent];
    CGRect frame = CGRectMake(25,370,270,40);
    payBill.frame = frame;
    
    //Changing to Bold Font size 18.0
    UIFont *Boldfont = [UIFont boldSystemFontOfSize:18.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:Boldfont
                                                           forKey:UITextAttributeFont];
    [payBill setTitleTextAttributes:attributes
                           forState:UIControlStateNormal];
    
    payBill.selectedSegmentIndex = -1;
    
    [payBill addTarget:self action:@selector(payMode) forControlEvents:UIControlEventValueChanged];
    
    payBill.segmentedControlStyle = UISegmentedControlStyleBar;
    
    payBill.tintColor = [UIColor colorWithRed:50.0f/255.0f green:205.0f/255.0f blue:50.0f/255.0f alpha:0.8f];
    
    payBill.momentary = YES;
    payBill.alpha = 0.9;
    [self.secondView addSubview:payBill];
    
    [detailBill setCurrentBill:editTitle.text];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)editBill{
    
    //When Edit Trigger
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(viewDidLoad)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(viewDidLoad)];
    self.navigationItem.rightBarButtonItem = doneButton;
    ///////
    
    payBill.alpha = 0;
    
    editTitle.enabled = YES;
    [editTitle setTextColor:[UIColor lightGrayColor]];
    [editTitle addTarget:self action:@selector(editMode) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    editCategory.enabled = YES;
    [editCategory setTextColor:[UIColor lightGrayColor]];
    [editCategory addTarget:self action:@selector(picker) forControlEvents:UIControlEventAllEvents];
    //Cat fixed
    
    editAmount.enabled = YES;
    [editAmount setTextColor:[UIColor lightGrayColor]];
    editAmount.keyboardType = UIKeyboardTypeDecimalPad;
    [editAmount addTarget:self action:@selector(editMode) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
    editDate.enabled = YES;
    [editDate setTextColor:[UIColor lightGrayColor]];
    
    editRepeat.enabled = YES;
    [editRepeat setTextColor:[UIColor lightGrayColor]];
    
    editToGo.enabled = YES;
    [editToGo setTextColor:[UIColor lightGrayColor]];
    
    editOnOff.enabled = YES;
    
    
    
    
    //Delete Button...
    NSArray *deleteContent = [NSArray arrayWithObjects: @"Delete Bill", nil];
    
    //UISegmentedControl *deleteBill = [[UISegmentedControl alloc] initWithItems:deleteContent];
    deleteBill = [[UISegmentedControl alloc] initWithItems:deleteContent];
    CGRect frame = CGRectMake(25,370,270,40);
    deleteBill.frame = frame;
    
    //Changing to Bold Font size 18.0
    UIFont *Boldfont = [UIFont boldSystemFontOfSize:18.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:Boldfont
                                                           forKey:UITextAttributeFont];
    [deleteBill setTitleTextAttributes:attributes
                              forState:UIControlStateNormal];
    
    deleteBill.selectedSegmentIndex = -1;
    
    [deleteBill addTarget:self action:@selector(deleteMode) forControlEvents:UIControlEventValueChanged];
    
    deleteBill.segmentedControlStyle = UISegmentedControlStyleBar;
    
    deleteBill.tintColor = [UIColor colorWithRed:255.0f/255.0f green:74.0f/255.0f blue:54.0f/255.0f alpha:0.8f];
    
    deleteBill.momentary = YES;
    deleteBill.alpha = 0.9;
    [self.secondView addSubview:deleteBill];
    
    [detailBill setCurrentBill:editTitle.text];
    
    
}

-(void)editMode{
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(viewDidLoad)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    //Check
    NSLog(@"editTitle is %@",editTitle.text);
    NSLog(@"editAmount is %@",editAmount.text);
    
    [detailBill setCurrentBill:editTitle.text];
    [detailBill setBillAmount:[NSNumber numberWithFloat:[editAmount.text floatValue]]];
    NSError *error = nil;
    if(![detailBill.managedObjectContext save:&error])
    {
        
    }
    
}

-(void)deleteMode{
    
    
    [detailBill.managedObjectContext deleteObject:detailBill];
    
    NSError *error = nil;
    if(![detailBill.managedObjectContext save:&error])
    {
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/*
 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 if([segue identifier] ==@"addBill"){
 NewTransactionView *newView = [segue destinationViewController];
 Transaction *temp = [[Transaction alloc] init];
 [temp setTransactionName:[detailBill currentBill]];
 
 [temp setTransactionAmount:[NSNumber numberWithFloat:[[detailBill billAmount] floatValue]]];
 [temp setTransactionType:[detailBill billType]];
 newView.transaction = temp;
 
 }
 }
 
 -(IBAction)addBill:(id)sender{
 
 [self performSegueWithIdentifier:@"addBill" sender:sender];
 
 
 }
 */

 -(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
     if([[segue identifier] isEqualToString:@"addBill"]){
         //NSLOG(@"prep for segue");
         NewTransactionView *newview = [segue destinationViewController];
         
         newview.tempName = [detailBill currentBill];
         //newview.tempAmount = [detailBill billAmount];
         NSString *conv = [[NSString alloc] initWithString:[[detailBill billAmount] stringValue]];
         newview.tempAmount = conv;
         newview.tempType = [detailBill billType];
         newview.status = [NSNumber numberWithBool:[detailBill transaction]];
         NSLog(@"newview passed parameter %@", newview.status);
         
        
    }
 }
 
-(void)payMode{
    
    //   [self performSegueWithIdentifier:@"addBill" sender:sender];
    [self performSegueWithIdentifier:@"addBill" sender:self];
    
    
}

//TEST PICKER
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
    temp = [[NSString alloc] initWithFormat:@"%@",[dataArray objectAtIndex:row]];
}

-(void)picker{
    
    editWcheck.text = NULL;
    editDcheck.text = NULL;
    
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
    editCategory.inputView = pickerView;
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
    editCategory.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView removeFromSuperview];
    
    NSLog(@"TESTING%@",editCategory.text);
}

-(void)cancelPicker{
    
    [editCategory resignFirstResponder];
    [editDate resignFirstResponder];
    [editRepeat resignFirstResponder];
    [editToGo resignFirstResponder];
    
}
-(void)donePicker{
    [editCategory resignFirstResponder];
    //[repeat resignFirstResponder];
    
    editCategory.text = temp;
    //editCategory = [detailBill billType];
    NSLog(@"TESTING%@",editCategory.text);
    
    //UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(insertNewObject)];
    
   // self.navigationItem.rightBarButtonItem = saveButton;
    
    //saveButton.enabled = YES;
    
    if([editCategory.text isEqualToString:@"PayCheck"]){
        editDcheck.text = @"\u2611";
        //transaction = TRUE;
        //NSLog(@"BOOL is: %d@",transaction);
    }
    else{
        editWcheck.text = @"\u2611";
        //transaction = FALSE;
        //NSLog(@"BOOL is: %d@",transaction);
    }
   // if((editCategory.text==NULL)||[editCategory.text isEqualToString:@""])
   //     saveButton.enabled = NO;
   // else
   //     saveButton.enabled = YES;

    //[detailBill.managedObjectContext deleteObject:detailBill];
    //[detailBill.billType isEqualToString:temp ];
    //[detailBill.billType isEqualToString:temp];
    [detailBill setValue:editCategory.text forKey:@"billType"];
    

    
    
}

-(void)datasave{
    NSLog(@"WE ARE HERE@");
    
    NSManagedObjectContext *context = [self.detailBill managedObjectContext];
    
    NSError *error = nil;
    if(![context save:&error])  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shit.." message:@"Well it didn't save" delegate:self cancelButtonTitle:@"Blah.." otherButtonTitles: nil];
        [alert show];
        
    }
 
}

-(void)pickerDate{
    
    [editDate resignFirstResponder];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    
    
    saveDate = [datePicker date];
    
    //NSLog(@"Check date from picker:%@",[df stringFromDate:saveDate] );
    
    editDate.text = [df stringFromDate:datePicker.date];
    [detailBill setBillDate:datePicker.date];
    
    NSManagedObjectContext *context = [self.detailBill managedObjectContext];
    
    NSError *error = nil;
    if(![context save:&error])  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shit.." message:@"Well it didn't save" delegate:self cancelButtonTitle:@"Blah.." otherButtonTitles: nil];
        [alert show];
        
    }

    
   // NSLog(@"TESTING%@",saveDate);
    //NSLog(@"Testing date.text %@",date.text);
    //NSLog(@"Testing NSDATE %@",[NSDate date]);
    
    [self.datePicker removeFromSuperview];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 250, 320, 325)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    editDate.inputView = datePicker;
    
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
    editDate.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView removeFromSuperview];
    //datePicker.datePickerMode = UIDatePickerModeDate;
    
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
    editRepeat.inputView = pickerView;
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
    editRepeat.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView removeFromSuperview];
    
}

-(void)donePickerRepeat{
    //[category resignFirstResponder];
    [editRepeat resignFirstResponder];
    editRepeat.text = temp;
    [detailBill setBillRepeat:editRepeat.text];
    
    NSManagedObjectContext *context = [self.detailBill managedObjectContext];
    NSError *error = nil;
    if(![context save:&error])  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shit.." message:@"Well it didn't save" delegate:self cancelButtonTitle:@"Blah.." otherButtonTitles: nil];
        [alert show];
        
    }

    
}

-(void)flip{
    if (self.editOnOff.on){
        NSLog(@"On");
        self.editToGo = [[UITextField alloc] initWithFrame:CGRectMake(72, 320, 100, 31)];
        //[toGo setText:@"Alert"];
        editToGo.borderStyle = UITextBorderStyleRoundedRect;
        editToGo.placeholder = @"Alert";
        [editToGo addTarget:self
                 action:@selector(pickerAlert)
       forControlEvents:UIControlEventAllEvents];
        //[toGo setTextColor:[UIColor lightGrayColor]];
        //[toGo setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
        [self.secondView addSubview:editToGo];
        edit = TRUE;
        
        
    }
    else { NSLog(@"Off");
        [self.editToGo removeFromSuperview];
        edit = FALSE;
    }
    [detailBill setBillReminder:[NSNumber numberWithBool:edit]];
    NSManagedObjectContext *context = [self.detailBill managedObjectContext];
    NSError *error = nil;
    if(![context save:&error])  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shit.." message:@"Well it didn't save" delegate:self cancelButtonTitle:@"Blah.." otherButtonTitles: nil];
        [alert show];
        
    }

    
    
}


-(void)pickerAlert{
    
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
    editToGo.inputView = pickerView;
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
    editToGo.inputAccessoryView = keyboardDoneButtonView;
    [keyboardDoneButtonView removeFromSuperview];
}

-(void)donePickerAlert{
    [editToGo resignFirstResponder];
    editToGo.text = temp;
    [detailBill setBillAlert:editToGo.text];
    NSManagedObjectContext *context = [self.detailBill managedObjectContext];
    NSError *error = nil;
    if(![context save:&error])  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Shit.." message:@"Well it didn't save" delegate:self cancelButtonTitle:@"Blah.." otherButtonTitles: nil];
        [alert show];
        
    }

    
    
    
}






@end
