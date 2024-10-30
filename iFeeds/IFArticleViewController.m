//
//  IFArticleViewController.m
//  iFeeds
//
//  Created by Henning Wrede on 15.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import "IFArticleViewController.h"
#import "IFGooglePlusActivity.h"


@interface IFArticleViewController ()

@property (strong, nonatomic) UIPopoverController *popoverCont;

@end



@implementation IFArticleViewController

@synthesize webView;


- (void) awakeFromNib {
    [super awakeFromNib];
    self.splitViewController.delegate = self;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    // Den Content des Artikels anzeigen lassen
    [self resetView];
}

- (void) resetView {
    // Zuruecksetzen der Werte fuer den Wechsel zwischen Artikeln wenn als Device ein iPad verwendet wird
    self.switchedToBrowser = NO;
    webView.scalesPageToFit = NO;
    // Content des Artikels laden
    [webView loadHTMLString:self.content baseURL:self.url];
    if (self.popoverCont != nil) {
        [self.popoverCont dismissPopoverAnimated:YES];
    }
}

- (IBAction) openWithButtonPressed:(id)sender {
    // Den zu teilenden Text modifizieren
    NSString *shareText = [NSString stringWithFormat:@"\"%@\" via iFeeds", self.articleTitle];
    NSArray *activityItems = [NSArray arrayWithObjects:shareText, self.url, nil];
    // Google Plus hinzufügen
    IFGooglePlusActivity *googlePlus = [[IFGooglePlusActivity alloc] init];
    // UIActivityViewController mit dem zu teilenden Text erstellen.
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[googlePlus]];
    // Nicht gewuenschte Dienste ausblenden
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    // Festlegen der Menue-Animation
    activityVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    // Menue anzeigen
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (IBAction) switchPerspectives:(id)sender {
    // Umschalten zwischen den Zoom-Eigenschaften.
    // Wenn der Content dargestellt wird, wird die Seite entsprechend gezoomt. Bei einer URL wird die komplette Website gezeigt und nicht direkt reingezoomt. Bei einigen Websites wird sonst ein Teil des Inhalts weggeschnitten.
    // Muss vor dem Laden des Inhalts geschehen!
    webView.scalesPageToFit = !webView.scalesPageToFit;
    if (self.switchedToBrowser){
        // Den Inhalt des Artikels anzeigen lassen
        [webView loadHTMLString:_content baseURL:self.url];
    } else {
        // Die URL des Artikels anzeigen lassen
        [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    }
    self.switchedToBrowser = !self.switchedToBrowser;
}


#pragma mark - Setter

- (void) setContent: (NSString *)content {
    if (self.content != content) {
        _content = content;
        [self resetView];
    }
}

- (void) setUrl: (NSURL *)url {
    if (self.url != url) {
        _url = url;
        [self resetView];
    }
}


#pragma mark - SplitViewController

- (void) splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = NSLocalizedString(@"ifeeds", @"title");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.popoverCont = popoverController;
}

- (void) splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.popoverCont = nil;
}

@end
