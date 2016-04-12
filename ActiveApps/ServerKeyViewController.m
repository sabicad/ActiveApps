//
//  ViewController.m
//  ActiveApps
//
//  Created by Yuriy Holovatskyi on 12/01/15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "ServerKeyViewController.h"
#import "ServicesViewController.h"

static NSString *const servicesSeque = @"servicesSeque";

@interface ServerKeyViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *serverKeyTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *serverKeyTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

#pragma mark - Lifecycle

@implementation ServerKeyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nextButton.enabled = NO;
    self.serverKeyTextField.delegate = self;
    self.serverKeyTextField.layer.cornerRadius = 15.0f;
    
    if ([[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]allKeys]containsObject:kServerKey]) {
        self.serverKeyTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:kServerKey];
        [self nextButtonAction:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.serverKeyTextField.text.length > 0) {
        self.nextButton.enabled = YES;
    }
}

#pragma mark - Actions

- (IBAction)nextButtonAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:self.serverKeyTextField.text forKey:kServerKey];
    [self performSegueWithIdentifier:servicesSeque sender:self];
}

- (IBAction)serverKeyChanged:(id)sender
{
    if (self.serverKeyTextField.text.length > 0) {
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.enabled = NO;
    }
}

#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:servicesSeque]) {
//        ServicesViewController *vc = segue.destinationViewController;
        
        [RestManager sharedManager].serverKey = self.serverKeyTextField.text;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.serverKeyTextField.text.length > 0) {
        [self nextButtonAction:self];
    }
    
    [self.view endEditing:YES];
    
    return YES;
}

@end
