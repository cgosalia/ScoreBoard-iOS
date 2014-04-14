//
//  SettingsViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/22/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "SettingsViewController.h"
#import "ScoreBoardViewController.h"
#import "SessionController.h"
#import "DiscoveryInfo.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

UIAlertView *progressAlert;

@synthesize receivedSBViewController;

@synthesize receivedTableView;

NSMutableArray *gameNames;

SessionController *sessionController;

DiscoveryInfo *discoveryInfo;

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
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    gameNames = [[NSMutableArray alloc] init];
    
}

- (IBAction)startGame:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start Game" message:@"Enter Name of Game" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Start Game",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.gameName = [alert textFieldAtIndex:0];
    [alert setTag:1];
    [alert show];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)defaultPresets:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Restore Preset Values " message: @"Do you want to reset preset button values to 1 5 10 and 25?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    [alert setTag:2];
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
    
    if (buttonIndex == 1 && alertView.tag==2) {
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
    if(buttonIndex == 1 && alertView.tag==1)
    {
//        _appDelegate.mcManager.peerID = nil;
//        _appDelegate.mcManager.session = nil;
//        _appDelegate.mcManager.browser = nil;
//        
//        _appDelegate.mcManager.advertiser = nil;
//        
//        
//        [_appDelegate.mcManager setupPeerAndSessionWithDisplayName:_gameName.text];
//        [_appDelegate.mcManager setupMCBrowser];
//        [_appDelegate.mcManager advertiseSelf:YES];
        
        discoveryInfo = [DiscoveryInfo getInstance];
        [discoveryInfo setDiscoveryInfoWithKey:@"gamename" andValue:self.gameName.text];
        
        [gameNames addObject:self.gameName.text];
        
        sessionController = [SessionController sharedSessionController];
        [sessionController startAdvertizerServices];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameStart" object:nil userInfo:nil];
        
        
        [self.receivedTableView reloadData];
        
    }
    
    
}


- (NSString *) stringForGameNameAt:(int)section {
    if([gameNames count] == 0) {
        return NULL;
    }
    return [gameNames objectAtIndex:section];
}

@end
