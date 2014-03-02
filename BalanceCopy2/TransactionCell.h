//
//  TransactionCell.h
//  BalanceCopy2
//
//  Created by Robert Miller on 8/11/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionCell : UITableViewCell    {
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UILabel *amountLabel;
    IBOutlet UILabel *balanceLabel;
    Transaction *cellTransaction;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *amountLabel;
@property (nonatomic, retain) IBOutlet UILabel *balanceLabel;
@property (nonatomic, retain) Transaction *cellTransaction;

@end
