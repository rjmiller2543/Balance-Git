//
//  TransactionDateViewController.m
//  BalanceCopy2
//
//  Created by Robert Miller on 8/12/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "TransactionDateViewController.h"

@interface TransactionDateViewController ()

@end

@implementation TransactionDateViewController
@synthesize datePicker,saveDate;

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
    self.view.backgroundColor = [UIColor clearColor];
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
    [[self delegate] TransactionDateViewController:self didSelectDate:[datePicker date]];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    
    //[self.view setFrame:CGRectMake(0, 2000, self.view.frame.size.width, self.view.frame.size.height)];
    self.view.transform = CGAffineTransformMakeTranslation(0, 1000);
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeTheView) withObject:nil afterDelay:0.75];
    //[self dismissModalViewControllerAnimated:YES];
}


@end
