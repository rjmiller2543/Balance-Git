//
//  TransactionViewController.h
//  BalanceCopy2
//
//  Created by Robert Miller on 7/17/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransactionViewControllerDelegate;

@interface TransactionViewController : UITableViewController

@property(weak,nonatomic) id<TransactionViewControllerDelegate> delegate;

@end

@protocol TransactionViewControllerDelegate <NSObject>

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
