//
//  MonthOverview.h
//  BalanceCopy2
//
//  Created by Robert Miller on 8/14/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MonthOverview : NSManagedObject

@property (nonatomic, retain) NSNumber * carPayments;
@property (nonatomic, retain) NSNumber * creditCards;
@property (nonatomic, retain) NSNumber * food;
@property (nonatomic, retain) NSNumber * grocery;
@property (nonatomic, retain) NSNumber * insurance;
@property (nonatomic, retain) NSString * monthString;
@property (nonatomic, retain) NSNumber * mortgage;
@property (nonatomic, retain) NSNumber * other;
@property (nonatomic, retain) NSNumber * utilities;
@property (nonatomic, retain) NSNumber * gas;
@property (nonatomic, retain) NSNumber * loan;
@property (nonatomic, retain) NSNumber * studentLoan;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString *accountName;

@end
