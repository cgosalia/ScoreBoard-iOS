//
//  PresetSettingsViewController.h
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/1/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresetSettingsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *preset1;
@property (strong, nonatomic) IBOutlet UITextField *preset2;
@property (strong, nonatomic) IBOutlet UITextField *preset3;
@property (strong, nonatomic) IBOutlet UITextField *preset4;
- (IBAction)savePresets:(id)sender;

@end
