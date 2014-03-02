//
//  BillSelectorViewController.h
//  BalanceCopy2
//
//  Created by Robert Miller on 8/13/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BillSelectorViewControllerDelegate;

@interface BillSelectorViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UIPickerView *pickerView;
    NSNumber *index;
    NSArray *billChoices;
}

@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) NSNumber *index;
@property (nonatomic, retain) NSArray *billChoices;
@property (weak, nonatomic) id<BillSelectorViewControllerDelegate> delegate;

@end

@protocol BillSelectorViewControllerDelegate <NSObject>

-(void)BillSelectorViewController:(BillSelectorViewController*)controller didSelectIndex:(NSInteger)index;

@end
