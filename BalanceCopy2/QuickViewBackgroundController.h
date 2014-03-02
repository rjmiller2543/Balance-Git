//
//  QuickViewBackgroundController.h
//  BalanceCopy2
//
//  Created by Robert Miller on 2/9/13.
//  Copyright (c) 2013 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickViewBackgroundController : UITableViewController  <UIAlertViewDelegate> {
    
    IBOutlet UILabel *accountOne;
    IBOutlet UILabel *accountTwo;
    IBOutlet UILabel *accountThree;
    IBOutlet UILabel *accountFour;
    NSNumber *alertViewStringSwitch;
    
}

@property (nonatomic, retain) IBOutlet UILabel *accountOne;
@property (nonatomic, retain) IBOutlet UILabel *accountTwo;
@property (nonatomic, retain) IBOutlet UILabel *accountThree;
@property (nonatomic, retain) IBOutlet UILabel *accountFour;
@property (nonatomic, retain) NSNumber *alertViewStringSwitch;

-(IBAction)addBankAccount:(id)sender;

@end
