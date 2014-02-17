//
//  JoinSessionViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/16/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "JoinSessionViewController.h"
#import "Client.h"

@interface JoinSessionViewController ()

@end

@implementation JoinSessionViewController
{
    Client *_client;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[_ClientName setDelegate:self];
	// Do any additional setup after loading the view.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.ClientName action:@selector(resignFirstResponder)];
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.view addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
	if (_client == nil)
	{
		_client = [[Client alloc] init];
        _client.delegate = self;
		[_client startSearchingForServersWithSessionID:SESSION_ID];
        
		self.ClientName.placeholder = _client.session.displayName;
		[self.clientListOfHosts reloadData];
	}
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)toClient:(Client *)client serverBecameAvailable:(NSString *)peerID
{
	[self.clientListOfHosts reloadData];
}

- (void)toClient:(Client *)client serverBecameUnavailable:(NSString *)peerID
{
	[self.clientListOfHosts reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_client != nil)
		return [_client availableServerCount];
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"CellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
	NSString *peerID = [_client peerIDForAvailableServerAtIndex:indexPath.row];
	cell.textLabel.text = [_client displayNameForPeerID:peerID];
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	if (_client != nil)
	{
		//[self.view addSubview:self.waitView];
        
		NSString *peerID = [_client peerIDForAvailableServerAtIndex:indexPath.row];
		[_client connectToServerWithPeerID:peerID];
	}
}

@end
