//
//  ConnectionsViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by kinnu on 2/28/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "AppDelegate.h"

@interface ConnectionsViewController : UIViewController<MCBrowserViewControllerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
@property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;
@property (nonatomic, strong) AppDelegate *appDelegate;


- (IBAction)browseForDevices:(id)sender;
- (IBAction)toggleVisibility:(id)sender;
- (IBAction)disconnect:(id)sender;


@end
