//
//  Server.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/16/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"

@class Server;

@protocol ServerDelegate <NSObject>

- (void)toServer:(Server *)server clientDidConnect:(NSString *)peerID;

- (void)toServer:(Server *)server clientDidDisconnect:(NSString *)peerID;

@end

@interface Server : NSObject <GKSessionDelegate>

@property (nonatomic, assign) int maxClients;
@property (nonatomic, strong, readonly) NSArray *connectedClients;
@property (nonatomic, strong, readonly) GKSession *session;
@property (nonatomic, weak) id <ServerDelegate> delegate;

- (void)startAcceptingConnectionsForSessionID:(NSString *)sessionID;

- (NSUInteger)connectedClientCount;

- (NSString *)peerIDForConnectedClientAtIndex:(NSUInteger)index;

- (NSString *)displayNameForPeerID:(NSString *)peerID;

@end
