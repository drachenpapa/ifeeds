//
//  IFArticlesViewController.h
//  iFeeds
//
//  Created by Henning Wrede on 08.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFArticleViewController.h"


@class IFArticleViewController;


@interface IFFeedViewController : UITableViewController <NSXMLParserDelegate>

@property (strong, nonatomic)          IFArticleViewController *articleViewController;
@property (copy  , nonatomic)          NSURL                   *linkToFeed;
@property (strong, nonatomic) IBOutlet UIBarButtonItem         *toolbarLabel;
@property (strong, nonatomic) IBOutlet UITableView             *tableView;

- (void) viewDidLoad;

@end
