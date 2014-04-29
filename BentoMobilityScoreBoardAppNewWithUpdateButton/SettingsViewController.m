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

@synthesize collectionView;



NSMutableArray *gameNames;

SessionController *sessionController = nil;

DiscoveryInfo *discoveryInfo;
UITapGestureRecognizer *tapGesture;

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
//    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showAlertView:)];
//    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gameMenu:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.collectionView addGestureRecognizer:tapGesture];
    
    
    //[scroller setScrollEnabled:YES];
    //[scroller setContentSize:CGSizeMake(320, 400)];
    
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    gameNames = [[NSMutableArray alloc] init];
    
}
- (void)showAlertView:(id)sender
{
    NSLog(@"Here back presed");
    
    //[self performSegueWithIdentifier:@"SettingsSegue" sender: sender];
    
    
}
- (void)startGame
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Start Game" message:@"Enter Name of Game" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Start Game",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    self.gameName = [alert textFieldAtIndex:0];
    [alert setTag:1];
    [alert show];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)defaultPresets
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Restore Preset Values " message: @"Do you want to reset preset button values to 1 5 10 and 25?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    [alert setTag:2];
    [alert show];
    
    
}

- (void)goToScoreBoard
{
    [self presentViewController:receivedSBViewController animated:YES completion:nil];
    //[self.navigationController pushViewController:receivedSBViewController animated:YES];
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
        
        discoveryInfo = [DiscoveryInfo getInstance];
        [discoveryInfo setDiscoveryInfoWithKey:@"gamename" andValue:self.gameName.text];
        
        [gameNames addObject:self.gameName.text];
        if (sessionController != nil) {
            [sessionController teardownSession];
        }
        
        sessionController = [SessionController sharedSessionController];
        [sessionController setupSession];
        [sessionController startAdvertizerServices];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GameStart" object:nil userInfo:nil];
        
        
        [self.receivedTableView reloadData];
        
    }
    
   
}


- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UILabel *label = (UILabel *)[cell viewWithTag:100];
    
    
    if(indexPath.row == 0)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Start" forIndexPath:indexPath];
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        return cell;
    }
    else if(indexPath.row == 1)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Join" forIndexPath:indexPath];
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        return cell;
    }
    else if(indexPath.row == 2)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Scoreboard" forIndexPath:indexPath];
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        return cell;
    }
    else if(indexPath.row == 3)
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Preset" forIndexPath:indexPath];
        cell.layer.borderWidth = 1.0f;
        cell.layer.borderColor = [UIColor blackColor].CGColor;
        return cell;
    }
    
    

    return nil;
}




- (void)gameMenu:(UITapGestureRecognizer *)sender
{
    CGPoint tapLocation = [sender locationInView:self.collectionView];
    //NSLog(@"taplocation : %f %f",tapLocation.x,tapLocation.y);
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:tapLocation];
    UICollectionViewCell *cell=[self.collectionView cellForItemAtIndexPath:indexPath];
    if(cell.tag==100)
    {
        [self startGame];
    }
    else if(cell.tag==200)
    {
        [self performSegueWithIdentifier:@"JoinGame" sender:self];
    }
    else if(cell.tag==300)
    {
          //[self.navigationController pushViewController:receivedSBViewController animated:YES];
        [self goToScoreBoard];
        
    }
    else if(cell.tag==400)
    {
        [self defaultPresets];
    }
   
}

@end
