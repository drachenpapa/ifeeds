//
//  IFFeedManager.m
//  iFeeds
//
//  Created by Henning Wrede on 17.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import "IFFeedManager.h"
#import "IFMainViewController.h"

#define FILENAME @"archive.ifeeds"
#define url_key @"feed_url"
#define name_key @"feed_name"


/*!
 * @function Singleton GCD Macro
 */
#ifndef SINGLETON_GCD
#define SINGLETON_GCD(classname)                          \
\
+ (classname *)shared##classname {                        \
\
static dispatch_once_t pred;                              \
__strong static classname * shared##classname = nil;      \
dispatch_once( &pred, ^{                                  \
shared##classname = [[super allocWithZone:nil] init]; }); \
return shared##classname;                                 \
}
#endif


@interface IFFeedManager ()

@property (nonatomic, retain) NSMutableArray *feeds;

@end



@implementation IFFeedManager

@synthesize feeds = _feeds;
@synthesize delegate = _delegate;

#pragma mark - Singleton

SINGLETON_GCD(IFFeedManager);


+ (id) allocWithZone:(NSZone *)zone {
    return [self sharedIFFeedManager];
}


- (id) init {
    NSURL *path = [self getContentPath];
    if (self = [super initWithFileURL:path]) {
        self.feeds = [[NSMutableArray alloc] init];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[path path]]) {
            [self openWithCompletionHandler:nil];
        }
        else {
            [self addFeed:[[IFFeed alloc] initWithUrlAndName: [NSURL URLWithString:@"http://rss.feedsportal.com/c/32215/f/424463/index.rss"] :@"MacTechNews"]];
            [self addFeed:[[IFFeed alloc] initWithUrlAndName: [NSURL URLWithString:@"http://www.xkcd.com/atom.xml"] :@"xkcd.com"]];
            [self saveToURL:path forSaveOperation:UIDocumentSaveForCreating completionHandler:nil];
        }
    }
    return self;
}


- (void) addFeed:(IFFeed *)feed atIndex:(NSInteger)index {
    [self.feeds insertObject:feed atIndex:index];
}


- (void) addFeed:(IFFeed *)feed {
    [self addFeed:feed atIndex:self.counter];
}


- (IFFeed *) feedAtIndex:(NSInteger)index {
    return [self.feeds objectAtIndex:index];
}


- (void) removeFeed:(IFFeed *)feed {
    [self.feeds removeObject:feed];
}


- (void) removeFeedAtIndex:(NSInteger)index {
    [self.feeds removeObjectAtIndex:index];
}


- (NSInteger) counter {
    return [self.feeds count];
}


#pragma mark - Persistence

- (NSURL *) getContentPath {
    NSURL *contentPath;
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"preferences_icloud"] && ubiq != nil) {
        contentPath = [ubiq URLByAppendingPathComponent:[NSString stringWithFormat:FILENAME]];
    } else {
        NSArray *docDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDirectory = [docDirectories objectAtIndex:0];
        contentPath = [NSURL fileURLWithPath:[docDirectory stringByAppendingPathComponent:FILENAME]];
    }
    return contentPath;
}


- (void) save {
    [self saveToURL:[self getContentPath] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
}


- (id) contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    NSMutableString* feedsToSave = [[NSMutableString alloc] init];
    if (!self.feeds) {
        feedsToSave = [NSMutableString stringWithFormat:@""];
    } else {
        for (int i = 0; i < [self.feeds count]; i++) {
            IFFeed *feed = [self.feeds objectAtIndex:i];
            if (i == [self.feeds count]-1) {
                [feedsToSave appendString:[NSString stringWithFormat:@"\\%@\\,\\%@\\", feed.name, feed.url]];
            } else {
                [feedsToSave appendString:[NSString stringWithFormat:@"\\%@\\,\\%@\\;", feed.name, feed.url]];
            }
        }
    }
    if(!feedsToSave) {
        feedsToSave = [NSMutableString stringWithFormat:@""];
    }
    NSData *docData = [feedsToSave dataUsingEncoding:NSUTF8StringEncoding];
    return docData;
}


- (BOOL) loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError {
    if ([contents length] > 0) {
        [self.feeds removeAllObjects];
        NSString* contentString = [[NSString alloc] initWithData:contents encoding:NSUTF8StringEncoding];
        NSArray* contentArray = [contentString componentsSeparatedByString:@";"];
        for (int i = 0; i < [contentArray count]; i++) {
            NSArray* contentArticles = [[contentArray objectAtIndex:i] componentsSeparatedByString:@","];
            NSString* feedname = [[contentArticles objectAtIndex:0] stringByReplacingOccurrencesOfString:@"\\" withString:@""];
            NSURL* feedurl = [NSURL URLWithString:[[contentArticles objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
            IFFeed* feed = [[IFFeed alloc] initWithUrlAndName:feedurl :feedname ];
            [self addFeed:feed];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishedLoadingData" object:nil];
    return YES;
}

@end
