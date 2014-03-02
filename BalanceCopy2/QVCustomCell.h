//
//  QVCustomCell.h
//  BalanceCopy2
//
//  Created by Robert Miller on 2/12/13.
//  Copyright (c) 2013 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QVCustomCell : UITableViewCell   {
    
    IBOutlet UILabel *accountNameLabel;
    IBOutlet UILabel *balanceLabel;
    IBOutlet UIButton *bankAccountButton;
    
}

@property (nonatomic, retain) IBOutlet UILabel *accountNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *balanceLabel;
@property (nonatomic, retain) IBOutlet UIButton *bankAccountButton;

@end
