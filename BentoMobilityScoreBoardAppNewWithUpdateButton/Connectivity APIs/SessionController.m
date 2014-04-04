//
//  SessionController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/28/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "SessionController.h"
#import "PlayerDictionary.h"
#import "DiscoveryInfo.h"

@interface SessionController () // Class extension
@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic, strong) MCNearbyServiceBrowser *serviceBrowser;

// Connected peers are stored in the MCSession
// Manually track connecting and disconnected peers
@property (nonatomic, strong) NSMutableOrderedSet *connectingPeersOrderedSet;
@property (nonatomic, strong) NSMutableOrderedSet *disconnectedPeersOrderedSet;
@end

@implementation SessionController

static NSString * const sessionServiceType = @"bmsbmcsession";

NSArray *ArrayInvitationHandler;

BOOL accepted;

DiscoveryInfo *discoveryInfo;

#pragma mark - Initializer


+ (id)sharedSessionController {
    static SessionController *sharedSessionController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSessionController = [[self alloc] init];
    });
    return sharedSessionController;
}

- (instancetype) init
{
    self = [super init];
    
    if (self)
    {
        _peerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        
        _connectingPeersOrderedSet = [[NSMutableOrderedSet alloc] init];
        _disconnectedPeersOrderedSet = [[NSMutableOrderedSet alloc] init];
        
        //                NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        //
        //                // Register for notifications
        //                [defaultCenter addObserver:self
        //                                  selector:@selector(startServices)
        //                                      name:UIApplicationWillEnterForegroundNotification
        //                                    object:nil];
        //
        //                [defaultCenter addObserver:self
        //                                  selector:@selector(stopServices)
        //                                      name:UIApplicationDidEnterBackgroundNotification
        //                                    object:nil];
        //
        //        [self startServices];
        
        
        _connectedPeers = self.session.connectedPeers;
        _connectingPeers = [self.connectingPeersOrderedSet array];
        _disconnectedPeers = [self.disconnectedPeersOrderedSet array];
        
        _displayName = self.session.myPeerID.displayName;
        _peerIDToGameMap = [[NSMutableDictionary alloc] init];
        [self setupSession];
    }
    
    return self;
}

#pragma mark - Memory management

- (void)dealloc
{
    // Unregister for notifications on deallocation.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Nil out delegates
    _session.delegate = nil;
    _serviceAdvertiser.delegate = nil;
    _serviceBrowser.delegate = nil;
}

#pragma mark - Private methods

- (void)setupSession
{
    // Create the session that peers will be invited/join into.
    _session = [[MCSession alloc] initWithPeer:self.peerID];
    self.session.delegate = self;
}


- (void)teardownSession
{
    [self.session disconnect];
    [self.connectingPeersOrderedSet removeAllObjects];
    [self.disconnectedPeersOrderedSet removeAllObjects];
}

- (void)startServices
{
    [self setupSession];
    [self.serviceAdvertiser startAdvertisingPeer];
    [self.serviceBrowser startBrowsingForPeers];
}

- (void) startBrowserServices
{
    // Create the service browser
    _serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peerID
                                                       serviceType:sessionServiceType];
    self.serviceBrowser.delegate = self;
    [self.serviceBrowser startBrowsingForPeers];
}

- (void) startAdvertizerServices {
    discoveryInfo = [DiscoveryInfo getInstance];
    // Create the service advertiser
    _serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peerID
                                                           discoveryInfo:[discoveryInfo getDiscoveryInfo]
                                                             serviceType:sessionServiceType];
    self.serviceAdvertiser.delegate = self;

    [self.serviceAdvertiser startAdvertisingPeer];
}


- (void)stopServices
{
    [self.serviceBrowser stopBrowsingForPeers];
    [self.serviceAdvertiser stopAdvertisingPeer];
    [self teardownSession];
}

- (void)updateDelegate
{
    _connectedPeers = self.session.connectedPeers;
    _connectingPeers = [self.connectingPeersOrderedSet array];
    _disconnectedPeers = [self.disconnectedPeersOrderedSet array];
    
    [self.delegate sessionDidChangeState];
}

- (NSString *)stringForPeerConnectionState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected:
            return @"Connected";
            
        case MCSessionStateConnecting:
            return @"Connecting";
            
        case MCSessionStateNotConnected:
            return @"Not Connected";
    }
}

-(void) sendMessages:(NSData *)data {
    NSArray *peerIDs = [_session connectedPeers];
    NSError *error = nil;
    [_session sendData:data
               toPeers:peerIDs
              withMode:MCSessionSendDataReliable
                 error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

#pragma mark - MCSessionDelegate protocol conformance

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);
    
    switch (state)
    {
        case MCSessionStateConnecting:
        {
            [self.connectingPeersOrderedSet addObject:peerID];
            [self.disconnectedPeersOrderedSet removeObject:peerID];
            break;
        }
            
        case MCSessionStateConnected:
        {
            [self.connectingPeersOrderedSet removeObject:peerID];
            [self.disconnectedPeersOrderedSet removeObject:peerID];
            if(accepted) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NewPeerJoined"
                                                                    object:nil
                                                                  userInfo:nil];
                accepted = false;
            }
//            discoveryInfo = [DiscoveryInfo getInstance];
//            [discoveryInfo setDiscoveryInfoWithKey:@"gamename" andValue:@"Demo"];
            [self startAdvertizerServices];
//            NSLog(@"in connected: %@", [discoveryInfo getDiscoveryInfo]);
            break;
        }
            
        case MCSessionStateNotConnected:
        {
            [self.connectingPeersOrderedSet removeObject:peerID];
            [self.disconnectedPeersOrderedSet addObject:peerID];
            break;
        }
    }
    
    [self updateDelegate];
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    // Decode the incoming data to a UTF8 encoded string
    //NSString *receivedMessage = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MCDidReceiveDataNotification"
                                                        object:nil
                                                      userInfo:[obj getDictionary]];
    // NSLog(@"didReceiveData %@ from %@", receivedMessage, peerID.displayName);
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"didStartReceivingResourceWithName [%@] from %@ with progress [%@]", resourceName, peerID.displayName, progress);
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSLog(@"didFinishReceivingResourceWithName [%@] from %@", resourceName, peerID.displayName);
    
    // If error is not nil something went wrong
    if (error)
    {
        NSLog(@"Error [%@] receiving resource from %@ ", [error localizedDescription], peerID.displayName);
    }
    else
    {
        // No error so this is a completed transfer.  The resources is located in a temporary location and should be copied to a permenant location immediately.
        // Write to documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *copyPath = [NSString stringWithFormat:@"%@/%@", [paths firstObject], resourceName];
        if (![[NSFileManager defaultManager] copyItemAtPath:[localURL path] toPath:copyPath error:nil])
        {
            NSLog(@"Error copying resource to documents directory");
        }
        else
        {
            // Get a URL for the path we just copied the resource to
            NSURL *url = [NSURL fileURLWithPath:copyPath];
            NSLog(@"url = %@", url);
        }
    }
}

// Streaming API not utilized in this sample code
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"didReceiveStream %@ from %@", streamName, peerID.displayName);
}


- (void) session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL accept))certificateHandler
{
    certificateHandler(YES);
}

-(void) mapPeerID:(MCPeerID *) peerID toGameName:(NSString *)gameName {
    [_peerIDToGameMap setObject:gameName forKey:peerID];
    NSLog(@"");
}

#pragma mark - MCNearbyServiceBrowserDelegate protocol conformance

// Found a nearby advertising peer
- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSString *remotePeerName = peerID.displayName;
    
    NSLog(@"Browser found %@", remotePeerName);
    
    MCPeerID *myPeerID = self.session.myPeerID;
    
    [self.disconnectedPeersOrderedSet addObject:peerID];
    self.discoveryInformationDictionary = info;
    [self mapPeerID:peerID toGameName:[info objectForKey:@"gamename"]];
    discoveryInfo = [DiscoveryInfo getInstance];
    [discoveryInfo setDiscoveryInfoWithKey:@"gamename" andValue:[info objectForKey:@"gamename"]];
    [self updateDelegate];
}

- (void) invitePeerWith:(MCPeerID *)peerID {
    [self.connectingPeersOrderedSet addObject:peerID];
    [self.disconnectedPeersOrderedSet removeObject:peerID];
    [self updateDelegate];
    [_serviceBrowser invitePeer:peerID toSession:self.session withContext:nil timeout:300000.0];
}


- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"lostPeer %@", peerID.displayName);
    
    [self.connectingPeersOrderedSet removeObject:peerID];
    [self.disconnectedPeersOrderedSet addObject:peerID];
    
    [self updateDelegate];
}

- (void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"didNotStartBrowsingForPeers: %@", error);
}

#pragma mark - MCNearbyServiceAdvertiserDelegate protocol conformance

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    NSLog(@"didReceiveInvitationFromPeer %@", peerID.displayName);
    NSString *msg = [NSString stringWithFormat:@"Do you like to accept the invitation from %@?",peerID.displayName];
    ArrayInvitationHandler = [NSArray arrayWithObject:[invitationHandler copy]];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Incoming request"
                              message:msg
                              delegate:self
                              cancelButtonTitle:@"Decline"
                              otherButtonTitles:@"Accept", nil];
    [alertView show];
    [self updateDelegate];
    
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"didNotStartAdvertisingForPeers: %@", error);
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // retrieve the invitationHandler
    // get user decision
    BOOL accept = (buttonIndex != alertView.cancelButtonIndex) ? YES : NO;
    
    void (^invitationHandler)(BOOL, MCSession *) = [ArrayInvitationHandler objectAtIndex:0];
    // respond
    
    invitationHandler(accept, self.session);
    
    if(accept) {
        accepted = true;
    } else {
        accepted = false;
    }
}


@end
