//
//  IFGooglePlusActivity.m
//  iFeeds
//
//  Created by Henning Wrede on 27.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//


#import "IFGooglePlusActivity.h"


@interface IFGooglePlusActivity ()

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSURL    *url;

@end


@implementation IFGooglePlusActivity

// ClientID und SDK via https://developers.google.com/+/mobile/ios/getting-started
static NSString *const kClientId = @"490009637519.apps.googleusercontent.com";


-(NSString *) activityTitle {
    return @"Google+";
}

-(NSString *) activityType {
    return @"GooglePlusActivity";
}

-(UIImage *) activityImage {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return [UIImage imageNamed:@"GooglePlus_iPad.png"];
    }
    return [UIImage imageNamed:@"GooglePlus_iPhone.png"];
}

-(BOOL) canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

-(void) prepareWithActivityItems:(NSArray *)activityItems {
    // Durch alle activityItems iterieren um die benötigten Daten zu setzen.
    for (NSObject *item in activityItems) {
        if ([item isKindOfClass:[NSString class]]) {
            self.text = (NSString *) item;
        } else if ([item isKindOfClass:[NSURL class]]) {
            self.url = (NSURL *) item;
        }
    }
}

-(void) performActivity {
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,nil];
    signIn.delegate = self;
    // Authentifizierung starten. Hierfür wird "https://www.googleapis.com/auth/plus.login" (=kGTLAuthScopePlusLogin) geöffnet, damit der Nutzer der App die entsprechenden Rechte einräumen kann. Nach erfolgreichem Abschluss wird finishedWithAtuh aufgerufen.
    [signIn authenticate];
}

-(void) finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error {
    if (error == nil) {
        id <GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
        [shareBuilder setURLToShare:self.url];
        [shareBuilder setPrefillText:self.text];
        [shareBuilder open];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"gplus.errorTitle", nil)
                                                        message:NSLocalizedString(@"gplus.errorText", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"button.ok", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self activityDidFinish:YES];
}

-(void) finishedSharing:(BOOL)shared {
    
}

@end