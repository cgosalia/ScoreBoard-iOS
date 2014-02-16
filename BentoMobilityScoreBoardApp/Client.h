//
//  Client.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/16/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Client;

@protocol ClientDelegate <NSObject>

- (void)toClient:(Client *)client serverBecameAvailable:(NSString *)peerID;

- (void)toClient:(Client *)client serverBecameUnavailable:(NSString *)peerID;

@end


@interface Client : NSObject <GKSessionDelegate>

@property (nonatomic, strong, readonly) NSArray *availableServers;

@property (nonatomic, strong, readonly) GKSession *session;

@property (nonatomic, weak) id <ClientDelegate> delegate;

- (NSUInteger)availableServerCount;

- (NSString *)peerIDForAvailableServerAtIndex:(NSUInteger)index;

- (NSString *)displayNameForPeerID:(NSString *)peerID;

- (void)startSearchingForServersWithSessionID:(NSString *)sessionID;

@end
