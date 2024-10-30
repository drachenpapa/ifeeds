//
//  IFArticle.h
//  iFeeds
//
//  Created by Henning Wrede on 11.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface IFArticle : NSObject

@property (nonatomic, assign) BOOL      read;
@property (nonatomic, strong) NSString *articleID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSURL    *url;
@property (nonatomic, strong) NSDate   *pubDate;
@property (nonatomic, strong) NSString *content;

@end
