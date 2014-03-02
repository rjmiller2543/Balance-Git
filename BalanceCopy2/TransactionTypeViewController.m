//
//  TransactionTypeViewController.m
//  BalanceCopy2
//
//  Created by Robert Miller on 8/12/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "TransactionTypeViewController.h"

@interface TransactionTypeViewController ()

@end

@implementation TransactionTypeViewController
@synthesize currType,pickerView,typeChoices;

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
    self.view.backgroundColor = [UIColor clearColor];
    typeChoices = [[NSArray alloc] initWithObjects:@"",@"Car Payment",@"Credit Card",@"Deposit",@"Dining Out",@"Gas",@"Grocery",@"Insurance",@"Loan",@"Mortgage",@"Other",@"Paycheck",@"Student Loan",@"Utility", nil];
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
    return typeChoices.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSLog(@"RoastPickerView: titleForRow");
    return [typeChoices objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"RoastPickerView pickerView: didSelectRow");
    currType = [typeChoices objectAtIndex:row];
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
    NSLog(@"RoastPickerView doneButton");
    [[self delegate] TransactionTypeViewController:self didSelectType:currType];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    
    //[self.view setFrame:CGRectMake(0, 2000, self.view.frame.size.width, self.view.frame.size.height)];
    self.view.transform = CGAffineTransformMakeTranslation(0, 1000);
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeTheView) withObject:nil afterDelay:0.75];
    //[self dismissModalViewControllerAnimated:YES];
}

@end
