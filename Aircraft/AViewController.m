//
//  AViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 12/21/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AViewController.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALocalisedString(@"welcome")
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPt = [touch locationInView:self.view];
    _aircraftImgView = [[AAircraftImageView alloc] initWithImage:[UIImage imageNamed:@"Aircraft.png"]];
    _aircraftImgView.direction = AircraftDirectionDown;
    CGRect aFrame = _aircraftImgView.frame;
    aFrame.origin = touchPt;
    _aircraftImgView.frame = aFrame;
    [self.view addSubview:_aircraftImgView];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPt = [touch locationInView:self.view];
    CGRect aFrame = _aircraftImgView.frame;
    aFrame.origin = touchPt;
    _aircraftImgView.frame = aFrame;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
