//
//  IFAddFeedViewController.m
//  iFeeds
//
//  Created by Henning Wrede on 08.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import "IFAddFeedViewController.h"



@interface IFAddFeedViewController ()

@end



@implementation IFAddFeedViewController


- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL) isInputValid {
    if (self.tf_feedurl.text.length > 0 && self.tf_feedname.text.length > 0) {
        return YES;
    }
    return NO;
}

- (IBAction) addFeedButtonPressed:(id)sender {
    if ([self isInputValid]) {
        IFFeed *feed = [[IFFeed alloc] initWithUrlAndName:[NSURL URLWithString:self.tf_feedurl.text] :self.tf_feedname.text];
        [self.delegate addFeedButtonPressed:feed];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"addFeedAlert.title", nil)
                                                          message:NSLocalizedString(@"addFeedAlert.msg", nil)
                                                         delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"button.ok", nil)
                                                otherButtonTitles:nil];
        [message show];
    }
}


#pragma mark - Hiding the keyboard

- (IBAction) hideKeyboardWhenReturn:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction) hideKeyboardWhenBackgroundTapped:(id)sender {
    [self.tf_feedname resignFirstResponder];
    [self.tf_feedurl resignFirstResponder];
}

@end
