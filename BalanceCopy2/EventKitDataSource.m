//
//  EventKitDataSource.m
//  BalanceCopy2
//
//  Created by Robert Miller on 1/27/13.
//  Copyright (c) 2013 Gables Engineering. All rights reserved.
//

#import "EventKitDataSource.h"
#import <EventKit/EventKit.h>
#import "Transaction.h"

#import "AppDelegate.h"

static BOOL IsDateBetweenInclusive(NSDate *date, NSDate *begin, NSDate *end)
{
    return [date compare:begin] != NSOrderedAscending && [date compare:end] != NSOrderedDescending;
}

@interface EventKitDataSource ()
- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate;
@end

@implementation EventKitDataSource

@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;

+ (EventKitDataSource *)dataSource
{
    NSLog(@"Data Source return datasource");
    return [[[self class] alloc] init] ;
}

- (id)init
{
    NSLog(@"Data source init");
    if ((self = [super init])) {
        //eventStore = [[EKEventStore alloc] init];
        events = [[NSMutableArray alloc] init];
        items = [[NSMutableArray alloc] init];
        //eventStoreQueue = dispatch_queue_create("com.thepolypeptides.nativecalexample", NULL);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventStoreChanged:) name:EKEventStoreChangedNotification object:nil];
    }
    return self;
}

- (void)eventStoreChanged:(NSNotification *)note
{
    NSLog(@"data source eventStoreChanged");
   // [[NSNotificationCenter defaultCenter] postNotificationName:KalDataSourceChangedNotification object:nil];
}

- (Transaction *)eventAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"data source eventAtIndexPath");
    NSLog(@"event is: %@",[[items objectAtIndex:indexPath.row] transactionName]);
    return (Transaction *)[items objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDataSource protocol conformance

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"data source tableView cellForRow");
    static NSString *identifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    
    
    //EKEvent *event = [self eventAtIndexPath:indexPath];
    Transaction *event = [self eventAtIndexPath:indexPath];
    cell.textLabel.text = event.transactionName;
    cell.detailTextLabel.text = [event.transactionAmount stringValue];
    
    UILabel *accountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(220, 5, 100, 30)];
    accountNameLabel.text = event.accountName;
    
    [cell addSubview:accountNameLabel];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"data source tableView numberOfRows");
    NSLog(@"items: %i",[items count]);
    return [items count];
}

#pragma mark KalDataSource protocol conformance
/*
- (void)presentingDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate delegate:(id<KalDataSourceCallbacks>)delegate
{
    NSLog(@"data source presentingDatesFrom");
    // asynchronous callback on the main thread
    [events removeAllObjects];
    NSLog(@"Fetching events from EventKit between %@ and %@ on a GCD-managed background thread...", fromDate, toDate);
    //dispatch_async(eventStoreQueue, ^{
    //  NSDate *fetchProfilerStart = [NSDate date];
    // NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:fromDate endDate:toDate calendars:nil];
    //        NSArray *matchedEvents = [eventStore eventsMatchingPredicate:predicate];
    //     dispatch_async(dispatch_get_main_queue(), ^{
    //       NSLog(@"Fetched %d events in %f seconds", [matchedEvents count], -1.f * [fetchProfilerStart timeIntervalSinceNow]);
    //     [events addObjectsFromArray:matchedEvents];
    //   [delegate loadedDataSource:self];
    //});
    //});
}
*/
- (NSArray *)markedDatesFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSLog(@"data source markedDatesFrom");
    // synchronous callback on the main thread
    return [[self eventsFrom:fromDate to:toDate] valueForKeyPath:@"startDate"];
}

- (void)loadItemsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSLog(@"data source loadItemsFromDate");
    // synchronous callback on the main thread
    [items addObjectsFromArray:[self eventsFrom:fromDate to:toDate]];
}

- (void)removeAllItems
{
    // synchronous callback on the main thread
    [items removeAllObjects];
}

#pragma mark -

- (NSArray *)eventsFrom:(NSDate *)fromDate to:(NSDate *)toDate
{
    NSLog(@"data source eventsFrom %@ to %@",fromDate, toDate);
    //NSMutableArray *matches = [NSMutableArray array];
    //for (EKEvent *event in events)
    //    if (IsDateBetweenInclusive(event.startDate, fromDate, toDate))
    //        [matches addObject:event];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //self.managedObjectContext = dataCenter.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:dataCenter.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicateFromDate = [NSPredicate predicateWithFormat:@"timeStamp > %@", fromDate];
    NSPredicate *predicateToDate = [NSPredicate predicateWithFormat:@"timeStamp < %@", toDate];
    NSArray *predicateArray = @[predicateFromDate, predicateToDate];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeStamp" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:dataCenter.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    
    
    if(![[self fetchedResultsController] performFetch:&error])  {
        
        NSLog(@"Fetch not done");
        
    }
    
    //Transaction *test = (Transaction *)[[self.fetchedResultsController fetchedObjects] objectAtIndex:1];
    //NSLog(@"event one is: %@", [test transactionName]);
    //NSLog(@"How big is the array?: %i",[[self.fetchedResultsController fetchedObjects] count]);
    
    NSMutableArray *matches = [[NSMutableArray alloc] initWithArray:[self.fetchedResultsController fetchedObjects]];
    
    return matches;
}

- (void)dealloc
{
    NSLog(@"data source dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EKEventStoreChangedNotification object:nil];
    // [super dealloc];
}

@end

