//
//  IncrDecrScoreViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/1/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "IncrDecrScoreViewController.h"
#import "PlayerInfo.h"

@interface IncrDecrScoreViewController ()

@end

@implementation IncrDecrScoreViewController

@synthesize preset1;

@synthesize preset2;

@synthesize preset3;

@synthesize preset4;

@synthesize incrementOrDecrementFlag;

@synthesize currentScore;

@synthesize totalScore;

@synthesize navigationBar;

@synthesize label;

@synthesize infoLabel;

@synthesize receivedIndexPath;

@synthesize receivedPlayerData;

@synthesize receivedTableView;

NSInteger *preset1Value;

NSInteger *preset2Value;

NSInteger *preset3Value;

NSInteger *preset4Value;

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
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:200.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    if (incrementOrDecrementFlag) {
        navigationBar.topItem.title =  @"Increment Score";
        [label setText:@"Add Score:"];
        [preset1 setBackgroundColor:greenColor];
        [preset1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [preset2 setBackgroundColor:greenColor];
        [preset2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [preset3 setBackgroundColor:greenColor];
        [preset3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [preset4 setBackgroundColor:greenColor];
        [preset4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        navigationBar.topItem.title = @"Decrement Score";
        [label setText:@"Reduce Score:"];
        [preset1 setBackgroundColor:redColor];
        [preset1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [preset2 setBackgroundColor:redColor];
        [preset2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [preset3 setBackgroundColor:redColor];
        [preset3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [preset4 setBackgroundColor:redColor];
        [preset4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
	// Do any additional setup after loading the view.
    PlayerInfo *selectedPlayer = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
    int playerScore = selectedPlayer.score;
    [currentScore setText:[NSString stringWithFormat:@"%d", playerScore]];
    [totalScore setText:[NSString stringWithFormat:@"%d", playerScore]];
    preset1Value = [settingsDefaults integerForKey:@"preset1"];
    preset2Value = [settingsDefaults integerForKey:@"preset2"];
    preset3Value = [settingsDefaults integerForKey:@"preset3"];
    preset4Value = [settingsDefaults integerForKey:@"preset4"];
    
    [preset1 setTitle:[NSString stringWithFormat:@"%d", preset1Value] forState:UIControlStateNormal];
    [preset2 setTitle:[NSString stringWithFormat:@"%d", preset2Value] forState:UIControlStateNormal];
    [preset3 setTitle:[NSString stringWithFormat:@"%d", preset3Value] forState:UIControlStateNormal];
    [preset4 setTitle:[NSString stringWithFormat:@"%d", preset4Value] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    UILongPressGestureRecognizer *longPressPreset1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnPresetButton1:)];
    UILongPressGestureRecognizer *longPressPreset2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnPresetButton2:)];
    UILongPressGestureRecognizer *longPressPreset3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnPresetButton3:)];
    UILongPressGestureRecognizer *longPressPreset4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnPresetButton4:)];
    [self.preset1 addGestureRecognizer:longPressPreset1];
    [self.preset2 addGestureRecognizer:longPressPreset2];
    [self.preset3 addGestureRecognizer:longPressPreset3];
    [self.preset4 addGestureRecognizer:longPressPreset4];
}

- (void)longPressOnPresetButton1:(UILongPressGestureRecognizer*)gesture {
    
    if ( gesture.state == UIGestureRecognizerStateBegan ) {
        [self createAlertViewsWith:[NSString stringWithFormat:@"%d", preset1Value] withTag:1];
    }
}

- (void)longPressOnPresetButton2:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateBegan ) {
        [self createAlertViewsWith:[NSString stringWithFormat:@"%d", preset2Value] withTag:2];
    }
}
- (void)longPressOnPresetButton3:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateBegan ) {
        [self createAlertViewsWith:[NSString stringWithFormat:@"%d", preset3Value] withTag:3];
    }}
- (void)longPressOnPresetButton4:(UILongPressGestureRecognizer*)gesture {
    if ( gesture.state == UIGestureRecognizerStateBegan ) {
        [self createAlertViewsWith:[NSString stringWithFormat:@"%d", preset4Value] withTag:4];
    }
}


-(void) createAlertViewsWith:(NSString *)value withTag:(int)num {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change Preset" message:@"Enter preset score amount for this button" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *alertTextField = [alert textFieldAtIndex:0];
    alertTextField.text = value;
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    [alert setTag:num];
    alert.show;
}

-(void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag==1 && buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length]>0) {
            preset1Value = [textField.text integerValue];
            [preset1 setTitle:textField.text forState:UIControlStateNormal];
            [self savePresetFor:@"preset1" with:preset1Value];
        }
    }
    else if(alertView.tag==2 && buttonIndex == 1 ) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length]>0) {
            preset2Value = [textField.text integerValue];
            [preset2 setTitle:textField.text forState:UIControlStateNormal];
            [self savePresetFor:@"preset2" with:preset2Value];
        }
    }
    else if(alertView.tag==3 && buttonIndex == 1 ) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length]>0) {
            preset3Value = [textField.text integerValue];
            [preset3 setTitle:textField.text forState:UIControlStateNormal];
            [self savePresetFor:@"preset3" with:preset3Value];
        }
    }
    else if(alertView.tag == 4)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length]>0) {
            preset4Value = [textField.text integerValue];
            [preset4 setTitle:textField.text forState:UIControlStateNormal];
            [self savePresetFor:@"preset4" with:preset4Value];
        }
        
        
    }
}


- (void)savePresetFor:(NSString *)preset with:(NSInteger)value {
    
    NSUserDefaults *settingsDefault = [NSUserDefaults standardUserDefaults];
    [settingsDefault setInteger:value forKey:preset];
    
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

- (IBAction)cancelIncrDecr:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)doneIncrDecr:(id)sender {
    PlayerInfo *selectedPlayer = [receivedPlayerData objectAtIndex:receivedIndexPath.row];
    
    PlayerInfo *newPlayer = [[PlayerInfo alloc] init];
    newPlayer.playerName = selectedPlayer.playerName;
    newPlayer.score = [totalScore.text intValue];
    [receivedPlayerData replaceObjectAtIndex:receivedIndexPath.row withObject:newPlayer];
    [self.receivedTableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) updatePresetBy:(NSInteger)presetVal {
    [infoLabel setHidden:YES];
    if(incrementOrDecrementFlag) {
        int currentTotalScore = [totalScore.text intValue];
        int presetValue = presetVal;
        int totalScr = currentTotalScore+presetValue;
        [totalScore setText:[NSString stringWithFormat:@"%d", totalScr]];
    } else {
        int currentTotalScore = [totalScore.text intValue];
        int presetValue = presetVal;
        int totalScr = currentTotalScore-presetValue;
        [totalScore setText:[NSString stringWithFormat:@"%d", totalScr]];
//        if(totalScr >= 0) {
//            [totalScore setText:[NSString stringWithFormat:@"%d", totalScr]];
//        } else {
//            [infoLabel setHidden:NO];
//            [infoLabel setText:@"Score cannot be less than zero."];
//            [infoLabel setBackgroundColor:[UIColor lightGrayColor]];
//        }
    }
}
- (IBAction)incrDecrByPreset1:(id)sender {
    [self updatePresetBy:preset1Value];
}

- (IBAction)incrDecrByPreset2:(id)sender {
    [self updatePresetBy:preset2Value];
}
- (IBAction)incrDecrByPreset3:(id)sender {
    [self updatePresetBy:preset3Value];
}
- (IBAction)incrDecrByPreset4:(id)sender {
    [self updatePresetBy:preset4Value];
}

@end
