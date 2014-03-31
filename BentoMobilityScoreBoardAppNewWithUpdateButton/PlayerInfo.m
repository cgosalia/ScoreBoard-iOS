//
//  PlayerInfo.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/10/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "PlayerInfo.h"

@implementation PlayerInfo

@synthesize playerName;

@synthesize score;

@synthesize playerImg;

-(id) copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if(copy) {
        [copy setPlayerName:self.playerName];
        [copy setScore:self.score];
        [copy setPlayerImg:self.playerImg];
    }
    return copy;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:playerName forKey:@"name"];
    [coder encodeInt:score forKey:@"score"];
    [coder encodeObject:playerImg forKey:@"image"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        playerName = [coder decodeObjectForKey:@"name"];
        score = [coder decodeIntegerForKey:@"score"];
        playerImg = [coder decodeObjectForKey:@"image"];
    }
    return self;
}
@end
