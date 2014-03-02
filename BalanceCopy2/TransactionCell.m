//
//  TransactionCell.m
//  BalanceCopy2
//
//  Created by Robert Miller on 8/11/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "TransactionCell.h"

@implementation TransactionCell
@synthesize titleLabel,dateLabel,balanceLabel,amountLabel,cellTransaction;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    titleLabel.text = [cellTransaction transactionName];
    //balanceLabel.text = [[cellTransaction balanceAfterTransaction] stringValue];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    amountLabel.text = [numberFormatter stringFromNumber:[cellTransaction transactionAmount]];
    if ([[cellTransaction balanceAfterTransaction] floatValue] < 0) {
        NSString *useThis = @"-";
        balanceLabel.text = [useThis stringByAppendingString:[numberFormatter stringFromNumber:[cellTransaction balanceAfterTransaction]]];
    }
    else    {
        balanceLabel.text = [numberFormatter stringFromNumber:[cellTransaction balanceAfterTransaction]];
    }
    //amountLabel.text = [[cellTransaction transactionAmount] stringValue];
    if([[cellTransaction withdrawal] boolValue])    {
        amountLabel.textColor = [UIColor redColor];
    }
    else    {
        amountLabel.textColor = [UIColor greenColor];
    }
    static NSDateFormatter *dateFormatter = nil;
    if(dateFormatter == nil)    {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    dateLabel.text = [dateFormatter stringFromDate:[cellTransaction timeStamp]];
    // Configure the view for the selected state
}

@end
