//
//  MonthlyOverviewView.h
//  BalanceCopy2
//
//  Created by Robert Miller on 7/9/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MonthOverview.h"
#import "CorePlot-CocoaTouch.h"

@interface MonthlyOverviewView : UIViewController <NSFetchedResultsControllerDelegate,CPTPlotDataSource,CPTPieChartDataSource,CPTPieChartDelegate> {

    UISwipeGestureRecognizer *gestureRecognizerRight;
    UISwipeGestureRecognizer *gestureRecognizerLeft;
    
    IBOutlet UIImageView *mainImageView;
    IBOutlet UIImageView *secondImageView;
    IBOutlet UIImageView *thirdImageView;
    IBOutlet UIImageView *fourthImageView;
    IBOutlet UIImageView *fifthImageView;
    
    NSArray *viewArray;
    NSIndexPath *indexPath;
    
    IBOutlet UILabel *monthLabel;
    NSString *leftMonthLabel;
    NSString *rightMonthLabel;
    
    NSArray *typeArray;
    NSMutableArray *dataArray;
    NSMutableArray *samples;
    NSArray *colors;
    
    CPTXYGraph *mainBarGraph;
    CPTXYGraph *secondBarGraph;
    CPTXYGraph *thirdBarGraph;
    CPTXYGraph *fourthBarGraph;
    CPTXYGraph *fifthBarGraph;
    
    NSDate *startReference;
    NSDate *endReference;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *firstLabel;
    IBOutlet UILabel *secondLabel;
    IBOutlet UILabel *thirdLabel;
    IBOutlet UILabel *fourthLabel;
    IBOutlet UILabel *fifthLabel;
    IBOutlet UILabel *sixthLabel;
    IBOutlet UILabel *seventhLabel;
    IBOutlet UILabel *eightLabel;
    IBOutlet UILabel *ninthLabel;
    IBOutlet UILabel *tenthLabel;
    IBOutlet UILabel *eleventhLabel;
    NSArray *labelArray;
    
    NSNumber *total;
}

@property (strong, nonatomic) UISwipeGestureRecognizer *gestureRecognizerRight;
@property(strong, nonatomic) UISwipeGestureRecognizer *gestureRecognizerLeft;

@property(nonatomic, retain) UIImageView *mainImageView;
@property(nonatomic, retain) UIImageView *secondImageView;
@property(nonatomic, retain) UIImageView *thirdImageView;
@property(nonatomic, retain) UIImageView *fourthImageView;
@property(nonatomic, retain) UIImageView *fifthImageView;

@property(nonatomic, retain) NSArray *viewArray;
@property(nonatomic, retain) NSIndexPath *indexPath;

@property(nonatomic, retain) NSArray *typeArray;
@property(nonatomic, retain) NSMutableArray *dataArray;
@property(nonatomic, retain) NSMutableArray *samples;
@property(nonatomic, retain) NSArray *colors;

@property(nonatomic, retain) IBOutlet UILabel *monthLabel;
@property(nonatomic, retain) NSString *leftMonthLabel;
@property(nonatomic, retain) NSString *rightMonthLabel;

@property(nonatomic, retain) CPTXYGraph *mainBarGraph;
@property(nonatomic, retain) CPTXYGraph *secondBarGraph;
@property(nonatomic, retain) CPTXYGraph *thridBarGraph;
@property(nonatomic, retain) CPTXYGraph *fourthBarGraph;
@property(nonatomic, retain) CPTXYGraph *fifthBarGraph;

@property(nonatomic, retain) NSDate *startReference;
@property(nonatomic, retain) NSDate *endReference;

@property(nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic, retain) IBOutlet UILabel *firstLabel;
@property(nonatomic, retain) IBOutlet UILabel *secondLabel;
@property(nonatomic, retain) IBOutlet UILabel *thirdLabel;
@property(nonatomic, retain) IBOutlet UILabel *fourthLabel;
@property(nonatomic, retain) IBOutlet UILabel *fifthLabel;
@property(nonatomic, retain) IBOutlet UILabel *sixthLabel;
@property(nonatomic, retain) IBOutlet UILabel *seventhLabel;
@property(nonatomic, retain) IBOutlet UILabel *eightLabel;
@property(nonatomic, retain) IBOutlet UILabel *ninthLabel;
@property(nonatomic, retain) IBOutlet UILabel *tenthLabel;
@property(nonatomic, retain) IBOutlet UILabel *eleventhLabel;
@property(nonatomic, retain) NSArray *labelArray;

@property(nonatomic, retain) IBOutlet UIImageView *pieView;

@property(nonatomic, retain) NSNumber *total;

@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
