//
//  BluetoothSettingsViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/2/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BluetoothSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITextField *txtMsg;
@property (weak,nonatomic) IBOutlet UILabel * herelabel;
-(void)sendMyMessage;

- (IBAction)sendData:(id)sender;

- (IBAction)cancelSend:(id)sender;

-(void)didReceiveDataWithNotification:(NSNotification *)notification;


@end
