//
//  ConnectionsViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by kinnu on 2/28/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionsViewController : UIViewController

@property (weak,nonatomic) IBOutlet UITextField *txtname;
@property (weak,nonatomic) IBOutlet UISwitch *swVisible;
@property (weak,nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (weak,nonatomic) IBOutlet UIButton *btnDisconnect;



-(IBAction)browseForDevices:(id)sender;
-(IBAction)toggleVisibility:(id)sender;
-(IBAction)disconnect:(id)sender;
@end
