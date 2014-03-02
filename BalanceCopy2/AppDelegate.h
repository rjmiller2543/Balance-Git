//
//  AppDelegate.h
//  BalanceCopy2
//
//  Created by Robert Miller on 7/4/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>    {
    
    NSManagedObjectContext *managedObjectContext;
    NSNumber *appBalance;
    NSNumber *lastPaycheck;
    NSNumber *lastDeposit;
    NSArray *billArray;
    NSString *accountName;
    Account *dataCenterAccount;
    NSArray *accountsArray;
    NSNumber *lastAccountUsed;
    
}

@property (strong, nonatomic) UIWindow *window;
//Second Phase
//@property (strong,nonatomic) UIWindow *billWindow;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) NSNumber *appBalance;
@property (nonatomic, retain) NSNumber *lastPaycheck;
@property (nonatomic, retain) NSNumber *lastDeposit;
@property (nonatomic, retain) NSArray *billArray;
@property (nonatomic, retain) NSString *accountName;
@property (nonatomic, retain) Account *dataCenterAccount;
@property (nonatomic, retain) NSArray *accountsArray;
@property (nonatomic, retain) NSNumber *lastAccountUsed;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
