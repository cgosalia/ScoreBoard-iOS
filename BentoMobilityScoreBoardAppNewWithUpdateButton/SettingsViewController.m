//
//  SettingsViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/22/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "SettingsViewController.h"
#import "ScoreBoardViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

UIAlertView *progressAlert;

//UIViewController *scoreboardController = nil;

@synthesize receivedSBViewController;

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
    
    
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)defaultPresets:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Restore Preset Values " message: @"Do you want to reset preset button values to 1 5 10 and 25?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    [alert show];
    
    
}

- (IBAction)goToScoreBoard:(id)sender {
    [self.navigationController pushViewController:receivedSBViewController animated:YES];
}

- (void) checkTimer:(NSTimer *)timer
{
	[progressAlert dismissWithClickedButtonIndex:-1 animated:YES];
    [timer invalidate];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSUserDefaults *settingsDefault = [NSUserDefaults standardUserDefaults];
        [settingsDefault setInteger:1 forKey:@"preset1"];
        [settingsDefault setInteger:5 forKey:@"preset2"];
        [settingsDefault setInteger:10 forKey:@"preset3"];
        [settingsDefault setInteger:25 forKey:@"preset4"];
        progressAlert = [[UIAlertView alloc] initWithTitle:@"Preset set to default values"
                                                   message:@"(1 5 10 25)"
                                                  delegate: self
                                         cancelButtonTitle: nil
                                         otherButtonTitles: nil];
        [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector:@selector(checkTimer:) userInfo: nil repeats: YES];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(139.0f-18.0f, 78.0f, 37.0f, 37.0f);
        [progressAlert addSubview:activityView];
        [activityView startAnimating];
        [progressAlert show];
    }
}
@end
