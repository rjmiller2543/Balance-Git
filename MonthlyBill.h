//
//  MonthlyBill.h
//  BalanceCopy2
//
//  Created by Alexander Arias on 8/2/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

//#import <Foundation/Foundation.h>

//@interface MonthlyBill : NSObject

//@end
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <EventKit/EventKit.h>

//#import "Bill.h"

@interface MonthlyBill : UITableViewController  <NSFetchedResultsControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate> {
    
    IBOutlet UITextField *bsTestField;
    IBOutlet UIScrollView *secondView;
    IBOutlet UITextField *title;
    IBOutlet UITextField *category;
    IBOutlet UITextField *amount;
    IBOutlet UILabel *wDrawal;
    IBOutlet UILabel *deposit;
    IBOutlet UITextField *wcheck;
    IBOutlet UITextField *dcheck;
    IBOutlet UILabel *reminder;
    //TEST
    UIPickerView *pickerView;
    NSMutableArray *dataArray;
    //TEST
    UIDatePicker *datePicker;
    NSString *temp;
    NSDate *saveDate;
    IBOutlet UITextField *toGo;
    IBOutlet UITextField *repeat;
    NSNumber *daysAway;
    NSString *pickerBool;
    
    //Setting up Reminders with its associated alarm
    
    
    
    
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, retain) UIPickerView *pickerView;
@property (strong, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) NSNumber *daysAway;
@property (nonatomic, retain) NSString *pickerBool;

//Setting up Reminders with its associated alarm
@property (strong, nonatomic) EKEventStore *eventStore;




//UserInter
@property (nonatomic, retain) IBOutlet UITextField *title;
@property (nonatomic, retain) IBOutlet UITextField *category;
@property (nonatomic, retain) IBOutlet UITextField *amount;
@property (nonatomic, retain) IBOutlet UITextField *date;
@property (nonatomic, retain) IBOutlet UILabel *wDrwal;
@property (nonatomic, retain) IBOutlet UILabel *deposit;
@property (nonatomic, retain) IBOutlet UITextField *wcheck;
@property (nonatomic, retain) IBOutlet UITextField *dcheck;
@property (nonatomic, retain) IBOutlet UISwitch *onOff;
@property (nonatomic, retain) IBOutlet UILabel *reminder;
@property (nonatomic, retain) NSString *temp;
@property (nonatomic, retain) NSDate *saveDate;


//@property (strong, nonatomic) UIScrollView *secondView;
@property (nonatomic, retain) UIScrollView *secondView;
@property (nonatomic, retain) IBOutlet UITextField *toGo;
@property (nonatomic, retain) IBOutlet UITextField *repeat;

-(IBAction)removeKeyboard:(id)sender;
//-(IBAction)setReminder:(id) sender;


@end
