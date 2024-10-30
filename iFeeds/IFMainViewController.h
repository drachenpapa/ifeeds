//
//  IFFeedsViewController.h
//  iFeeds
//
//  Created by Henning Wrede on 08.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFFeedManager.h"
#import "IFAddFeedViewController.h"
#import "IFFeedViewController.h"

@class IFArticleViewController;


@interface IFMainViewController : UITableViewController <IFFeedAddedProtocol>

@property (strong, nonatomic) IBOutlet UIBarButtonItem         *addButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem         *settingsButton;
@property (strong, nonatomic)          IFArticleViewController *articleViewController;

@end
