//
//  IFAddFeedViewController.h
//  iFeeds
//
//  Created by Henning Wrede on 08.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFFeed.h"


@protocol IFFeedAddedProtocol <NSObject>
-(void) addFeedButtonPressed:(IFFeed *)feed;
@end


@interface IFAddFeedViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton        *addFeedButton;
- (IBAction)addFeedButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField     *tf_feedname;
@property (strong, nonatomic) IBOutlet UITextField     *tf_feedurl;
@property (weak  , nonatomic) id <IFFeedAddedProtocol>  delegate;

- (IBAction)hideKeyboardWhenReturn:(id)sender;
- (IBAction)hideKeyboardWhenBackgroundTapped:(id)sender;

@end
