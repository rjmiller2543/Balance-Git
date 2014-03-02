//
//  TransactionDateViewController.h
//  BalanceCopy2
//
//  Created by Robert Miller on 8/12/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransactionDateViewControllerDelegate;

@interface TransactionDateViewController : UIViewController  {
    NSDate *saveDate;
    IBOutlet UIDatePicker *datePicker;
}

@property (nonatomic, retain) NSDate *saveDate;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) id<TransactionDateViewControllerDelegate> delegate;

@end

@protocol TransactionDateViewControllerDelegate <NSObject>

-(void)TransactionDateViewController:(TransactionDateViewController*)controller didSelectDate:(NSDate*)date;

@end
