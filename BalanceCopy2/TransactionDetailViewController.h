//
//  TransactionDetailViewController.h
//  BalanceCopy2
//
//  Created by Robert Miller on 8/17/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionDetailViewController : UIViewController   {
    Transaction *detailTransaction;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *amountLabel;
    IBOutlet UILabel *typeLabel;
    IBOutlet UILabel *withdrawalLabel;
}

@property (nonatomic, retain) Transaction *detailTransaction;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *amountLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *withdrawalLabel;

@end
