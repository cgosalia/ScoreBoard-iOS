//
//  PlayerDetailViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/21/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "PlayerInfo.h"


@interface PlayerDetailViewController ()

@end

@implementation PlayerDetailViewController

@synthesize playerNameTextField;

@synthesize playerScoreTextField;

@synthesize receivedPlayerData;

@synthesize receivedIndexPath;

@synthesize receivedTableView;

@synthesize receivedIsPlayerBeingEdited;

@synthesize playerImageView;

UIAlertView *progressAlert;

bool imageChanged;



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
    PlayerInfo *playerInfo = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
    playerNameTextField.text = [playerInfo playerName];
    playerScoreTextField.text = [NSString stringWithFormat:@"%d",[playerInfo score]];
    playerImageView.image = [playerInfo playerImg];
    [self setPlayerInEditingMode:playerInfo];
    imageChanged = false;
    NSLog(@"Rec: %@",[NSString stringWithFormat:@"%d",(int)receivedIndexPath.row]);
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
	// Do any additional setup after loading the view.
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)deletePlayer:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Delete Player" message: @"Do you want to delete this player information?" delegate: self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes",nil];
    [alert setTag:1];
    [alert show];
}


- (IBAction)savePlayerDetails:(id)sender {
    @try{
        PlayerInfo *selectedPlayer = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
        PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
        if ([playerNameTextField.text length]>0) {
            if ((![selectedPlayer.playerName isEqualToString:playerNameTextField.text]) || (selectedPlayer.score != [playerScoreTextField.text intValue])) {
                newPlayer.playerName = playerNameTextField.text;
                if ([playerScoreTextField.text length] > 0) {
                    newPlayer.score = [playerScoreTextField.text intValue];
                }
                if(imageChanged) {
                    newPlayer.playerImg = self.playerImageView.image;
                } else {
                    newPlayer.playerImg = selectedPlayer.playerImg;
                }
                [receivedPlayerData replaceObjectAtIndex:receivedIndexPath.row withObject:newPlayer];
                [receivedIsPlayerBeingEdited removeObjectForKey:selectedPlayer];
                [self.receivedTableView reloadData];
                [self setPlayerInEditDoneMode:newPlayer];
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Player has been deleted" message:nil delegate:self cancelButtonTitle:@"Go to the track mode" otherButtonTitles:nil];
        [alert setTag:2];
        [alert show];
    }
    
    
}


- (IBAction)cancelPlayerDetails:(id)sender {
    PlayerInfo *playerInfo = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
    [self setPlayerInEditDoneMode:playerInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) checkTimer:(NSTimer *)timer
{
	[progressAlert dismissWithClickedButtonIndex:-1 animated:YES];
    [timer invalidate];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1 && alertView.tag==1) {
        PlayerInfo *playerInfo = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
        [receivedIsPlayerBeingEdited removeObjectForKey:playerInfo];
        [receivedPlayerData removeObjectAtIndex:receivedIndexPath.row];
        [receivedTableView deleteRowsAtIndexPaths:@[receivedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.receivedTableView reloadData];
        NSString *playerName = playerNameTextField.text;
        progressAlert = [[UIAlertView alloc] initWithTitle:nil
                                                   message:[NSString stringWithFormat:@"Player \"%@\" information deleted", playerName]
                                                  delegate: self
                                         cancelButtonTitle: nil
                                         otherButtonTitles: nil];
        [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector:@selector(checkTimer:) userInfo: nil repeats: YES];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityView.frame = CGRectMake(139.0f-18.0f, 78.0f, 37.0f, 37.0f);
        [progressAlert addSubview:activityView];
        [activityView startAnimating];
        [progressAlert show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (buttonIndex == 0 && alertView.tag==2){
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Image taken");
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.playerImageView.image = chosenImage;
    imageChanged = true;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void) setPlayerInEditingMode:(PlayerInfo *)player {
    receivedIsPlayerBeingEdited[player] = @YES;
}

-(void) setPlayerInEditDoneMode:(PlayerInfo *)player {
    receivedIsPlayerBeingEdited[player] = @NO;
}

- (IBAction)addPhoto:(id)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}
@end
