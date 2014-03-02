//
//  TransactionTypeViewController.h
//  BalanceCopy2
//
//  Created by Robert Miller on 8/12/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransactionTypeViewControllerDelegate;

@interface TransactionTypeViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>  {
    NSArray *typeChoices;
    IBOutlet UIPickerView *pickerView;
    NSString *currType;
}

@property (nonatomic, retain) NSArray *typeChoices;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) NSString *currType;
@property (weak, nonatomic) id<TransactionTypeViewControllerDelegate> delegate;

@end

@protocol TransactionTypeViewControllerDelegate <NSObject>

-(void)TransactionTypeViewController:(TransactionTypeViewController*)controller didSelectType:(NSString*)type;

@end
