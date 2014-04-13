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

/* Send player info object as data.  Method archives player-info objects and collects in a dictionary which
 in turn is archived before sending.  The collection and the player-info are ns coding compliant.
 */
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

+ (void) sendOneCell:(PlayerInfo *)playerInfoCell  forIndex:(NSInteger *)index withMessageType:(NSString *)msgType{
    PlayerInfo *sendablePlayerInfo = [[PlayerInfo alloc] init];
    if (![msgType isEqualToString:@"image"] && ![msgType isEqualToString:@"add"]) {
        sendablePlayerInfo.playerName = playerInfoCell.playerName;
        sendablePlayerInfo.score = playerInfoCell.score;
        sendablePlayerInfo.isBeingEdited = playerInfoCell.isBeingEdited;
    } else {
        sendablePlayerInfo.playerName = playerInfoCell.playerName;
        sendablePlayerInfo.score = playerInfoCell.score;
        sendablePlayerInfo.isBeingEdited = playerInfoCell.isBeingEdited;
        sendablePlayerInfo.playerImg = playerInfoCell.playerImg;
    }
    NSData *archivedPlayerInfo = [NSKeyedArchiver archivedDataWithRootObject:sendablePlayerInfo];
    PlayerDictionary *playerInfoDictionary = [[PlayerDictionary alloc] init];
    [playerInfoDictionary add:@"player-info" value:archivedPlayerInfo];
    [playerInfoDictionary add:@"index" value:[NSKeyedArchiver archivedDataWithRootObject:[NSString stringWithFormat:@"%d",index]]];
    [playerInfoDictionary add:@"msg-type" value:[NSKeyedArchiver archivedDataWithRootObject:msgType]];
    NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:playerInfoDictionary];
    SessionController *sessionController = [SessionController sharedSessionController];
    [sessionController sendMessages:messageData];
}

@end
