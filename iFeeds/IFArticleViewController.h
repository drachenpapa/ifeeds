//
//  IFArticleViewController.h
//  iFeeds
//
//  Created by Henning Wrede on 15.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IFArticleViewController : UIViewController <UISplitViewControllerDelegate>

@property (assign, nonatomic)          BOOL             switchedToBrowser;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *openWithButton;
- (IBAction)openWithButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *switchButton;
- (IBAction)switchPerspectives:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView       *webView;
@property (copy  , nonatomic)          NSString        *articleTitle;
@property (copy  , nonatomic)          NSString        *content;
@property (copy  , nonatomic)          NSURL           *url;

@end
