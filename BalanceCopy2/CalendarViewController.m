//
//  CalendarViewController.m
//  BalanceCopy2
//
//  Created by Alexander Arias on 1/29/13.
//  Copyright (c) 2013 Gables Engineering. All rights reserved.
//

#import "CalendarViewController.h"
#import "EventKitDataSource.h"
//#import "kal.h"

#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>


@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
 //   kal = [[KalViewController alloc] init];
    
   // kal.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)];
   // kal.delegate = self;
  //  dataSource = [[EventKitDataSource alloc] init];
  //  kal.dataSource = dataSource;
    
    
    navController = [[UINavigationController alloc] initWithRootViewController:kal];
    [self.view addSubview:navController.view];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    
    [self showAndSelectToday];
    
}

-(void)showAndSelectToday   {
    
  //  [kal showAndSelectDate:[NSDate date]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
