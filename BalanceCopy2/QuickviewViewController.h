//
//  QuickviewViewController.h
//  BalanceCopy2
//
//  Created by Robert Miller on 8/12/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickViewBackgroundController.h"

@interface QuickviewViewController : UIViewController   {
    
    IBOutlet UILabel *balanceLabel;
    IBOutlet UILabel *accountNameLabel;
    UISwipeGestureRecognizer *swipeRight;
    UISwipeGestureRecognizer *swipeLeft;
    QuickViewBackgroundController *backgroundViewController;
    
}

@property (nonatomic, retain) IBOutlet UILabel *balanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *accountNameLabel;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRight;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic, retain) QuickViewBackgroundController *backgroundViewController;

-(IBAction)newTransaction:(id)sender;
-(void)configureView;

@end
