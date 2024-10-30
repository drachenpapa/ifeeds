//
//  IFSettingsViewController.h
//  iFeeds
//
//  Created by Henning Wrede on 26.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IFSettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *deletePreferencesButton;
- (IBAction)tappedDeletePreferences:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *iCloudPreferencesSwitch;
- (IBAction)switchedPreferences:(id)sender;

@end
