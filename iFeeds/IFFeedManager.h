//
//  IFFeedManager.h
//  iFeeds
//
//  Created by Henning Wrede on 17.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFFeed.h"


@protocol IFFeedManagerDelegate;


@interface IFFeedManager : UIDocument

+(IFFeedManager *) sharedIFFeedManager;

@property (nonatomic, weak    ) id<IFFeedManagerDelegate> delegate;
@property (nonatomic, readonly) NSInteger                 counter;

-(void) addFeed: (IFFeed *)feed;
-(void) addFeed: (IFFeed *)feed atIndex: (NSInteger)index;
-(IFFeed *) feedAtIndex: (NSInteger)index;
-(void) removeFeed: (IFFeed *)feed;
-(void) removeFeedAtIndex: (NSInteger)index;
-(void) save;

@end
