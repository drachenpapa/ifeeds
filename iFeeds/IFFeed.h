//
//  IFFeed.h
//  iFeeds
//
//  Created by Henning Wrede on 11.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFArticle.h"


@interface IFFeed : NSObject

@property (nonatomic, retain) NSMutableArray *articles;
@property (nonatomic, strong) NSString       *name;
@property (nonatomic, copy  ) NSURL          *url;
@property (nonatomic, strong) NSDate         *pubDate;
@property (nonatomic, strong) NSDate         *lastBuildDate;

-(id)initWithUrl:(NSURL *)url;
-(id)initWithUrlAndName:(NSURL *)url :(NSString *)name;

@end
