//
//  DiscoveryInfo.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/31/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "DiscoveryInfo.h"

@implementation DiscoveryInfo

@synthesize discoveryInfoDictionary;


+ (id) getInstance {
    static DiscoveryInfo *sharedDiscoveryInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDiscoveryInfo = [[self alloc] init];
    });
    return sharedDiscoveryInfo;
}

-(instancetype) init {
    self = [super init];
    if(self) {
        discoveryInfoDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void) setDiscoveryInfoWithKey:(NSString *)key andValue:(NSString *)value {
    [discoveryInfoDictionary setObject:value forKey:key];
}

-(NSDictionary *)getDiscoveryInfo {
    return discoveryInfoDictionary;
}

@end
