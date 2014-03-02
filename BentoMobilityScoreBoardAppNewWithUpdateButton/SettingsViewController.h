//
//  SettingsViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/22/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITextField *txtMsg;
@property (weak,nonatomic) IBOutlet UILabel * herelabel;
-(void)sendMyMessage;

- (IBAction)sendData:(id)sender;
- (IBAction)cancelSend:(id)sender;

- (IBAction)cancelSettings:(id)sender;

- (IBAction)saveSettings:(id)sender;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end
