//
//  TransactionDetailViewController.m
//  BalanceCopy2
//
//  Created by Robert Miller on 8/17/12.
//  Copyright (c) 2012 Gables Engineering. All rights reserved.
//

#import "TransactionDetailViewController.h"
#import "NewTransactionView.h"

@interface TransactionDetailViewController ()

@end

@implementation TransactionDetailViewController
@synthesize dateLabel, nameLabel, typeLabel, withdrawalLabel, amountLabel, detailTransaction;

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
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
	// Do any additional setup after loading the view.
    nameLabel.text = [detailTransaction transactionName];
    typeLabel.text = [detailTransaction transactionType];
    amountLabel.text = [[detailTransaction transactionAmount] stringValue];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    dateLabel.text = [dateFormatter stringFromDate:[detailTransaction timeStamp]];
    if([[detailTransaction withdrawal] boolValue])  {
        withdrawalLabel.text = @"Withdrawal";
    }
    else    {
        withdrawalLabel.text = @"Deposit";
    }
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(loadEditButton)];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NewTransactionView *editView = [segue destinationViewController];
    editView.transaction = detailTransaction;
}

-(void)loadEditButton   {
    [self performSegueWithIdentifier:@"detailToEdit" sender:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
