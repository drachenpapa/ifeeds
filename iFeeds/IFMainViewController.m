//
//  IFFeedsViewController.m
//  iFeeds
//
//  Created by Henning Wrede on 08.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import "IFMainViewController.h"



@interface IFMainViewController ()

@end



@implementation IFMainViewController


- (void) awakeFromNib {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    self.settingsButton.title = @"\u2699";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    // RefreshControl beschreibt die Wischgeste nach unten zum Aktualisieren
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(updateFeeds) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    self.articleViewController = (IFArticleViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFeeds) name:@"finishedLoadingData" object:nil];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) addFeedButtonPressed:(IFFeed *)feed {
    // Fuegt den Feed von IFAddFeedViewController dem FeedManager und der TableView hinzu.
    [[IFFeedManager sharedIFFeedManager] addFeed:feed];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[IFFeedManager sharedIFFeedManager].counter-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

- (void) updateFeeds {
    // TODO Feeds neu laden
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}


#pragma mark - Table View

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[IFFeedManager sharedIFFeedManager] counter];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    IFFeedManager *manager = [IFFeedManager sharedIFFeedManager];
    IFFeed *feed = [manager feedAtIndex:indexPath.row];
    cell.textLabel.text = feed.name;
    cell.detailTextLabel.text = [feed.url absoluteString];
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[IFFeedManager sharedIFFeedManager] removeFeedAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    }
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    IFFeedManager *manager = [IFFeedManager sharedIFFeedManager];
    IFFeed* feed = [manager feedAtIndex:fromIndexPath.row];
    [manager removeFeedAtIndex:fromIndexPath.row];
    [[IFFeedManager sharedIFFeedManager] addFeed:feed atIndex:toIndexPath.row];
}

- (BOOL) tableView: (UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Title des "Zurueck"-Buttons setzen, anderenfalls wird dort "iFeeds" angezeigt.
    // Wird an dieser Stelle fuer eine einheitliche User Experience gesetzt.
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"button.back", nil) style: UIBarButtonItemStyleBordered target: nil action: nil];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    
    if ([[segue identifier] isEqualToString:@"showFeed"]) {
        IFFeedViewController *feedVC = (IFFeedViewController *) segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        IFFeed *selectedFeed = [[IFFeedManager sharedIFFeedManager] feedAtIndex:indexPath.row];
        feedVC.linkToFeed = selectedFeed.url;
        feedVC.title = selectedFeed.name;
    } else if ([[segue identifier] isEqualToString:@"showAddAFeed"]) {
        IFAddFeedViewController *addVC = (IFAddFeedViewController *) segue.destinationViewController;
        addVC.delegate = self;
    } else if ([[segue identifier] isEqualToString:@"showSettings"]) {
        
    }
}

@end
