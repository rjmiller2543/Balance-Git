//
//  NewTransactionView.m
//  BalanceCopy2
//
//  Created by Robert Miller on 8/11/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "NewTransactionView.h"
#import "AppDelegate.h"
#import "Bill.h"

@interface NewTransactionView ()

@end

@implementation NewTransactionView
@synthesize transactionAmountTextField, transactionNameTextField, transactionDateLabel, transactionTypeLabel, transaction, saveDate;
@synthesize overview;
@synthesize tempName, tempAmount, tempType, segmentedControl, status;

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
    //saveWithdrawal = TRUE;
    saveDate = [NSDate date];
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    transactionDateLabel.text = [dateFormatter stringFromDate:saveDate];
    
    transactionAmountTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    if (([[[UIDevice currentDevice] systemVersion] doubleValue] >= 4.1)) {
        transactionAmountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    self.transactionNameTextField.text = tempName;
    //Writing to Amount Textfield
    self.transactionAmountTextField.text = tempAmount;
    self.transactionTypeLabel.text = tempType;
    //saveWithdrawal = [boolvalue:status];
    NSLog(@"Status value is %@", status);
    NSLog(@"Status value is %c", saveWithdrawal);
    
    //if ([status boolValue])
    //    [segmentedControl setSelectedSegmentIndex:1];

    //else
    //    [segmentedControl setSelectedSegmentIndex:0];

    //[self setBoolWithdrawal:nil];


    if(transaction != nil)  {
        [self configureView];
    }
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)configureView    {
    
    NSLog(@"configure view transaction name:%@",[transaction transactionName]);
    //TEST to know if Amount is passed
    NSLog(@"configure view transaction Amount:%@",[transaction transactionAmount]);
    //TEST
    
    NSString *temp = [[NSString alloc] initWithString:[transaction transactionName]];
    NSLog(@"temp is: %@",temp);
    //self.transactionNameTextField.text = @"yarg";
    //self.transactionNameTextField.textColor = [UIColor grayColor];
    self.transactionNameTextField.text = temp;
    NSLog(@"textfield is: %@",self.transactionNameTextField.text);
    self.transactionAmountTextField.text = [[transaction transactionAmount] stringValue];
    self.transactionTypeLabel.text = [transaction transactionType];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.transactionDateLabel.text = [dateFormatter stringFromDate:[transaction timeStamp]];
    
    [segmentedControl setSelectedSegmentIndex:![[transaction withdrawal] boolValue]];
    [segmentedControl setSelectedSegmentIndex:0];

    [segmentedControl sendActionsForControlEvents:UIControlEventValueChanged];
    saveDate = [transaction timeStamp];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma  mark - View Controlling Methods

-(IBAction)cancelView:(id)sender    {
    
    [self dismissModalViewControllerAnimated:YES];

}

-(IBAction)saveContext:(id)sender   {
    AppDelegate *dataCenter = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if(transaction == nil)  {
        self.transaction = (Transaction*)[NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:dataCenter.managedObjectContext];
        
    }
    
    NSError *error = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MonthOverview" inManagedObjectContext:dataCenter.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setEntity:entity];
    
    NSLog(@"saveDate is: %@",[saveDate description]);
    NSDate *referenceDate;
    [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&referenceDate interval:nil forDate:saveDate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ >= startDate && %@ < endDate", saveDate, saveDate];
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"accountName == %@",[dataCenter.dataCenterAccount accountName]];
    NSArray *predicates = @[predicate, namePredicate];
    NSPredicate *allPredicates = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    [fetchRequest setPredicate:allPredicates];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:dataCenter.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    NSError *secondError = nil;
    [fetchedResultsController performFetch:&secondError];
    NSArray *monthArray = [[NSArray alloc] initWithArray:[fetchedResultsController fetchedObjects]];
    NSLog(@"num months:%u",[monthArray count]);
    NSLog(@"type is: %@",self.transactionTypeLabel.text);
    NSString *referenceString = self.transactionTypeLabel.text;

    if ([monthArray count] == 0) {
        //create a monthOverview
        NSLog(@"count is 0");
        overview = (MonthOverview*)[NSEntityDescription insertNewObjectForEntityForName:@"MonthOverview" inManagedObjectContext:dataCenter.managedObjectContext];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM"];
        [overview setMonthString:[dateFormatter stringFromDate:saveDate]];
        NSLog(@"saving for month: %@",[overview monthString]);
        [overview setStartDate:referenceDate];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.month = 1;
        NSDate *endDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:referenceDate options:0];
        [overview setEndDate:endDate];
        //if(self.transactionTypeLabel.text == @"Car Payment")    {
        if([self.transactionTypeLabel.text isEqualToString:@"Car Payment"]) {
            NSLog(@"setCarPayments");
            [overview setCarPayments:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Credit Card"])    {
        //if(self.transactionTypeLabel.text == @"Credit Card")    {
            NSLog(@"setCreditCards");
            [overview setCreditCards:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Dining Out"])    {
        //if(self.transactionTypeLabel.text == @"Dining Out")    {
            [overview setFood:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Gas"])    {
        //if(self.transactionTypeLabel.text == @"Gas")    {
            [overview setGas:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Grocery"])    {
        //if(self.transactionTypeLabel.text == @"Grocery")    {
            [overview setGrocery:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Insurance"])    {
        //if(self.transactionTypeLabel.text == @"Insurance")    {
            [overview setInsurance:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Loan"])    {
        //if(self.transactionTypeLabel.text == @"Loan")    {
            [overview setLoan:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Mortgage"])    {
        //if(self.transactionTypeLabel.text == @"Mortgage")    {
            [overview setMortgage:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Other"])    {
        //if(self.transactionTypeLabel.text == @"Other")    {
            [overview setOther:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Student Loan"])    {
        //if(self.transactionTypeLabel.text == @"Student Loan")    {
            [overview setStudentLoan:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Utility"])    {
        //if(self.transactionTypeLabel.text == @"Utility")    {
            [overview setUtilities:[NSNumber numberWithFloat:[self.transactionAmountTextField.text floatValue]]];
        }
        
        [overview setAccountName:[dataCenter.dataCenterAccount accountName]];
        [dataCenter.managedObjectContext save:&error];
        
    }
    else    {
        overview = (MonthOverview*)[monthArray objectAtIndex:0];
        NSLog(@"month is: %@ ",[overview monthString]);
        if([referenceString isEqualToString:@"Car Payment"])    {
            NSLog(@"setCarPayments");
            [overview setCarPayments:[NSNumber numberWithFloat:[[overview carPayments] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Credit Card"])    {
        //if(referenceString == @"Credit Card")    {
            NSLog(@"adding to credit card");
            [overview setCreditCards:[NSNumber numberWithFloat:[[overview creditCards] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Dining Out"])    {
        //if(self.transactionTypeLabel.text == @"Dining Out")    {
            NSLog(@"adding to food");
            [overview setFood:[NSNumber numberWithFloat:[[overview food] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Gas"])    {
        //if(self.transactionTypeLabel.text == @"Gas")    {
            [overview setGas:[NSNumber numberWithFloat:[[overview gas] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Grocery"])    {
        //if(self.transactionTypeLabel.text == @"Grocery")    {
            [overview setGrocery:[NSNumber numberWithFloat:[[overview grocery] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Insurance"])    {
        //if(self.transactionTypeLabel.text == @"Insurance")    {
            NSLog(@"adding to insurnace");

            [overview setInsurance:[NSNumber numberWithFloat:[[overview insurance] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Loan"])    {
        //if(self.transactionTypeLabel.text == @"Loan")    {
            NSLog(@"adding to loan");

            [overview setLoan:[NSNumber numberWithFloat:[[overview loan] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Mortgage"])    {
        //if(self.transactionTypeLabel.text == @"Mortgage")    {
            NSLog(@"adding to mortgage");

            [overview setMortgage:[NSNumber numberWithFloat:[[overview mortgage] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Other"])    {
        //if(self.transactionTypeLabel.text == @"Other")    {
            NSLog(@"adding to other");

            [overview setOther:[NSNumber numberWithFloat:[[overview other] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Student Loan"])    {
        //if(self.transactionTypeLabel.text == @"Student Loan")    {
            NSLog(@"adding to student loan");

            [overview setStudentLoan:[NSNumber numberWithFloat:[[overview studentLoan] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        if([referenceString isEqualToString:@"Utility"])    {
        //if(self.transactionTypeLabel.text == @"Utility")    {
            NSLog(@"adding to utility");

            [overview setUtilities:[NSNumber numberWithFloat:[[overview utilities] floatValue] + [self.transactionAmountTextField.text floatValue]]];
        }
        NSError *nextError = nil;
        if(![overview.managedObjectContext save:&nextError])    {
            
        }
    }
    [transaction setTransactionName:transactionNameTextField.text];
    [transaction setTransactionAmount:[NSNumber numberWithFloat:[transactionAmountTextField.text floatValue]]];
    [transaction setTimeStamp:saveDate];
    [transaction setTransactionType:transactionTypeLabel.text];
    [transaction setWithdrawal:[NSNumber numberWithBool:saveWithdrawal]];
    [transaction setAccountName:[dataCenter.dataCenterAccount accountName]];
    
    if(saveWithdrawal)  {
        
        NSLog(@"Withdrawal funds");
        float saveData = [dataCenter.appBalance floatValue] - [transactionAmountTextField.text floatValue];
        [transaction setBalanceAfterTransaction:[NSNumber numberWithFloat:saveData]];
        dataCenter.appBalance = [NSNumber numberWithFloat:saveData];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setFloat:[dataCenter.appBalance floatValue] forKey:@"key"];
        
    }
    
    else    {
        
        NSLog(@"Deposit funds");
        float saveData = [dataCenter.appBalance floatValue] + [transactionAmountTextField.text floatValue];
        [transaction setBalanceAfterTransaction:[NSNumber numberWithFloat:saveData]];
        dataCenter.appBalance = [NSNumber numberWithFloat:saveData];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setFloat:[dataCenter.appBalance floatValue] forKey:@"key"];
        
        if([transactionTypeLabel.text isEqualToString: @"Paycheck"])    {
            dataCenter.lastPaycheck = [NSNumber numberWithFloat:[transactionAmountTextField.text floatValue]];
            [prefs setFloat:[dataCenter.lastPaycheck floatValue] forKey:@"lastCheck"];
            dataCenter.dataCenterAccount.lastPaycheck = dataCenter.lastPaycheck;
        }
        else    {
            dataCenter.lastDeposit = [NSNumber numberWithFloat:[transactionAmountTextField.text floatValue]];
            [prefs setFloat:[dataCenter.lastDeposit floatValue] forKey:@"lastDeposit"];
            dataCenter.dataCenterAccount.lastDeposit = dataCenter.lastDeposit;
        }
    }
    
    dataCenter.dataCenterAccount.accountBalance = dataCenter.appBalance;
    
    [self dismissModalViewControllerAnimated:YES];
    if(![dataCenter.managedObjectContext save:&error])  {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did Not Save!" message:@"The damned thing didn't save..." delegate:self cancelButtonTitle:@"Sonofa Bitch" otherButtonTitles:nil];
        [alertView show];
    }
}

-(IBAction)setBoolWithdrawal:(id)sender {
    NSLog(@"Set the withdrawal bool");
    UISegmentedControl *segmentedConrol = (UISegmentedControl*)sender;
    if([segmentedConrol selectedSegmentIndex] == 1) {
        NSLog(@"False Withdrawal");
        [segmentedControl setSelectedSegmentIndex:1];
        saveWithdrawal = FALSE;
    }
    else    {
        [segmentedControl setSelectedSegmentIndex:0];
        saveWithdrawal = TRUE;
    }
}

-(IBAction)setupTypeLabel:(id)sender  {
    NSLog(@"set type label");
    [self removeKeyboard:self];
    TransactionTypeViewController *typeController = [self.storyboard instantiateViewControllerWithIdentifier:@"typeController"];
    typeController.delegate = self;
    [typeController.view setFrame:CGRectMake(0, 1000, typeController.view.frame.size.width, typeController.view.frame.size.height)];
    
    [self addChildViewController:typeController];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [typeController.view setFrame:CGRectMake(0, 0, typeController.view.frame.size.width, typeController.view.frame.size.height)];
    
    [self.view addSubview:typeController.view];
    
    [UIView commitAnimations];
}

-(void)TransactionTypeViewController:(TransactionTypeViewController*)controller didSelectType:(NSString*)type   {
    self.transactionTypeLabel.text = type;
}

-(IBAction)setupDateLabel:(id)sender    {
    [self removeKeyboard:self];
    TransactionDateViewController *dateController = [self.storyboard instantiateViewControllerWithIdentifier:@"dateController"];
    dateController.delegate = self;
    [dateController.view setFrame:CGRectMake(0, 1000, dateController.view.frame.size.width, dateController.view.frame.size.height)];
    
    [self addChildViewController:dateController];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [dateController.view setFrame:CGRectMake(0, 0, dateController.view.frame.size.width, dateController.view.frame.size.height)];
    
    [self.view addSubview:dateController.view];
    
    [UIView commitAnimations];
}

-(void)TransactionDateViewController:(TransactionDateViewController *)controller didSelectDate:(NSDate *)date {
    saveDate = date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    self.transactionDateLabel.text = [dateFormatter stringFromDate:date];
}

-(IBAction)setupMonthlyBill:(id)sender  {
    [self removeKeyboard:self];
    BillSelectorViewController *billController = [self.storyboard instantiateViewControllerWithIdentifier:@"billController"];
    billController.delegate = self;
    [billController.view setFrame:CGRectMake(0, 1000, billController.view.frame.size.width, billController.view.frame.size.height)];
    
    [self addChildViewController:billController];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [billController.view setFrame:CGRectMake(0, 0, billController.view.frame.size.width, billController.view.frame.size.height)];
    
    [self.view addSubview:billController.view];
    
    [UIView commitAnimations];
}

-(void)BillSelectorViewController:(BillSelectorViewController *)controller didSelectIndex:(NSInteger)index  {
    AppDelegate *dataCenter = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Bill *tempBill = (Bill*)[dataCenter.billArray objectAtIndex:index];
    NSLog(@"%@",[tempBill currentBill]);
    transactionNameTextField.text = (NSString*)[tempBill currentBill];
    transactionAmountTextField.text = (NSString*)[tempBill billAmount];
    if ([[tempBill billType] isEqualToString:@"Car Payment"]) {
        self.transactionTypeLabel.text = @"Car Payment";
    }
    if ([[tempBill billType] isEqualToString:@"Credit Card"]) {
        self.transactionTypeLabel.text = @"Credit Card";
    }
    if ([[tempBill billType] isEqualToString:@"Insurance"]) {
        self.transactionTypeLabel.text = @"Insurance";
    }
    if ([[tempBill billType] isEqualToString:@"Loans"]) {
        self.transactionTypeLabel.text = @"Loan";
    }
    if ([[tempBill billType] isEqualToString:@"Mortgage"]) {
        self.transactionTypeLabel.text = @"Mortgage";
    }
    if ([[tempBill billType] isEqualToString:@"Other"]) {
        self.transactionTypeLabel.text = @"Other";
    }
    if ([[tempBill billType] isEqualToString:@"Student Loans"]) {
        self.transactionTypeLabel.text = @"Student Loan";
    }
    if ([[tempBill billType] isEqualToString:@"Utility"]) {
        self.transactionTypeLabel.text = @"Utility";
    }
}

-(IBAction)removeKeyboard:(id)sender    {
    [transactionAmountTextField resignFirstResponder];
    [transactionNameTextField resignFirstResponder];
}

@end
