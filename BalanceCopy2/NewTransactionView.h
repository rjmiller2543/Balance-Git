//
//  NewTransactionView.h
//  BalanceCopy2
//
//  Created by Robert Miller on 8/11/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"
#import "TransactionTypeViewController.h"
#import "TransactionDateViewController.h"
#import "BillSelectorViewController.h"
#import "MonthOverview.h"

@interface NewTransactionView : UIViewController <TransactionTypeViewControllerDelegate, TransactionDateViewControllerDelegate, BillSelectorViewControllerDelegate> {
    //UI Items
    IBOutlet UILabel *transactionTypeLabel;
    IBOutlet UILabel *transactionDateLabel;
    IBOutlet UITextField *transactionNameTextField;
    IBOutlet UITextField *transactionAmountTextField;
    IBOutlet UISegmentedControl *segmentedControl;
    NSString *tempName;
    NSString *tempType;
    NSString *tempAmount;
    NSNumber *status;
    //NSNumber *tempAmount;
    
    //To Create or Edit
    Transaction *transaction;
    MonthOverview *overview;
    
    //A global variable for saving data
    BOOL saveWithdrawal;
    NSDate *saveDate;
}

@property (nonatomic, retain) IBOutlet UILabel *transactionTypeLabel;
@property (nonatomic, retain) IBOutlet UILabel *transactionDateLabel;
@property (nonatomic, retain) IBOutlet UITextField *transactionNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *transactionAmountTextField;
@property (nonatomic, retain) Transaction *transaction;
@property (nonatomic, retain) MonthOverview *overview;
@property (nonatomic, retain) NSDate *saveDate;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) NSString *tempName;
@property (nonatomic, retain) NSString *tempType;
@property (nonatomic, retain) NSString *tempAmount; 
@property (nonatomic, retain) NSNumber *status;

-(IBAction)setupDateLabel:(id)sender;
-(IBAction)setupTypeLabel:(id)sender;
-(IBAction)setBoolWithdrawal:(id)sender;
-(IBAction)saveContext:(id)sender;
-(IBAction)cancelView:(id)sender;
-(IBAction)removeKeyboard:(id)sender;

-(IBAction)setupMonthlyBill:(id)sender;

@end
