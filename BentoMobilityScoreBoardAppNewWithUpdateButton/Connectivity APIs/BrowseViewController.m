//
//  BrowseViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/28/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "BrowseViewController.h"

@interface BrowseViewController () // Class extension
@property (nonatomic, strong) SessionController *sessionController;
@end

@implementation BrowseViewController

NSMutableOrderedSet *connectingGamesNameSet;
NSMutableOrderedSet *connectedGamesNameSet;
NSMutableOrderedSet *disconnectedGamesNameSet;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //_sessionController = [[SessionController alloc] init];
    _sessionController = [SessionController sharedSessionController];
    self.sessionController.delegate = self;
    [self.sessionController startBrowserServices];
    connectingGamesNameSet = [[NSMutableOrderedSet alloc] init];
    connectedGamesNameSet = [[NSMutableOrderedSet alloc] init];
    disconnectedGamesNameSet = [[NSMutableOrderedSet alloc] init];
    [self sessionDidChangeState];
    self.title = [NSString stringWithFormat:@"Browse"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else
    {
        return YES;
    }
}

#pragma mark - Memory management

- (void)dealloc
{
    // Nil out delegate
    _sessionController.delegate = nil;
}

#pragma mark - SessionControllerDelegate protocol conformance

- (void)sessionDidChangeState
{
    [connectingGamesNameSet removeAllObjects];
    [connectedGamesNameSet removeAllObjects];
    [disconnectedGamesNameSet removeAllObjects];
    MCPeerID *peerToLookUp;
    NSString *gameNameString;
    NSArray *connectingPeers = self.sessionController.connectingPeers;
    for(int i=0; i<connectingPeers.count; i++) {
        peerToLookUp = [connectingPeers objectAtIndex:i];
        gameNameString = [self.sessionController.peerIDToGameMap objectForKey:peerToLookUp];
        if (gameNameString != nil) {
            [connectingGamesNameSet addObject:gameNameString];
        }
        
    }
    
    NSArray *connectedPeers = self.sessionController.connectedPeers;
    for(int i=0; i<connectedPeers.count; i++) {
        peerToLookUp = [connectedPeers objectAtIndex:i];
        gameNameString = [self.sessionController.peerIDToGameMap objectForKey:peerToLookUp];
        if (gameNameString != nil) {
            [connectedGamesNameSet addObject:gameNameString];
        }

    }
    
    NSArray *disconnectedPeers = self.sessionController.disconnectedPeers;
    for(int i=0; i<disconnectedPeers.count; i++) {
        peerToLookUp = [disconnectedPeers objectAtIndex:i];
        gameNameString = [self.sessionController.peerIDToGameMap objectForKey:peerToLookUp];
        if (gameNameString != nil) {
            if(![connectedGamesNameSet containsObject:gameNameString]) {
                [disconnectedGamesNameSet addObject:gameNameString];
            }
            
        }
    }
    
    
    // Ensure UI updates occur on the main queue.
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - UITableViewDataSource protocol conformance

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // We have 3 sections in our grouped table view,
    // one for each MCSessionState
	return 3;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;

    // Each tableView section represents an MCSessionState
    MCSessionState sessionState = section;
    
    switch (sessionState)
    {
        case MCSessionStateConnecting:
        {
            rows = connectingGamesNameSet.count;
            break;
        }
            
        case MCSessionStateConnected:
        {
            rows = connectedGamesNameSet.count;
            break;
        }
            
        case MCSessionStateNotConnected:
        {
            rows = disconnectedGamesNameSet.count;
            break;
        }
    }
    
    // Always show at least 1 row for each MCSessionState.
    if (rows < 1)
    {
        rows = 1;
    }
    
	return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Each tableView section represents an MCSessionState
    MCSessionState sessionState = section;
    
    return [self.sessionController stringForPeerConnectionState:sessionState];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.textLabel.text = @"None";

	NSArray *games = nil;
    
    // Each tableView section represents an MCSessionState
    MCSessionState sessionState = indexPath.section;
	NSInteger peerIndex = indexPath.row;
    switch (sessionState)
    {
        case MCSessionStateConnecting:
        {
            games = [connectingGamesNameSet array];
            break;
        }
            
        case MCSessionStateConnected:
        {
            games = [connectedGamesNameSet array];
            break;
        }
            
        case MCSessionStateNotConnected:
        {
            games = [disconnectedGamesNameSet array];
            break;
        }
    }

    if ((games.count > 0) && (peerIndex < games.count))
    {
        cell.textLabel.text = [games objectAtIndex:peerIndex];
        
    }
    
  
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MCSessionState sessionState = indexPath.section;
    NSInteger peerIndex = indexPath.row;
    NSArray *peers = nil;
    switch (sessionState)
    {
        case MCSessionStateConnecting:
        {
            break;
        }
            
        case MCSessionStateConnected:
        {
            break;
            
        }
            //TODO: Still to test for intersection consistency between disconnected peers and peersInGame
        case MCSessionStateNotConnected:
        {
            peers = self.sessionController.disconnectedPeers;
            if ((peers.count > 0) && (peerIndex < peers.count))
            {
                NSString *gameName = [disconnectedGamesNameSet objectAtIndex:peerIndex];
                NSArray *peersInGame = [self.sessionController.peerIDToGameMap allKeysForObject:gameName];
                MCPeerID *peerID = [peersInGame objectAtIndex:0];
                [_sessionController invitePeerWith:peerID];
            }
            break;
        }
    }
}

@end
