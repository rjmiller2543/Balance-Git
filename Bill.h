//
//  Bill.h
//  BalanceCopy2
//
//  Created by Alexander Arias on 8/11/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Bill : NSManagedObject

@property (nonatomic, retain) NSString * billAlert;
@property (nonatomic, retain) NSNumber * billAmount;
@property (nonatomic, retain) NSDate * billDate;
@property (nonatomic, retain) NSNumber * billReminder;
@property (nonatomic, retain) NSString * billRepeat;
@property (nonatomic, retain) NSString * billType;
@property (nonatomic, retain) NSString * currentBill;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * transaction;
@property (nonatomic, retain) NSString *accountName;

@end

