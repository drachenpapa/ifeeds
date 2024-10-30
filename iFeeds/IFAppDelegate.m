//
//  IFAppDelegate.m
//  iFeeds
//
//  Created by Henning Wrede on 08.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import "IFAppDelegate.h"
#import "IFFeedManager.h"
#import <GooglePlus/GPPURLHandler.h>

@implementation IFAppDelegate

NSString *KVStoreiCloudPreferences = @"preferences_icloud";

@synthesize window = _window;


-(void) showiCloudEnableAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"icloud.questionAlert", nil)
                                                    message:NSLocalizedString(@"icloud.questionAlertView", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"button.disable", nil)
                                          otherButtonTitles:NSLocalizedString(@"button.enable", nil), nil];
    [alert show];
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    BOOL enableIcloud;
    if (buttonIndex == 1) {
        enableIcloud = YES;
    } else {
        enableIcloud = NO;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:enableIcloud forKey:KVStoreiCloudPreferences];
    [defaults synchronize];
    
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    if (store) {
        [store setBool:enableIcloud forKey:KVStoreiCloudPreferences];
    }
}


- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
    if (store) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateKVStoreItems:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:store];
        [store synchronize];
    }
    // Ist dies der aller erste Programmaufruf, so dass es weder lokal noch in iCloud vorhandene Einstellungen gibt?
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KVStoreiCloudPreferences] == nil && [store objectForKey:KVStoreiCloudPreferences] == nil) {
        // Einen AlertView anzeigen, über den die Einstellungen angepasst werden
        [self showiCloudEnableAlert];
    }
    // Override point for customization after application launch.
    return YES;
}


- (BOOL)application: (UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}


- (void)updateKVStoreItems:(NSNotification*)notification {
    // Funktion von Apple (http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/UserDefaults/StoringPreferenceDatainiCloud/StoringPreferenceDatainiCloud.html#//apple_ref/doc/uid/10000059i-CH7-SW7)
    // Get the list of keys that changed.
    NSDictionary* userInfo = [notification userInfo];
    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSInteger reason = -1;
    
    // If a reason could not be determined, do not update anything.
    if (!reasonForChange)
        return;
    
    // Update only for changes from the server.
    reason = [reasonForChange integerValue];
    if ((reason == NSUbiquitousKeyValueStoreServerChange) ||
        (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
        // If something is changing externally, get the changes
        // and update the corresponding keys locally.
        NSArray* changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
        // This loop assumes you are using the same key names in both
        // the user defaults database and the iCloud key-value store
        for (NSString* key in changedKeys) {
            id value = [store objectForKey:key];
            [userDefaults setObject:value forKey:key];
        }
    }
}

- (void) applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
    [[IFFeedManager sharedIFFeedManager] save];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) applicationWillTerminate:(UIApplication *)application {
    [[IFFeedManager sharedIFFeedManager] save];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
