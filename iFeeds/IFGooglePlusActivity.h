//
//  IFGooglePlusActivity.h
//  iFeeds
//
//  Created by Henning Wrede on 27.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <GooglePlus/GPPSignIn.h>
#import <GooglePlus/GPPShare.h>
#import <GoogleOpenSource/GTLPlusConstants.h>


@interface IFGooglePlusActivity : UIActivity <GPPSignInDelegate, GPPShareDelegate>

@end
