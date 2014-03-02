//
//  QVCustomCell.m
//  BalanceCopy2
//
//  Created by Robert Miller on 2/12/13.
//  Copyright (c) 2013 Gables Engineering. All rights reserved.
//

#import "QVCustomCell.h"

@implementation QVCustomCell
@synthesize backgroundView, balanceLabel, accountNameLabel, bankAccountButton;

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

    // Configure the view for the selected state
}

@end
