//
//  AViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 12/21/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AViewController.h"
#import "ACommunicator.h"
#import "UIFont+AUIColorTheme.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.organizer = [[AGameOrganizer alloc] init];
    AChattingViewController *chatVC = [self.organizer getChatVC];
    
    [self.view addSubview:chatVC.view];
    
//    [self.organizer makeConnectionWithType:ConnectionTypeBluetooth];
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPt = [touch locationInView:self.view];
//    _aircraftImgView = [[AAircraftImageView alloc] initWithImage:[UIImage imageNamed:@"Aircraft.png"]];
//    _aircraftImgView.direction = AircraftDirectionDown;
//    CGRect aFrame = _aircraftImgView.frame;
//    aFrame.origin = touchPt;
//    _aircraftImgView.frame = aFrame;
//    [self.view addSubview:_aircraftImgView];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPt = [touch locationInView:self.view];
//    CGRect aFrame = _aircraftImgView.frame;
//    aFrame.origin = touchPt;
//    _aircraftImgView.frame = aFrame;
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTestLabel:nil];
    [super viewDidUnload];
}
@end
