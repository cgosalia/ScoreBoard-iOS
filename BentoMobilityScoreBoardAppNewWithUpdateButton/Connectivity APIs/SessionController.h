//
//  SessionController.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/28/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <MultipeerConnectivity/MultipeerConnectivity.h>

@protocol SessionControllerDelegate;

/*!
@class SessionController
@abstract
A SessionController creates the MCSession that peers will be invited/join
into, as well as creating service advertisers and browsers.

MCSessionDelegate calls occur on a private operation queue. If app
needs to perform an action on a particular run loop or operation queue,
its delegate method should explicitly dispatch or schedule that work.
*/

@interface SessionController : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, weak) id<SessionControllerDelegate> delegate;

@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSArray *connectingPeers;
@property (nonatomic, readonly) NSArray *connectedPeers;
@property (nonatomic, readonly) NSArray *disconnectedPeers;
@property NSDictionary *discoveryInformationDictionary;
@property (retain) NSMutableDictionary *peerIDToGameMap;

// Helper method for human readable printing of MCSessionState. This state is per peer.
- (NSString *)stringForPeerConnectionState:(MCSessionState)state;

// Get singleton of the session controller shared across the app.
+ (id)sharedSessionController;

// Initialize and advertize services
- (void) startAdvertizerServices;

// Initialize and browse for services
- (void) startBrowserServices;

// Delegated.  Invite peer to connect
- (void) invitePeerWith:(MCPeerID *)peerID;

// Delegated.  Send data as 'message'.
-(void) sendMessages:(NSData *)data;

-(void) teardownSession;

@end

// Delegate methods for SessionController
@protocol SessionControllerDelegate <NSObject>

// Session changed state - connecting, connected and disconnected peers changed
- (void)sessionDidChangeState;

@end
