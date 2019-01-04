//
//  ViewController.m
//  memory
//
//  Created by 張書涵 on 2019/1/2.
//  Copyright © 2019 張書涵. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSArray* imgsArr;
    float gameViewWidth;
    int gridSize;
    
    NSMutableArray* blocksArr;
    NSMutableArray* centersArr;
    
    NSTimer* gameTimer;
    int curTime;
    
    BOOL compareStatue;
    int indOfFirstImgView;
    int indOfSecondImgView;
    
    BOOL tapIsAllowd;
    
    int matchSoFar;
    
}

@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    [self arrayMakeAction];
    
    [_gameView layoutIfNeeded];
    
    gameViewWidth = _gameView.bounds.size.width;
    
    [self resetAction:4];
    
    compareStatue = false;
    
    tapIsAllowd = true;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *myTouch = [[touches allObjects] objectAtIndex:0];
    
    if ([blocksArr containsObject:myTouch.view] && tapIsAllowd){
        
        UIImageView* thisImgView = (UIImageView *)myTouch.view;
        
        int indOfImgView = (int)[blocksArr indexOfObject:thisImgView];
        
        if (indOfImgView >= gridSize*gridSize/2)
            indOfImgView = indOfImgView - (gridSize*gridSize/2);
        
        if (compareStatue){
            
            indOfSecondImgView = (int)[blocksArr indexOfObject:thisImgView];
            
        }else{
            
            indOfFirstImgView = (int)[blocksArr indexOfObject:thisImgView];
        }
        
        [UIView transitionWithView:thisImgView duration:.75 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            tapIsAllowd = false;
            thisImgView.image = [UIImage imageNamed:[imgsArr objectAtIndex:indOfImgView]];
        } completion:^(BOOL finished) {
            tapIsAllowd = true;
            if (compareStatue){
                [self compareAction];
                compareStatue = false;
                
            }else{
                compareStatue = true;
            }
        }];
        
    }
}

-(void)compareAction {
    if (abs(indOfFirstImgView-indOfSecondImgView) == gridSize*gridSize/2) {
        //they are same
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5];
        [[blocksArr objectAtIndex:indOfFirstImgView]setAlpha:0];
        [[blocksArr objectAtIndex:indOfSecondImgView]setAlpha:0];
        [UIView commitAnimations];
        
        matchSoFar ++;
        
        if (matchSoFar == gridSize*gridSize/2){
            NSLog(@"Nice job");
            [self resetAction:4];
            
        }
            
    } else {
        //they are different
        UIImageView* firstImgView = [blocksArr objectAtIndex:indOfFirstImgView];
        UIImageView* secondImgView = [blocksArr objectAtIndex:indOfSecondImgView];
        
        [UIView transitionWithView:self.view
                          duration:.5
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            firstImgView.image = [UIImage imageNamed:@"noImg.png"];
                            secondImgView.image = [UIImage imageNamed:@"noImg.png"];
                        } completion:nil];
        
    }
}

-(void)blockMakerAction {
    
    //initialize and set then ready to accept elements
    blocksArr = [NSMutableArray new];
    centersArr = [NSMutableArray new];
    
    float blockWidth = gameViewWidth / gridSize;
    
    float xCen = blockWidth/2;
    float yCen = blockWidth/2;
    int counter = 0;
    
    for (int h = 0; h < gridSize; h++)
    {
        for (int v = 0; v < gridSize; v++)
        {
            if (counter == gridSize*gridSize/2)
                counter = 0;
            
            UIImageView* block = [[UIImageView alloc]init];
            
            CGRect blockFrame = CGRectMake(0, 0, blockWidth-10, blockWidth-10);
            block.frame = blockFrame;
            block.image = [UIImage imageNamed:[imgsArr objectAtIndex:counter]];
            
            CGPoint newCenter = CGPointMake(xCen, yCen);
            block.center = newCenter;
            
            block.userInteractionEnabled = YES;
            
            [blocksArr addObject:block];
            [centersArr addObject:[NSValue valueWithCGPoint:newCenter]];
            
            [_gameView addSubview: block];
            
            counter ++;
            xCen = xCen + blockWidth;
        }
        yCen = yCen + blockWidth;
        xCen = blockWidth/2;
    }
    
    NSLog(@"Center array is: %@",centersArr);
    
}

-(void)randomizeAction {
    NSMutableArray* temp = [centersArr mutableCopy];
    
    for (UIImageView * block in blocksArr)
    {
        int randIndex = arc4random() % temp.count;
        CGPoint randCen = [[temp objectAtIndex:randIndex] CGPointValue];
        block.center = randCen;
        [temp removeObjectAtIndex:randIndex];
    }
}

-(void)resetAction:(int)inpGridSize{
    
    for (UIView* any in _gameView.subviews)
        [any removeFromSuperview];
    
    [blocksArr removeAllObjects];
    [centersArr removeAllObjects];
    gridSize = inpGridSize;
    
    [self blockMakerAction];
    [self randomizeAction];
    
    for (UIImageView* any in blocksArr)
        any.image = [UIImage imageNamed:@"noImg.png"];
    
    matchSoFar = 0;
    curTime = 0;
    [gameTimer invalidate];
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}

-(void)timerAction {
    curTime ++;
    int timeMins = abs(curTime/60);
    int timeSec = curTime % 60;
    
    NSString* timeStr = [NSString stringWithFormat:@"%d\':%d\"",timeMins,timeSec];
    
    _timerLabel.text = timeStr;
}


- (IBAction)resetFourAction:(id)sender {
    
    [self resetAction:4];
    
}

- (IBAction)resetSixAction:(id)sender {
    
    [self resetAction:6];
    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void) arrayMakeAction {
    imgsArr = [[NSArray alloc] initWithObjects:
               
               @"c37e471cbda190a9c8cce3892d3fda26.jpg",
               @"charlie_1_20160614_1804687380.jpg",
               @"ciwHbm-L.jpg",
               @"colour_blocks.jpg",
               @"dream-image.jpg",
               @"Image Essentials Stetson.jpg",
               @"image-3-512x512.jpg",
               @"image.jpg",
               @"cropped-image-17.jpg",
               @"peppers.png",
               @"on_the_phone.jpg",
               @"texture.jpg",
               @"Superdomo-la-rioja-image.jpg",
               @"Snapshot _ Roby  Coccy  IRDS 123 224 22 - Adulti.png",
               @"Lichtenstein_img_processing_test.png",
               @"Snapshot _ Roby  Coccy  IRDS 101 180 22 - Adulti.png",
               @"Snapshot _ Roby  Coccy  IRDS 123 224 22 - Adulti",
               @"Superdomo-la-rioja-image.jpg",
               @"texture.jpg"
               
               ,nil];
}

@end
