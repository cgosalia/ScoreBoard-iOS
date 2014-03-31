//
//  Message.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/30/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "Message.h"
#import "PlayerInfo.h"
#import "PlayerDictionary.h"
#import "SessionController.h"

@implementation Message

+ (void) send:(NSMutableArray *)data {
    NSData *archivedPlayerInfo;
    NSInteger count = [data count];
    PlayerDictionary *playerInfoDictionary = [[PlayerDictionary alloc] init];
    PlayerInfo* player;
    for (int i = 0;i<count; i++) {
        player=[data objectAtIndex:i];
        archivedPlayerInfo = [NSKeyedArchiver archivedDataWithRootObject:player];
        NSString *key = [NSString stringWithFormat:@"%d",i];
        [playerInfoDictionary add:key value:archivedPlayerInfo];
    }
    NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:playerInfoDictionary];
    SessionController *sessionController = [SessionController sharedSessionController];
    [sessionController sendMessages:messageData];
}

@end
