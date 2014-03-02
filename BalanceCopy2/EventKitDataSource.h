//
//  EventKitDataSource.h
//  BalanceCopy2
//
//  Created by Alexander Arias on 1/29/13.
//  Copyright (c) 2013 Gables Engineering. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "kal.h"
#import <dispatch/dispatch.h>
#import <CoreData/CoreData.h>

@interface EventKitDataSource : NSObject </*KalDataSource,*/ NSFetchedResultsControllerDelegate> {
    NSMutableArray *items;
    
    NSMutableArray *events;
    
}

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (EventKitDataSource *)dataSource;

@end
