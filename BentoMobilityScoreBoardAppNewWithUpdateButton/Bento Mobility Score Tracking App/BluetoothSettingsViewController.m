//
//  BluetoothSettingsViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/2/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "BluetoothSettingsViewController.h"
#import "AppDelegate.h"

@interface BluetoothSettingsViewController ()

@property (nonatomic, strong) AppDelegate *appDelegate;

@end

@implementation BluetoothSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)sendMyMessage{
    
    //NSData *dataToSend = [_txtMsg.text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *dataToSend=_txtMsg.text;
    NSDictionary *message=@{@"message":dataToSend};
    NSData *messageData=[NSJSONSerialization dataWithJSONObject:message options:0 error:nil];
    NSArray *allPeers = _appDelegate.mcManager.session.connectedPeers;
    NSError *error=nil;
    
    /*NSData *JSONRequestData=NULL;
     if ([NSJSONSerialization isValidJSONObject:messageData]) {
     NSLog(@"Proper JSON Object");
     JSONRequestData = [NSJSONSerialization dataWithJSONObject:messageData options:kNilOptions error:&error];
     }
     else {
     NSLog(@"requestData was not a proper JSON object");
     
     }*/
    
    
    
    
    // NSLog(allPeers[0]);
    NSLog(@"after printing array");
    [_appDelegate.mcManager.session sendData:messageData
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    //setText:[stringByAppendingString:[NSString stringWithFormat:@"I wrote:\n%@\n\n", _txtMsg.text];
    [_txtMsg setText:@""];
    NSLog(@"Rohit here");
    [_txtMsg resignFirstResponder];
}


-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    //MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    //NSString *peerDisplayName = peerID.displayName;
    
    NSString *receivedData = [[notification userInfo] objectForKey:@"message"];
    //NSString *actualData=[receivedData valueForKey:@"message"];
    //NSString *receivedText = [[NSString alloc] initWithData:actualData encoding:NSUTF8StringEncoding];
    NSLog(@"in did receive data with notification %@", receivedData );
    
    dispatch_async(dispatch_get_main_queue(),^{ [self.herelabel setText:receivedData];});

}
- (IBAction)sendData:(id)sender {
    [self sendMyMessage];
}

- (IBAction)cancelSend:(id)sender {
    [_txtMsg resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //_txtMsg.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self sendMyMessage];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int num = indexPath.row;
    UITableViewCell *cell;
    
    return cell;
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

@end
