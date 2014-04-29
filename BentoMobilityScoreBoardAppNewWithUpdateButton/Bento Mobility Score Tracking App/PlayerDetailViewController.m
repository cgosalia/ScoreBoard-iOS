//
//  PlayerDetailViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 2/21/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "PlayerInfo.h"
#import "Message.h"


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
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 568)];
    
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


- (void)updatePlayerNameAndScore:(PlayerInfo *)selectedPlayer newPlayer:(PlayerInfo *)newPlayer {
    if ([playerNameTextField.text length]>0) {
        newPlayer.playerName = playerNameTextField.text;
    } else {
        newPlayer.playerName = selectedPlayer.playerName;
    }
    
    if ([playerScoreTextField.text length] > 0) {
        newPlayer.score = [playerScoreTextField.text intValue];
    }
    
    [self.receivedTableView reloadData];
    [self setPlayerInEditDoneMode:newPlayer];
}

- (IBAction)savePlayerDetails:(id)sender {
    @try{
        PlayerInfo *selectedPlayer = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
        PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
        if ([playerNameTextField.text length]>0) {
            [self updatePlayerNameAndScore:selectedPlayer newPlayer:newPlayer];
            
            if(imageChanged) {
                CGSize scaledSize = CGSizeMake(64, 64);
                self.playerImageView.image = [self scaleImage:self.playerImageView.image to:scaledSize];
                newPlayer.playerImg = self.playerImageView.image;
                [self updatePlayerNameAndScore:selectedPlayer newPlayer:newPlayer];
            } else {
                newPlayer.playerImg = selectedPlayer.playerImg;
            }
            
            [receivedPlayerData replaceObjectAtIndex:receivedIndexPath.row withObject:newPlayer];
            [newPlayer setIsBeingEdited:NO];
            [receivedIsPlayerBeingEdited removeObjectForKey:selectedPlayer];
            //[Message send:receivedPlayerData];
            if (imageChanged) {
                [Message sendOneCell:[receivedPlayerData objectAtIndex:receivedIndexPath.row] forIndex:receivedIndexPath.row withMessageType:@"image"];
            } else {
                [Message sendOneCell:[receivedPlayerData objectAtIndex:receivedIndexPath.row] forIndex:receivedIndexPath.row withMessageType:@"scoreOrName"];
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
    NSLog(@"inside the cancel player details screen: %d", receivedIndexPath.row);
    PlayerInfo *playerInfo = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
    
    [playerInfo setIsBeingEdited:NO];
    [receivedPlayerData replaceObjectAtIndex:receivedIndexPath.row withObject:playerInfo];
    //[receivedIsPlayerBeingEdited removeObjectForKey:selectedPlayer];
    [Message send:receivedPlayerData];
    
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
        int savedIndex = receivedIndexPath.row;
        NSInteger *savedIndexInt = savedIndex;
        [receivedIsPlayerBeingEdited removeObjectForKey:playerInfo];
        [receivedPlayerData removeObjectAtIndex:receivedIndexPath.row];
        [receivedTableView deleteRowsAtIndexPaths:@[receivedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.receivedTableView reloadData];
        //[Message send:receivedPlayerData];
        playerInfo.playerImg = nil;
        [Message sendOneCell:playerInfo forIndex:savedIndexInt withMessageType:@"delete"];
        NSString *playerName = playerNameTextField.text;
        progressAlert = [[UIAlertView alloc] initWithTitle:nil
                                                   message:[NSString stringWithFormat:@"\"%@\" information deleted", playerName]
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


- (UIImage*)scaleImage:(UIImage *)originalImage to:(CGSize)targetSize
{
    UIImage *sourceImage = originalImage;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    // Set maximun compression in order to decrease file size
    //    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.0f);
    //    UIImage *processedImage = [UIImage imageWithData:imageData];
    
    return newImage;
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
