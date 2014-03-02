//
//  QuickviewViewController.m
//  BalanceCopy2
//
//  Created by Robert Miller on 8/12/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "QuickviewViewController.h"
#import "AppDelegate.h"

@interface QuickviewViewController ()

@end

@implementation QuickviewViewController
@synthesize balanceLabel, accountNameLabel;
@synthesize swipeLeft, swipeRight;
@synthesize backgroundViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"quick view controller init with nib name");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"Quick View Controller View did load");
    
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showBackground)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeRight setEnabled:YES];
    
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideBackground)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeLeft setEnabled:NO];
    
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    AppDelegate *dataCenter = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"lastCheck: %@",dataCenter.dataCenterAccount.lastPaycheck);
    
}

- (void)viewDidUnload
{
    
    NSLog(@"qv view did unload");
    
    [super viewDidUnload];
    
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"Quick View Controller View did Appear");
    
    [self configureView];
    //[self addQuickViewBackground];
    
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    NSLog(@"view will disappear");
    [self hideBackground];
    
}

-(void)configureView    {
    
    //Create the Data Center
    AppDelegate *dataCenter = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"balance is: %@",dataCenter.appBalance);
    NSLog(@"lastpay: %@, lastdep: %@", dataCenter.lastPaycheck, dataCenter.lastDeposit);
    
    //Set the App title to the Current Account Name
    self.title = dataCenter.accountName;
    
    //Configure the Balance Label for Format and Color
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    self.balanceLabel.text = [numberFormatter stringFromNumber:dataCenter.appBalance];
    
    if ([dataCenter.appBalance floatValue] <= 0)    {
        NSString *useThis = @"-";
        self.balanceLabel.text = [useThis stringByAppendingString:[numberFormatter stringFromNumber:dataCenter.appBalance]];
        self.balanceLabel.textColor = [UIColor redColor];
    }
    else if([dataCenter.appBalance floatValue] < 100) {
        self.balanceLabel.textColor = [UIColor yellowColor];
    }
    else    {
        self.balanceLabel.textColor = [UIColor greenColor];
    }
    
    //Configure the Progress Bar
    float progress = 1 - [dataCenter.appBalance floatValue]/([dataCenter.lastPaycheck floatValue] + [dataCenter.lastDeposit floatValue]);
    NSLog(@"Progress: %f",progress);
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 145, 280, 9)];
    progressView.progressViewStyle = UIProgressViewStyleDefault;
    progressView.progress = progress;
    if (progress > 0.8) {
        progressView.progressTintColor = [UIColor redColor];
    }
    [self.view addSubview:progressView];
    
    //Set The Label for the Account Name
    self.accountNameLabel.text = [dataCenter.dataCenterAccount accountName];
    
}

-(void)addQuickViewBackground   {
    
    //self.backgroundViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"qvBgController"];
    //[self.navigationController.view.superview addSubview:backgroundViewController.view];
    //[self.navigationController.view.superview sendSubviewToBack:backgroundViewController.view];
    //backgroundViewController.view.alpha = 0.75;
    
    self.backgroundViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"qvBgController"];
    [self.view.superview addSubview:self.backgroundViewController.view];
    [self.view.superview sendSubviewToBack:self.backgroundViewController.view];
    
}

-(void)removeQuickViewBackground    {
    
    [self.backgroundViewController.view removeFromSuperview];
    [self.backgroundViewController removeFromParentViewController];
    
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(IBAction)newTransaction:(id)sender    {
    [self performSegueWithIdentifier:@"quickToNew" sender:self];
}


-(void)showBackground   {
    
    NSLog(@"Swipe Right");
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    //backgroundViewController.view.alpha = 0.75;
    [UIView commitAnimations];
    
    CGRect destination = self.view.frame;
    
    
    destination.origin.x = 280;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = destination;
        
    } completion:^(BOOL finished) {
        
        //self.view.userInteractionEnabled = !(destination.origin.x > 0);
        self.view.userInteractionEnabled = YES;
        
    }];
    
    [self addQuickViewBackground];
    
    [swipeRight setEnabled:NO];
    [swipeLeft setEnabled:YES];
    
}

-(void)hideBackground    {
    
    CGRect destination = self.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    backgroundViewController.view.alpha = 0;
    [UIView commitAnimations];
    
    destination.origin.x = 0;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.frame = destination;
        
    } completion:^(BOOL finished) {
        
        self.view.userInteractionEnabled = !(destination.origin.x > 0);
        
    }];
    
    [self configureView];
    
    [swipeRight setEnabled:YES];
    [swipeLeft setEnabled:NO];
    
}

@end
