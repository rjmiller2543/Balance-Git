//
//  AppDelegate.m
//  BalanceCopy2
//
//  Created by Robert Miller on 7/4/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "AppDelegate.h"
#import "ListViewController.h"
#import "QuickviewViewController.h"


@implementation AppDelegate

@synthesize window = _window;
//@synthesize window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize appBalance, lastPaycheck, lastDeposit, billArray, accountName, lastAccountUsed;
@synthesize dataCenterAccount, accountsArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    appBalance = [[NSNumber alloc] initWithFloat:[prefs floatForKey:@"key"]];
    lastPaycheck = [[NSNumber alloc] initWithFloat:[prefs floatForKey:@"lastCheck"]];
    NSLog(@"last paycheck in app delegate is: %@",lastPaycheck);
    lastDeposit = [[NSNumber alloc] initWithFloat:[prefs floatForKey:@"lastDeposit"]];
    lastAccountUsed = [[NSNumber alloc] initWithInt:[prefs integerForKey:@"lastAccountUsed"]];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Account" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:4];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    if ([[aFetchedResultsController fetchedObjects] count] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Before using this App, you must first create a new Account" message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
        
        alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        
        [[alertView textFieldAtIndex:1] setSecureTextEntry:NO];
        
        [[alertView textFieldAtIndex:0] setPlaceholder:@"Account Name"];
        [[alertView textFieldAtIndex:1] setPlaceholder:@"Account Balance"];
        
        
        [alertView show];
        
    }
    else    {
        
        dataCenterAccount = [[aFetchedResultsController fetchedObjects] objectAtIndex:[lastAccountUsed intValue]];
        
    }
        
    return YES;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex   {
    
    NSString *temporaryAccountName = [[alertView textFieldAtIndex:0] text];
    NSNumber *temporaryAccountBalance = [[NSNumber alloc] initWithFloat:[[[alertView textFieldAtIndex:1] text] floatValue]];
    accountName = temporaryAccountName;
    appBalance = temporaryAccountBalance;
    lastDeposit = temporaryAccountBalance;
    
    dataCenterAccount = (Account *)[NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:self.managedObjectContext];
    
    [dataCenterAccount setAccountName:temporaryAccountName];
    [dataCenterAccount setAccountBalance:temporaryAccountBalance];
    [dataCenterAccount setLastDeposit:temporaryAccountBalance];
    [dataCenterAccount setLastPaycheck:0];
    [dataCenterAccount setTimeStamp:[NSDate date]];
    
    NSError *error = nil;
    
    if(![dataCenterAccount.managedObjectContext save:&error])   {
        
        NSLog(@"Something's gone wrong");
        
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"BalanceCopy2" bundle:nil];
    QuickviewViewController *qv = [storyboard instantiateViewControllerWithIdentifier:@"qvController"];
    [qv configureView];

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"app will resign active");
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:[appBalance floatValue] forKey:@"key"];
    
    [prefs setInteger:[lastAccountUsed intValue] forKey:@"lastAccountUsed"];
    
    NSError *error = nil;
    
    if(![dataCenterAccount.managedObjectContext save:&error])   {
        
        NSLog(@"Something's gone wrong");
        
    }
    
    //[prefs setObject:self.accountsArray forKey:@"Accounts"];
    //[prefs setFloat:0 forKey:@"key"];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"app will terminate");
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:[appBalance floatValue] forKey:@"key"];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *amanagedObjectContext = self.managedObjectContext;
    if (amanagedObjectContext != nil)
    {
        if ([amanagedObjectContext hasChanges] && ![amanagedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BalanceCopy2" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BalanceCopy2.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
