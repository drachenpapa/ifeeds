//
//  IFFeed.m
//  iFeeds
//
//  Created by Henning Wrede on 11.07.13.
//  Copyright (c) 2013 Henning Wrede. All rights reserved.
//

#import "IFFeed.h"

#define url_key @"feed_url"
#define name_key @"feed_name"


@implementation IFFeed


- (id) initWithUrl:(NSURL *)url {
    self = [super init];
    self.url = url;
    return self;
}

- (id) initWithUrlAndName:(NSURL *)url :(NSString *)name {
    self = [super init];
    self.url = url;
    self.name = name;
    return self;
}

@end
