//
//  PlayerDictionary.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/30/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "PlayerDictionary.h"

@implementation PlayerDictionary

@synthesize playerDictionary;

-(instancetype) init {
    self = [super init];
    if(self) {
        playerDictionary = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:playerDictionary forKey:@"playerDict"];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        playerDictionary = [coder decodeObjectForKey:@"playerDict"];
    }
    return self;
}

- (void)add:(NSString *)key value:(NSData *)data {
    [playerDictionary setObject:data forKey:key];
}

- (NSData *)getDataFor:(NSString *)key {
    return [playerDictionary objectForKey:key];
}

- (NSMutableDictionary *) getDictionary {
    return playerDictionary;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}


@end
