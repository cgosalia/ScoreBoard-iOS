

#import "BrowseViewController.h"

@interface BrowseViewController () // Class extension
@property (nonatomic, strong) SessionController *sessionController;
@end

@implementation BrowseViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //_sessionController = [[SessionController alloc] init];
    _sessionController = [SessionController sharedSessionController];
    self.sessionController.delegate = self;
    [self.sessionController startBrowserServices];
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
            rows = self.sessionController.connectingPeers.count;
            break;
        }
            
        case MCSessionStateConnected:
        {
            rows = self.sessionController.connectedPeers.count;
            break;
        }
            
        case MCSessionStateNotConnected:
        {
            rows = self.sessionController.disconnectedPeers.count;
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

	NSArray *peers = nil;
    
    // Each tableView section represents an MCSessionState
    MCSessionState sessionState = indexPath.section;
	NSInteger peerIndex = indexPath.row;
    switch (sessionState)
    {
        case MCSessionStateConnecting:
        {
            peers = self.sessionController.connectingPeers;
            break;
        }
            
        case MCSessionStateConnected:
        {
            peers = self.sessionController.connectedPeers;
            break;
        }
            
        case MCSessionStateNotConnected:
        {
            peers = self.sessionController.disconnectedPeers;
            break;
        }
    }

    if ((peers.count > 0) && (peerIndex < peers.count))
    {
        MCPeerID *peerID = [peers objectAtIndex:peerIndex];
        
        if (peerID)
        {
            cell.textLabel.text = peerID.displayName;
        }
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
            
        case MCSessionStateNotConnected:
        {
            peers = self.sessionController.disconnectedPeers;
            if ((peers.count > 0) && (peerIndex < peers.count))
            {
                MCPeerID *peerID = [peers objectAtIndex:peerIndex];
                [_sessionController invitePeerWith:peerID];
            }
            break;
        }
    }
}

@end
