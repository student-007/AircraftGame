//
//  AViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 12/21/12.
//  Copyright (c) 2012 Yufei Lang. All rights reserved.
//

#import "AViewController.h"
#import "AAircraftModel.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    AAircraftModel *air = [AAircraftModel aircraftWithOrgin:CGPointMake(0, 0) direction:AircraftDirectionUp];
    NSLog(@"main view loaded.");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
