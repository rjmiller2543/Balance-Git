//
//  Transaction.h
//  BalanceCopy2
//
//  Created by Robert Miller on 8/11/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSString * transactionName;
@property (nonatomic, retain) NSString * transactionType;
@property (nonatomic, retain) NSNumber * transactionAmount;
@property (nonatomic, retain) NSNumber * balanceAfterTransaction;
@property (nonatomic, retain) NSNumber * withdrawal;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString *accountName;

@end
