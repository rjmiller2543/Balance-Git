//
//  CalendarViewController.h
//  BalanceCopy2
//
//  Created by Alexander Arias on 1/29/13.
//  Copyright (c) 2013 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KalViewController;

@interface CalendarViewController : UIViewController <UITableViewDelegate>  {
    UINavigationController *navController;
    KalViewController *kal;
    id dataSource;
}

@end
