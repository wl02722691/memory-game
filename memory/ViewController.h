//
//  ViewController.h
//  memory
//
//  Created by 張書涵 on 2019/1/2.
//  Copyright © 2019 張書涵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *gameView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

- (IBAction)resetFourAction:(id)sender;
- (IBAction)resetSixAction:(id)sender;

@end

