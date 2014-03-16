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


-(id) copyWithZone:(NSZone *)zone {
    id copy = [[[self class] alloc] init];
    if(copy) {
        [copy setPlayerName:self.playerName];
        [copy setScore:self.score];
    }
    return copy;
}

@end
