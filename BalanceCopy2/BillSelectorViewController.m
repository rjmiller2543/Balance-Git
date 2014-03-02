//
//  BillSelectorViewController.m
//  BalanceCopy2
//
//  Created by Robert Miller on 8/13/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "BillSelectorViewController.h"
#import "AppDelegate.h"
#import "Bill.h"
#import "MonthlyBill.h"

@interface BillSelectorViewController ()

@end

@implementation BillSelectorViewController
@synthesize pickerView, index, billChoices;

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
	// Do any additional setup after loading the view.
    MonthlyBill *forLoadingArray = [self.storyboard instantiateViewControllerWithIdentifier:@"monthlyBill"];
    [forLoadingArray.view setHidden:YES];
    [self.view addSubview:forLoadingArray.view];
    [[self.view.subviews objectAtIndex:2] removeFromSuperview];
    
    self.view.backgroundColor = [UIColor clearColor];
    AppDelegate *dataCenter = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    billChoices = dataCenter.billArray;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - data source methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSLog(@"RoastPickerView numberOfComponentsInPickerView");
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSLog(@"RoastPickerView pickerView: numberOfRowInComponent");
    return billChoices.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSLog(@"RoastPickerView: titleForRow");
    AppDelegate *dataCenter = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    Bill *tempBill = (Bill*)[dataCenter.billArray objectAtIndex:row];
    return [tempBill currentBill];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"RoastPickerView pickerView: didSelectRow");
    index = [NSNumber numberWithInteger:row];
}

#pragma mark - Removing the View

-(void)removeTheView    {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

-(IBAction)cancelButton {
    NSLog(@"RoastPickerView cancelButton");
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    
    //[self.view setFrame:CGRectMake(0, 2000, self.view.frame.size.width, self.view.frame.size.height)];
    self.view.transform = CGAffineTransformMakeTranslation(0, 1000);
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeTheView) withObject:nil afterDelay:0.75];
    //[self.view removeFromSuperview];
    //[self removeFromParentViewController];
    //[self dismissModalViewControllerAnimated:YES];
    
}

-(IBAction)doneButton   {
    NSLog(@"%@",index);
    [[self delegate] BillSelectorViewController:self didSelectIndex:[index integerValue]];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    
    //[self.view setFrame:CGRectMake(0, 2000, self.view.frame.size.width, self.view.frame.size.height)];
    self.view.transform = CGAffineTransformMakeTranslation(0, 1000);
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeTheView) withObject:nil afterDelay:0.75];
    //[self dismissModalViewControllerAnimated:YES];
}

@end
