//
//  PresetSettingsViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/1/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "PresetSettingsViewController.h"

@interface PresetSettingsViewController ()

@end

@implementation PresetSettingsViewController

@synthesize preset1;

@synthesize preset2;

@synthesize preset3;

@synthesize preset4;

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
    NSUserDefaults *settingsDefaults = [NSUserDefaults standardUserDefaults];
    int preset1Value = [settingsDefaults integerForKey:@"preset1"];
    int preset2Value = [settingsDefaults integerForKey:@"preset2"];
    int preset3Value = [settingsDefaults integerForKey:@"preset3"];
    int preset4Value = [settingsDefaults integerForKey:@"preset4"];
    [preset1 setText:[NSString stringWithFormat:@"%d", preset1Value]];
    [preset2 setText:[NSString stringWithFormat:@"%d", preset2Value]];
    [preset3 setText:[NSString stringWithFormat:@"%d", preset3Value]];
    [preset4 setText:[NSString stringWithFormat:@"%d", preset4Value]];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePresets:(id)sender {
    
    NSUserDefaults *settingsDefault = [NSUserDefaults standardUserDefaults];
    if(preset1.text.length>0) {
        [settingsDefault setInteger:[preset1.text integerValue] forKey:@"preset1"];
    }
    if(preset2.text.length>0) {
        [settingsDefault setInteger:[preset2.text integerValue] forKey:@"preset2"];
    }
    if(preset3.text.length>0) {
        [settingsDefault setInteger:[preset3.text integerValue] forKey:@"preset3"];
    }
    if(preset4.text.length>0) {
        [settingsDefault setInteger:[preset4.text integerValue] forKey:@"preset4"];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
