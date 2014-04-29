//
//  ScoreBoardViewController.m
//  Bento Mobility Score Tracking App
//
//  Created by Ravi Varsha Cheemanahalli Gopalakrishna on 3/15/14.
//  Copyright (c) 2014 Ravi Varsha Cheemanahalli Gopalakrishna. All rights reserved.
//

#import "ScoreBoardViewController.h"
#import "PlayerInfo.h"
#import "PlayerCollectionCell.h"

@interface ScoreBoardViewController ()

@end

@implementation ScoreBoardViewController

@synthesize dataSrc;

@synthesize collectionView;

PlayerCollectionCell *cell;

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
//    previousDataSrc = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScoreBoard:)
                                                 name:@"PlayerInfoChangedNotification"
                                               object:nil];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [dataSrc count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    //    return [self.searches count];
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@" i reachd hre");
    cell = [cv dequeueReusableCellWithReuseIdentifier:@"ScoreBoardPlayerCell" forIndexPath:indexPath];
    PlayerInfo *player = [dataSrc objectAtIndex:indexPath.row];
    cell.playerName.text = player.playerName;
    cell.playerScore.text = [NSString stringWithFormat:@"%d", player.score];
    cell.playerImage.image = player.playerImg;
    return cell;
}

/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(320, 60);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateScoreBoard:(NSNotification *)notification
{
//    NSMutableArray *oldData =[self.collectionView dataSource];
//    NSIndexPath *oldIndexPath =
    
    
    
    
    
    NSMutableArray *tempArray = [notification.userInfo objectForKey:@"trackingModeDS"];
    dataSrc = [[NSMutableArray alloc] init];

    //NSMutableArray dataSrcOld = [[NSMutableArray alloc] init];
    for(int i=0;i<[tempArray count];i++) {
        PlayerInfo *temp = [[tempArray objectAtIndex:i] copy];
        [dataSrc addObject:temp];
        //[dataSrcOld addObject:temp];
    }/*
    for(int c = 0; c < tempArray.count; c++)
    {
        NSLog(@" %d, %d %@" ,[[tempArray objectAtIndex:c] score], [[dataSrc objectAtIndex:0] score], [[dataSrc objectAtIndex:<#(NSUInteger)#>]]);
    }*/
    
    
    for(int c = 0; c < tempArray.count; c++)
    {
        NSLog(@" %d, %d " ,[[tempArray objectAtIndex:c] score], [[dataSrc objectAtIndex:c] score]);
    }
    [dataSrc sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int scr1 = [(PlayerInfo *)obj1 score];
        int scr2 = [(PlayerInfo *)obj2 score];
        if(scr1 < scr2)
            return 1;
        else if(scr1 > scr2)
            return -1;
        else
            return 0;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self.collectionView reloadData];
                       
                   });
    
    
   // [self animateCollectionView:tempArray];
    
   
  //   previousDataSrc = [dataSrc copy];
    //[self.collectionView up]
   /*
    if (dataSrc.count == 1 ) {
        NSLog(@"here in one element");

     
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.collectionView reloadData];
                           
                       });
        
    }
    else if(dataSrc.count > previousDataSrc.count){
        NSLog(@"here in added element");

//        PlayerInfo *newPlayer = [tempArray ]
//        NSIndexPath *newIndex =[NSIndexPath indexPathForItem:previousDataSrc.count inSection:0];
//        NSArray *indexForNew = [[NSArray alloc]initWithObjects:newIndex, nil];
//        [self.collectionView insertItemsAtIndexPaths:indexForNew];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.collectionView reloadData];
                           
                       });
    }
    else if(dataSrc.count < previousDataSrc.count){
        NSLog(@"here in delete element");
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           [self.collectionView reloadData];
                           
                       });
        
    }
    else if(dataSrc.count == previousDataSrc.count){*/
      /*  NSLog(@"here same elements element");
        [self.collectionView performBatchUpdates:^{
            
            for (NSInteger i=0;i< tempArray.count;i++){
                NSIndexPath *from =[NSIndexPath indexPathForItem:i inSection:0];
                NSInteger j=[dataSrc indexOfObject:tempArray[i]];
                NSIndexPath *to=[NSIndexPath indexPathForItem:j inSection:0];
                NSLog(@"from   %@ to :  %@ ",from,to);
                [self.collectionView moveItemAtIndexPath:from toIndexPath:to];
            }
        }completion:^(BOOL finished) {}];*/
        
   /* }
    else{
        NSLog(@"here in last else");
    }*/
//        }
//
//    [self.collectionView performBatchUpdates:^{
//        for (int ii = 0; ii < dataSrc.count; ii++) {
//            
//            PlayerInfo *item = [dataSrc getItemAtIndex:(NSInteger)ii];
//            NSNumber *prevPos = (NSNumber *)[from objectForKey:[NSNumber numberWithInt:item.id]];
//            if ([prevPos intValue] != ii) {
//                NSIndexPath *from = [NSIndexPath indexPathForItem:prevPos.intValue inSection:0];
//                NSIndexPath *to = [NSIndexPath indexPathForItem:ii inSection:0];
//                [self.collectionView moveItemAtIndexPath:from toIndexPath:to];
//            }
//        }
//    } completion:nil];
//
    /*dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [self.collectionView reloadData];
                       
                   });*/

   

}

-(void)animateCollectionView: (NSMutableArray *) tempArray
{
    [self.collectionView performBatchUpdates:^{
        
        for (NSInteger i=0;i< tempArray.count;i++){
            NSIndexPath *from =[NSIndexPath indexPathForItem:i inSection:0];
            NSInteger j=[dataSrc indexOfObject:tempArray[i]];
            NSIndexPath *to=[NSIndexPath indexPathForItem:j inSection:0];
            NSLog(@"from   %@ to :  %@ ",from,to);
            [self.collectionView moveItemAtIndexPath:from toIndexPath:to];
        }
    }completion:^(BOOL finished) {}];
    
}


@end
