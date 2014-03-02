//
//  Account.h
//  BalanceCopy2
//
//  Created by Robert Miller on 2/18/13.
//  Copyright (c) 2013 Gables Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * accountName;
@property (nonatomic, retain) NSNumber * accountBalance;
@property (nonatomic, retain) NSNumber * lastPaycheck;
@property (nonatomic, retain) NSNumber * lastDeposit;
@property (nonatomic, retain) NSDate *timeStamp;

@end
