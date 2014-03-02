//
//  MonthlyOverviewView.m
//  BalanceCopy2
//
//  Created by Robert Miller on 7/9/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "MonthlyOverviewView.h"
#import "QuartzCore/CALayer.h"
#import "AppDelegate.h"

#define X_VAL @"X_VAL"
#define Y_VAL @"Y_VAL"

/////////
//NOTES//
/////////
// 1) Need to figure out how to draw the plot
// 2) Need to setup the data model
// xxx3) Fix bug in animation  
// xxx4) Add shadow to the UIImageView
// 5) Add a shade or haze over the UIImageViews in background   (NEVERMIND???)
//To draw the plot, add a function that will draw the whole plot and other functions that will draw each bar
//for the plot.  Need to figure out how to come up with a percent and start the draw rect from that percentage
//since adding the subview starts from the top.  Therefore, the starting point will be the rounded pixel that
//of the PEAK of the bar
/////////////
//END NOTES//
/////////////


@implementation MonthlyOverviewView
@synthesize gestureRecognizerRight,gestureRecognizerLeft;
@synthesize mainImageView,secondImageView,thirdImageView,fourthImageView,fifthImageView,viewArray,monthLabel;
@synthesize indexPath;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize dataArray, typeArray, colors;
@synthesize mainBarGraph,secondBarGraph,thridBarGraph,fourthBarGraph,fifthBarGraph;
@synthesize samples;
@synthesize startReference,endReference;
@synthesize leftMonthLabel, rightMonthLabel;
@synthesize scrollView;
@synthesize pieView;
@synthesize fifthLabel,firstLabel,secondLabel,thirdLabel,fourthLabel,sixthLabel,seventhLabel,eightLabel,ninthLabel,tenthLabel,eleventhLabel,labelArray;
@synthesize total;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.view.layer removeAllAnimations];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidDisappear:(BOOL)animated  {
    
    NSLog(@"view did disappear");
    [self.mainImageView removeFromSuperview];
    [self.secondImageView removeFromSuperview];
    [self.thirdImageView removeFromSuperview];
    [self.fourthImageView removeFromSuperview];
    [self. fifthImageView removeFromSuperview];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //[self setupPlots];
    [self configureView];
    //NSUInteger uindex[] = {0,0};
    //NSIndexPath *tempIndexPath = [[NSIndexPath alloc] initWithIndexes:uindex length:2];
    //NSLog(@"car payment is: %@",[[self.fetchedResultsController objectAtIndexPath:tempIndexPath] carPayments]);
    //NSLog(@"num obj:%u",[[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects]);
}

-(void)configureView    {
    
    
    AppDelegate *dataCenter = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = dataCenter.managedObjectContext;
    //self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 226, 320, 579)];
    self.scrollView.contentSize = CGSizeMake(320, 900);
    self.scrollView.scrollEnabled = YES;
    //[self.view addSubview:scrollView];
    labelArray = [[NSArray alloc] initWithObjects:firstLabel,secondLabel,thirdLabel,fourthLabel,fifthLabel,sixthLabel,seventhLabel,eightLabel,ninthLabel,tenthLabel,eleventhLabel, nil];
    
    self.colors = [[NSArray alloc] initWithObjects:[CPTColor redColor], [CPTColor blueColor], [CPTColor greenColor], [CPTColor purpleColor], [CPTColor orangeColor], [CPTColor yellowColor], [CPTColor grayColor], [CPTColor brownColor], [CPTColor darkGrayColor], [CPTColor magentaColor], [CPTColor lightGrayColor], nil];
    
    //Add the gestures for the images to swipe left and right
    gestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
    [gestureRecognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:self.gestureRecognizerRight];
    gestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
    [gestureRecognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:self.gestureRecognizerLeft];
    
    self.typeArray = [[NSArray alloc] initWithObjects:@"carPayments", @"creditCards", @"Dining Out", @"gas", @"grocery", @"insurance", @"loan", @"mortgage", @"other", @"studentLoan", @"utilities", nil];
    //self.dataArray = [[NSMutableArray alloc] initWithCapacity:[self.typeArray count]];
    //[self performSelectorInBackground:@selector(loadDataArray) withObject:nil];
    //NSUInteger uindex[] = {0,0};
    //NSIndexPath *tempIndexPath = [[NSIndexPath alloc] initWithIndexes:uindex length:2];
    //NSLog(@"credit card is: %@",[[self.fetchedResultsController objectAtIndexPath:tempIndexPath] creditCards]);
    
    self.pieView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.pieView.layer.shadowOffset = CGSizeMake(-10, 10);
    self.pieView.layer.shadowOpacity = 1;
    self.pieView.layer.shadowRadius = 5.0;
    self.pieView.clipsToBounds = NO;
    
    
    CGRect frame1 = CGRectMake(-10, 90, 90, 80);
    self.secondImageView = [[UIImageView alloc] initWithFrame:frame1];
    //[self.secondImageView setImage:[UIImage imageNamed:@"secondImage.png"]];
    self.secondImageView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.view addSubview:self.secondImageView];
    //[self.view addSubview:secondImageView];
    secondImageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    secondImageView.layer.shadowOffset = CGSizeMake(-10, 10);
    secondImageView.layer.shadowOpacity = 1;
    secondImageView.layer.shadowRadius = 5.0;
    secondImageView.clipsToBounds = NO;
    
    CGRect frame2 = CGRectMake(260, 90, 90, 80);
    self.thirdImageView = [[UIImageView alloc] initWithFrame:frame2];
    //[self.thirdImageView setImage:[UIImage imageNamed:@"secondImage.png"]];
    self.thirdImageView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.view addSubview:self.thirdImageView];
    [self.view addSubview:thirdImageView];
    thirdImageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    thirdImageView.layer.shadowOffset = CGSizeMake(-10, 10);
    thirdImageView.layer.shadowOpacity = 1;
    thirdImageView.layer.shadowRadius = 5.0;
    thirdImageView.clipsToBounds = NO;
    
    CGRect frame3 = CGRectMake(-70, 100, 90, 80);
    self.fourthImageView = [[UIImageView alloc] initWithFrame:frame3];
    //[self.fourthImageView setImage:[UIImage imageNamed:@"secondImage.png"]];
    self.fourthImageView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.view addSubview:self.fourthImageView];
    //[self.view addSubview:fourthImageView];
    self.fourthImageView.alpha = 0.0;
    fourthImageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    fourthImageView.layer.shadowOffset = CGSizeMake(-10, 10);
    fourthImageView.layer.shadowOpacity = 1;
    fourthImageView.layer.shadowRadius = 5.0;
    fourthImageView.clipsToBounds = NO;
    
    CGRect frame4 = CGRectMake(320, 120, 90, 80);
    self.fifthImageView = [[UIImageView alloc] initWithFrame:frame4];
    //[self.fifthImageView setImage:[UIImage imageNamed:@"secondImage.png"]];
    self.fifthImageView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.view addSubview:self.fifthImageView];
    //[self.view addSubview:fifthImageView];
    self.fifthImageView.alpha = 0.0;
    fifthImageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    fifthImageView.layer.shadowOffset = CGSizeMake(-10, 10);
    fifthImageView.layer.shadowOpacity = 1;
    fifthImageView.layer.shadowRadius = 5.0;
    fifthImageView.clipsToBounds = NO;
    
    //Create the frames for the image views
    CGRect frame0 = CGRectMake(70, 20, 180, 160);
    self.mainImageView = [[UIImageView alloc] initWithFrame:frame0];
    [self.view addSubview:self.mainImageView];
    //[self.view addSubview:mainImageView];
    //[self.mainImageView setImage:[UIImage imageNamed:@"secondImage.png"]];
    self.mainImageView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    //Adding Shadow
    mainImageView.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    mainImageView.layer.shadowOffset = CGSizeMake(-10, 10);
    mainImageView.layer.shadowOpacity = 1;
    mainImageView.layer.shadowRadius = 5.0;
    mainImageView.clipsToBounds = NO;
    
    //Add the image views into an array as to be able to control the animation for each image view as they move
    viewArray = [[NSArray alloc] initWithObjects:self.mainImageView, self.secondImageView, self.thirdImageView, self.fourthImageView, self.fifthImageView, nil];
    
    [self setupPlots];
    //Setting up a few MonthOverviews for the sake of testing the plotting functions and reloading images
    
    //[self.mainImageView removeFromSuperview];
    //[self.secondImageView removeFromSuperview];
    //[self.thirdImageView removeFromSuperview];
    //[self.fourthImageView removeFromSuperview];
    //[self.fifthImageView removeFromSuperview];
    //[self setupPlots];
    //NSDateComponents *components = [[NSDateComponents alloc] init];
    //components.month = -1;
    //NSDate *referenceDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    //NSLog(@"referenceDate:%@",[referenceDate description]);
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Plotting Methods

-(void) generateDataSamples
{
	int rawSamples [] = {1,2,3,2,1};
	int numSamples = sizeof(rawSamples) / sizeof(int);
	
	samples = [[NSMutableArray alloc] initWithCapacity:numSamples];
	
	for (int i = 0; i < numSamples; i++){
		double x = i/5;
		double y = rawSamples[i];
		NSDictionary *sample = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithDouble:x],X_VAL,
								[NSNumber numberWithDouble:y],Y_VAL,
								nil];
		[samples addObject:sample];
	}
}

-(void)setupPlots   {
    [self.gestureRecognizerLeft setEnabled:NO];
    [self clearLabels];
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *secondDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ && endDate > %@",secondDate, secondDate];
    NSPredicate *accountNamePredicate = [NSPredicate predicateWithFormat:@"accountName == %@",[dataCenter.dataCenterAccount accountName]];
    
    NSLog(@"start: %@, end: %@", secondDate, secondDate);
    
    NSArray *predicates = @[predicate, accountNamePredicate];
    NSPredicate *usedPredicates = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    [self.fetchedResultsController.fetchRequest setPredicate:usedPredicates];
    
    NSError *error = nil;

    [self.fetchedResultsController performFetch:&error];
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        [self.gestureRecognizerRight setEnabled:NO];
    }
    else    {
        MonthOverview *secondMonth = (MonthOverview*)[[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
        //graph = [[CPTXYGraph alloc] initWithFrame:secondImageView.bounds];
        [self loadDataArrayForMonth:secondMonth];
        mainBarGraph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 180, 160)];
        [self setupPlot:mainBarGraph ForView:secondImageView];
        [self.gestureRecognizerRight setEnabled:YES];
        self.leftMonthLabel = [secondMonth monthString];
      //  NSLog(@"Something");
    }
    
    predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ && endDate > %@",[NSDate date], [NSDate date]];
    predicates = @[predicate, accountNamePredicate];
    usedPredicates = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    [self.fetchedResultsController.fetchRequest setPredicate:usedPredicates];
    error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        
    }
    if([[self.fetchedResultsController fetchedObjects] count] == 0) {
        
        //do nothing and return no plots
        
    }
    else    {
        
        MonthOverview *month = (MonthOverview*)[[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
        NSLog(@"month is: %@",[month monthString]);
        //CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:mainImageView.bounds];
        [self loadDataArrayForMonth:month];
        mainBarGraph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 180, 160)];
        [self setupPlot:mainBarGraph ForView:mainImageView];
        [self setUpPieChartForMonth:month];
        self.monthLabel.text = [month monthString];
        
    }
    
    /*
    NSDate *thirdDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:secondDate options:0];
    predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ && endDate > %@",thirdDate, thirdDate];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self.fetchedResultsController performFetch:&error];
    if ([[self.fetchedResultsController fetchedObjects] count] == 0) {
        
    }
    else    {
        month = (MonthOverview*)[[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
        [self loadDataArrayForMonth:month];
        [self setupPlot:thirdBarGraph ForView:fourthImageView];
        [self.gestureRecognizerRight setEnabled:YES];
    }
     */
    self.startReference = secondDate;
    components.month = 1;
    self.endReference = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    //return 11;
    //return [samples count];
    return [dataArray count];
    //return 3;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index    {
    NSDictionary *data = [dataArray objectAtIndex:index];
    //NSDictionary *sample = [samples objectAtIndex:index];
    NSLog(@"data value is: %@",[data valueForKey:Y_VAL]);
    if(fieldEnum == CPTScatterPlotFieldX)   {
        //return [data valueForKey:X_VAL];
        //return [sample valueForKey:X_VAL];
        return [data valueForKey:Y_VAL];
    }
    else if(fieldEnum == CPTPieChartFieldSliceWidth) {
        NSLog(@"in slice width");
        return [NSNumber numberWithInteger:2];
    }
    else    {
        //NSLog(@"data value: %@",[data valueForKey:Y_VAL]);
        return [NSNumber numberWithInteger:[[data valueForKey:Y_VAL] integerValue]];
        //return [sample valueForKey:Y_VAL];
    }
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
	//CPTTextLayer *label			   = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%u", index]];
	//CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
    
	//textStyle.color = [CPTColor lightGrayColor];
	//label.textStyle = textStyle;
	//return label;
    //return [typeArray objectAtIndex:index];
    return nil;
}

-(CGFloat)radialOffsetForPieChart:(CPTPieChart *)piePlot recordIndex:(NSUInteger)index
{
	CGFloat offset = 0.0;
    
	if ( index == 0 ) {
		//offset = piePlot.pieRadius / 8.0;
	}
    
	return offset;
}

-(CPTFill*)barFillForBarPlot:(CPTBarPlot*)barPlot recordIndex:(NSUInteger)index  {
    return [CPTFill fillWithColor:(CPTColor*)[colors objectAtIndex:index]];
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index    {
    return [CPTFill fillWithColor:(CPTColor*)[colors objectAtIndex:index]];
}


-(void)setupPlot:(CPTXYGraph*)graph ForView:(UIImageView*)imageView   {
    //[self generateDataSamples];
    //graph = [[CPTXYGraph alloc] initWithFrame:mainImageView.bounds];
    graph.paddingBottom = 10.0;
    graph.plotAreaFrame.paddingBottom = 10.0;
    graph.plotAreaFrame.paddingLeft = 40.0;
    graph.plotAreaFrame.paddingTop = 10.0;
    
    double xAxisStart = 0;
	double xAxisLength = [dataArray count];
	
	double yAxisStart = 0;
	double yAxisLength = [[dataArray valueForKeyPath:@"@max.Y_VAL"] doubleValue];
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
	plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(xAxisStart)
                                                    length:CPTDecimalFromDouble(xAxisLength+1)];
	
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(yAxisStart)
                                                    length:CPTDecimalFromDouble(yAxisLength+1)];
    CPTXYAxisSet *axisSet = (CPTXYAxisSet*)graph.axisSet;
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.fontName = @"Helvetica";
    textStyle.fontSize = 8;
    textStyle.color = [CPTColor blackColor];
    axisSet.xAxis.titleTextStyle = textStyle;
    axisSet.xAxis.titleOffset = .2;
        
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(roundf([[dataArray valueForKeyPath:@"@max.Y_VAL"] floatValue])/5);
	
	CPTBarPlot *plot = [[CPTBarPlot alloc] initWithFrame:CGRectZero];
    //CPTBarPlot *plot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor grayColor] horizontalBars:NO];
	plot.plotRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromDouble(0.0)
                                                  length:CPTDecimalFromDouble(xAxisLength)];
    
    
	plot.barOffset = CPTDecimalFromDouble(0.5);
	plot.dataSource = self;
    
    [graph addPlot:plot];

    imageView.image = graph.imageOfLayer;
    
    graph = nil;
}

-(void)setUpPieChartForMonth:(MonthOverview*)month    {
    CPTXYGraph *pieChart = [[CPTXYGraph alloc] initWithFrame:pieView.bounds];
    pieChart.axisSet = nil;
    
    CPTPieChart *piePlot = [[CPTPieChart alloc] init];
    piePlot.dataSource = self;
    piePlot.pieRadius = 50.0;
    piePlot.startAngle = 0;
    piePlot.sliceDirection = CPTPieDirectionClockwise;
    piePlot.delegate = self;
    [pieChart addPlot:piePlot];
    pieView.image = pieChart.imageOfLayer;
}

-(void)loadDataArrayForMonth:(MonthOverview*)month    {
    NSDictionary *data;
    NSNumber *x;
    NSNumber *y;
    float totalFloat = 0;
    self.dataArray = [[NSMutableArray alloc] init];
    NSLog(@"load data for month: %@",[month monthString]);
    NSLog(@"count for data array:%u",[dataArray count]);
    NSUInteger index = 0;
    
    x = [NSNumber numberWithDouble:0];
    y = [month carPayments];
    NSLog(@"y is: %@",y);
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Car Payments";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
        NSLog(@"added object, what's the count: %u",[dataArray count]);
    }
    
    
    x = [NSNumber numberWithDouble:1];
    y = [month creditCards];
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Credit Cards";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
    }

    x = [NSNumber numberWithDouble:2];
    y = [month food];
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Dining Out";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
    }

    x = [NSNumber numberWithDouble:3];
    y = [month gas];
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Gas";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
    }

    x = [NSNumber numberWithDouble:4];
    y = [month grocery];
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Grocery";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
    }

    x = [NSNumber numberWithDouble:5];
    y = [month insurance];
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Insurance";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
    }

    x = [NSNumber numberWithDouble:6];
    y = [month loan];
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Loans";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
    }

    x = [NSNumber numberWithDouble:7];
    y = [month mortgage];
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Mortgage";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
    }

    x = [NSNumber numberWithDouble:8];
    y = [month other];
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Other";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
    }

    x = [NSNumber numberWithDouble:9];
    y = [month studentLoan];
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Student Loans";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
    }

    x = [NSNumber numberWithDouble:10];
    y = [month utilities];
    if([y floatValue] != 0)  {
        data = [NSDictionary dictionaryWithObjectsAndKeys:x, X_VAL, y, Y_VAL, nil];
        [dataArray addObject:data];
        UILabel *tempLabel = (UILabel*)[labelArray objectAtIndex:index];
        tempLabel.text = @"Utilities";
        index++;
        totalFloat += [x floatValue];
        self.scrollView.contentSize = CGSizeMake(320, (540+index*35));
    }
    
}

-(void)clearLabels  {
    self.firstLabel.text = nil;
    self.secondLabel.text = nil;
    self.thirdLabel.text = nil;
    self.fourthLabel.text = nil;
    self.fifthLabel.text = nil;
    self.sixthLabel.text = nil;
    self.seventhLabel.text = nil;
    self.eightLabel.text = nil;
    self.ninthLabel.text = nil;
    self.tenthLabel.text = nil;
    self.eleventhLabel.text = nil;
}

#pragma mark - Gesture Methods

///////////////////////////////////////////////////
//This Section is to handle the swipe gestures   //
//and move the images from left to right or from //
//right to left using animation for translation  //
//and scaling.                                   //
///////////////////////////////////////////////////

-(void)imageAnimationsLeft:(NSArray *)imageArray  {
    
    [self.gestureRecognizerRight setEnabled:YES];
    self.leftMonthLabel = self.monthLabel.text;
    self.monthLabel.text = rightMonthLabel;
    self.scrollView.contentSize = CGSizeMake(320, 560);
    [self clearLabels];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.5, 0.5);
    CGAffineTransform transform = CGAffineTransformTranslate(scaleTransform, -250, 60);
    UIImageView *tempView0 = [imageArray objectAtIndex:0];
    tempView0.transform = transform;
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.75];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    CGAffineTransform transform1 = CGAffineTransformMakeTranslation(270, 0);
    UIImageView *tempView1 = [imageArray objectAtIndex:1];
    tempView1.transform = transform1;
    tempView1.alpha = 0.0;
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.75];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    CGAffineTransform scaleTransform2 = CGAffineTransformMakeScale(2, 2);
    CGAffineTransform transform2 = CGAffineTransformTranslate(scaleTransform2, -73, -15);
    UIImageView *tempView2 = [imageArray objectAtIndex:2];
    tempView2.transform = transform2;
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.75];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    CGAffineTransform transform4 = CGAffineTransformMakeTranslation(-100, -100);
    UIImageView *tempView4 = [imageArray objectAtIndex:4];
    tempView4.transform = transform4;
    tempView4.alpha = 1.0;
    
    //[UIView commitAnimations];
    
    CGRect frame0 = CGRectMake(-10, 90, 90, 80);
    [tempView0 setFrame:frame0];
    
    //CGRect frame1 = CGRectMake(260, 90, 90, 80);
    //[tempView1 setFrame:frame1];
    
    CGRect frame1 = CGRectMake(-70, 100, 90, 80);
    [tempView1 setFrame:frame1];
    
    
    
    CGRect frame3 = CGRectMake(320, 120, 90, 80);
    [[imageArray objectAtIndex:3] setFrame:frame3];
    
    CGRect frame4 = CGRectMake(260, 90, 90, 80);
    [tempView4 setFrame:frame4];
    
    CGRect frame2 = CGRectMake(70, 20, 180, 160);
    [tempView2 setFrame:frame2];
    
    [UIView commitAnimations];
    
    UIImageView *tempView3 = [imageArray objectAtIndex:3];
    tempView3.image = nil;
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = 1;
    NSDate *tempEndReference = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:endReference options:0];
    endReference = tempEndReference;
    
    NSDate *tempStartReference = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:startReference options:0];
    startReference = tempStartReference;
    NSLog(@"start: %@, end: %@",startReference, endReference);
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ && endDate > %@",endReference, endReference];
    NSPredicate *accountNamePredicate = [NSPredicate predicateWithFormat:@"accountName == %@",dataCenter.accountName];
    NSArray *predicates = @[predicate, accountNamePredicate];
    NSPredicate *usedPredicates = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    [self.fetchedResultsController.fetchRequest setPredicate:usedPredicates];
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if([[self.fetchedResultsController fetchedObjects] count] == 0) {
        //[self.gestureRecognizerRight setEnabled:YES];
        //[self.gestureRecognizerLeft setEnabled:NO];
        //tempView3.image = nil;
    }
    else    {
        MonthOverview *month = (MonthOverview*)[[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
        NSLog(@"swipe left month is: %@",[month monthString]);
        [self loadDataArrayForMonth:month];
        //CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:tempView4.bounds];
        mainBarGraph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 180, 160)];
        [self setupPlot:mainBarGraph ForView:tempView4];
        self.rightMonthLabel = [month monthString];
    }
    
    if(tempView4.image == nil)  {
        //[self.gestureRecognizerRight setEnabled:YES];
        [self.gestureRecognizerLeft setEnabled:NO];
    }
    
    predicate = [NSPredicate predicateWithFormat:@"monthString == %@ && accountName == %@",self.monthLabel.text, dataCenter.dataCenterAccount.accountName];
    //predicates = @[predicate, accountNamePredicate];
    //usedPredicates = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    //[self.fetchedResultsController.fetchRequest setPredicate:usedPredicates];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    
    error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    MonthOverview *month = (MonthOverview*)[[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    NSLog(@"swipe right month is: %@",[month monthString]);
    [self loadDataArrayForMonth:month];
    [self setUpPieChartForMonth:month];
}

-(IBAction)swipeLeft    {
    NSLog(@"Swipe Left");
    [self imageAnimationsLeft:self.viewArray];
     
    NSArray *tempArray = [[NSArray alloc] initWithObjects:[self.viewArray objectAtIndex:2], [self.viewArray objectAtIndex:0], [self.viewArray objectAtIndex:4], [self.viewArray objectAtIndex:1], [self.viewArray objectAtIndex:3] ,nil];
    self.viewArray = tempArray;
}

-(void)imageAnimationsRight:(NSArray *)imageArray    {
    
    [self.gestureRecognizerLeft setEnabled:YES];
    self.rightMonthLabel = self.monthLabel.text;
    self.monthLabel.text = self.leftMonthLabel;
    self.scrollView.contentSize = CGSizeMake(320, 560);
    [self clearLabels];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.5, 0.5);
    CGAffineTransform transform = CGAffineTransformTranslate(scaleTransform, 290, 60);
    UIImageView *tempView0 = [imageArray objectAtIndex:0];
    tempView0.transform = transform;
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.75];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    CGAffineTransform scaleTransform1 = CGAffineTransformMakeScale(2, 2);
    CGAffineTransform transform1 = CGAffineTransformTranslate(scaleTransform1, 63, -15);
    UIImageView *tempView1 = [imageArray objectAtIndex:1];
    tempView1.transform = transform1;
    
    //This works, commenting out to try to do a fade
    /*
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    CGAffineTransform transform2 = CGAffineTransformMakeTranslation(-270, 0);
    UIImageView *tempView2 = [imageArray objectAtIndex:2];
    tempView2.transform = transform2;
    */
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.75];
    CGAffineTransform transform2 = CGAffineTransformMakeTranslation(50,50);
    UIImageView *tempView2 = [imageArray objectAtIndex:2];
    tempView2.alpha = 0.0;
    tempView2.transform = transform2;
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationDuration:0.75];
    //[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    CGAffineTransform transform3 = CGAffineTransformMakeTranslation(300, -100);
    UIImageView *tempView3 = [imageArray objectAtIndex:3];
    tempView3.transform = transform3;
    tempView3.alpha = 1.0;
    
    //[UIView commitAnimations];
    
    CGRect frame0 = CGRectMake(260, 90, 90, 80);
    [tempView0 setFrame:frame0];
    
    
    /*
    CGRect frame2 = CGRectMake(-10, 90, 90, 80);
    [tempView2 setFrame:frame2];
    */
    CGRect frame2 = CGRectMake(320, 120, 45,40);
    [tempView2 setFrame:frame2];
    
    CGRect frame3 = CGRectMake(-10, 90, 90, 80);
    [tempView3 setFrame:frame3];
    
    CGRect frame4 = CGRectMake(-70, 100, 90, 80);
    [[imageArray objectAtIndex:4] setFrame:frame4];
    
    CGRect frame1 = CGRectMake(70, 20, 180, 160);
    [tempView1 setFrame:frame1];
    
    [UIView commitAnimations];
    
    UIImageView *tempView4 = [imageArray objectAtIndex:4];
    tempView4.image = nil;
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = -1;
    NSDate *tempStartReference = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:startReference options:0];
    startReference = tempStartReference;
    
    NSDate *tempEndReference = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:endReference options:0];
    endReference = tempEndReference;
    NSLog(@"start: %@, end: %@",startReference, endReference);
    
    AppDelegate *dataCenter = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ && endDate > %@",startReference, startReference];
    NSPredicate *accountNamePredicate = [NSPredicate predicateWithFormat:@"accountName == %@",dataCenter.accountName];
    NSArray *predicates = @[predicate, accountNamePredicate];
    NSPredicate *usedPredicates = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    [self.fetchedResultsController.fetchRequest setPredicate:usedPredicates];
    
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    NSLog(@"number of fetched objects: %i", [[self.fetchedResultsController fetchedObjects] count]);
    if([[self.fetchedResultsController fetchedObjects] count] == 0) {
        //[self.gestureRecognizerRight setEnabled:NO];
        //[self.gestureRecognizerLeft setEnabled:YES];
        //tempView4.image = nil;
    }
    else    {
        NSLog(@"Thinks there are items in the array");
        MonthOverview *month = (MonthOverview*)[[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
        NSLog(@"swipe right month is: %@",[month monthString]);
        [self loadDataArrayForMonth:month];
        //CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:tempView3.bounds];
        mainBarGraph = [[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 0, 180, 160)];
        [self setupPlot:mainBarGraph ForView:tempView3];
        self.leftMonthLabel = [month monthString];
    }
    
    if(tempView3.image == nil)  {
        [self.gestureRecognizerRight setEnabled:NO];
        //[self.gestureRecognizerLeft setEnabled:YES];
    }

    NSLog(@"monthlabel: %@", self.monthLabel.text);
    predicate = [NSPredicate predicateWithFormat:@"monthString == %@ && accountName == %@",self.monthLabel.text, dataCenter.dataCenterAccount.accountName];
    ///predicates = @[predicate, accountNamePredicate];
    //usedPredicates = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
    
    //[self.fetchedResultsController.fetchRequest setPredicate:usedPredicates];
    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    //self.scrollView.contentSize = CGSizeMake(320, 580);
    //[self clearLabels];
    
    error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    NSLog(@"count of objects: %i", [[self.fetchedResultsController fetchedObjects] count]);
    
    MonthOverview *month = (MonthOverview*)[[self.fetchedResultsController fetchedObjects] objectAtIndex:0];
    NSLog(@"swipe right month is: %@",[month monthString]);
    [self loadDataArrayForMonth:month];
    [self setUpPieChartForMonth:month];
    
}

-(IBAction)swipeRight   {
    NSLog(@"Swipe Right");
    
    [self imageAnimationsRight:self.viewArray];
    
    NSArray *tempArray = [[NSArray alloc] initWithObjects:[self.viewArray objectAtIndex:1], [self.viewArray objectAtIndex:3], [self.viewArray objectAtIndex:0], [self.viewArray objectAtIndex:4], [self.viewArray objectAtIndex:2], nil];
    self.viewArray = tempArray;
    

}

#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MonthOverview" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"monthString" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    /*
	     Replace this implementation with code to handle the error appropriately.
         
	     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	     */
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return __fetchedResultsController;
}  

@end
