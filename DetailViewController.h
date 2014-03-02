//
//  DetailViewController.h
//  BalanceCopy2
//
//  Created by Alexander Arias on 8/7/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bill.h"
//#import <CoreData/CoreData.h>

@class UITableView;

@interface DetailViewController : UIViewController <UITableViewDelegate,NSFetchedResultsControllerDelegate, NSFetchedResultsControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate>{
    
    IBOutlet UIScrollView *secondView;
    Bill *detailBill;
    
    IBOutlet UITextField *bsTestField;
    //IBOutlet UILabel *label;
    //IBOutlet UILabel *label2;
    IBOutlet UITextField *editTitle;
    IBOutlet UITextField *editCategory;
    IBOutlet UITextField *editAmount;
    IBOutlet UITextField *editDate;
    IBOutlet UILabel *editWdrwal;
    IBOutlet UILabel *editDep;
    IBOutlet UITextField *editWcheck;
    IBOutlet UITextField *editDcheck;
    IBOutlet UITextField *editRepeat;
    IBOutlet UISegmentedControl *deleteBill;
    IBOutlet UISegmentedControl *payBill;
    IBOutlet UILabel *editReminder;
    IBOutlet UITextField *editToGo;
    //IBAction UIButton *delete;
    
    //TEST
    UIPickerView *pickerView;
    NSMutableArray *dataArray;
    NSString *temp;
    UIDatePicker *datePicker;
    NSDate *saveDate;
    
    
}

@property (strong, retain) UIPickerView *pickerView;
@property (strong, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSString *temp;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) NSDate *saveDate;



@property (strong, nonatomic) UIScrollView *secondView;

@property (strong, nonatomic) NSManagedObjectContext *selectedObject;
@property (nonatomic, retain) Bill *detailBill;
//@property (nonatomic, retain) IBOutlet UILabel *label;
//@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UITextField *editTitle;
@property (nonatomic, retain) IBOutlet UITextField *editCategory;
@property (nonatomic, retain) IBOutlet UITextField *editAmount;
@property (nonatomic, retain) IBOutlet UITextField *editDate;
@property (nonatomic, retain) IBOutlet UILabel *editWdrwal;
@property (nonatomic, retain) IBOutlet UILabel *editDep;
@property (nonatomic, retain) IBOutlet UITextField *editWcheck;
@property (nonatomic, retain) IBOutlet UITextField *editDcheck;
@property (nonatomic, retain) IBOutlet UITextField *editRepeat;
@property (nonatomic, retain) IBOutlet UISegmentedControl *deleteBill;
@property (nonatomic, retain) IBOutlet UISegmentedControl *payBill;

@property (nonatomic, retain) IBOutlet UISwitch *editOnOff;
@property (nonatomic, retain) IBOutlet UILabel *editReminder;
@property (nonatomic, retain) IBOutlet UITextField *editToGo;

@property (nonatomic, assign) IBOutlet UITableView *tableView;


@end
