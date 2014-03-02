//
//  Event.h
//  BalanceCopy2
//
//  Created by Robert Miller on 7/8/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * timeStamp;

@end
