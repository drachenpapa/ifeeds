//
//  IFSettingsControllerViewController.m
//  iFeeds
//
//  Created by Henning Wrede on 26.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import "IFSettingsViewController.h"

@interface IFSettingsViewController ()

@end

@implementation IFSettingsViewController

NSString *preferenceName = @"preferences_icloud";


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
    [self.iCloudPreferencesSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:preferenceName]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchedPreferences:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:self.iCloudPreferencesSwitch.isOn forKey:preferenceName];
    [defaults synchronize];
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    if (store) {
        [store setBool:self.iCloudPreferencesSwitch.isOn forKey:preferenceName];
    }
}

- (IBAction)tappedDeletePreferences:(id)sender {
    [[NSUbiquitousKeyValueStore defaultStore] removeObjectForKey:preferenceName];
}

@end
