//
//  ListViewController.h
//  BalanceCopy2
//
//  Created by Robert Miller on 7/4/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TransactionViewController.h"

@interface ListViewController : UITableViewController <NSFetchedResultsControllerDelegate,TransactionViewControllerDelegate>  {
    IBOutlet UITableView *backgroundView;
    TransactionViewController *backgroundViewController;
    NSArray *dataArray;
    NSDate *saveDate;
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, retain) IBOutlet UITableView *backgroundView;
@property(nonatomic, retain) TransactionViewController *backgroundViewController;
@property(nonatomic, retain) NSArray *dataArray;
@property(nonatomic, retain) NSDate *saveDate;

-(void)updateToDaily:(TransactionViewController*)controller;
-(void)updateToWeekly:(TransactionViewController*)controller;
-(void)updateToMonthly:(TransactionViewController*)controller;
-(void)updateToFullList:(TransactionViewController*)controller;
-(void)updateToCarPayment:(TransactionViewController*)controller;
-(void)updateToCreditCard:(TransactionViewController*)controller;
-(void)updateToFood:(TransactionViewController*)controller;
-(void)updateToGrocery:(TransactionViewController*)controller;
-(void)updateToInsurance:(TransactionViewController*)controller;
-(void)updateToOther:(TransactionViewController*)controller;
-(void)updateToPaycheck:(TransactionViewController*)controler;
-(void)updateToUtility:(TransactionViewController*)controller;

@end
