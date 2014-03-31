

#import <MultipeerConnectivity/MultipeerConnectivity.h>

@protocol SessionControllerDelegate;

/*!
@class SessionController
@abstract
A SessionController creates the MCSession that peers will be invited/join
into, as well as creating service advertisers and browsers.

MCSessionDelegate calls occur on a private operation queue. If your app
needs to perform an action on a particular run loop or operation queue,
its delegate method should explicitly dispatch or schedule that work
*/
@interface SessionController : NSObject <MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate>

@property (nonatomic, weak) id<SessionControllerDelegate> delegate;

@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSArray *connectingPeers;
@property (nonatomic, readonly) NSArray *connectedPeers;
@property (nonatomic, readonly) NSArray *disconnectedPeers;
@property NSDictionary *discoveryInformationDictionary;

// Helper method for human readable printing of MCSessionState. This state is per peer.
- (NSString *)stringForPeerConnectionState:(MCSessionState)state;

+ (id)sharedSessionController;

- (void) startAdvertizerServices;

- (void) startBrowserServices;

- (void) invitePeerWith:(MCPeerID *)peerID;

-(void) sendMessages:(NSData *)data;

@end

// Delegate methods for SessionController
@protocol SessionControllerDelegate <NSObject>

// Session changed state - connecting, connected and disconnected peers changed
- (void)sessionDidChangeState;

@end
