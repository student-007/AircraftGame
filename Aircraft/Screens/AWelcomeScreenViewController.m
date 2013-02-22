//
//  AWelcomeScreenViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 1/11/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "AWelcomeScreenViewController.h"

@interface AWelcomeScreenViewController ()

@end

@implementation AWelcomeScreenViewController

@synthesize playWithBluetoothBtn = _playWithBluetoothBtn;

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
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playWithBluetooth:(id)sender
{
    AGameOrganizer *organizer = [AGameOrganizer sharedInstance];
    organizer.connectionType = ConnectionTypeBluetooth;
    
    APlayScreenViewController *playScreenVC = [[APlayScreenViewController alloc]
                                               initWithNibName:@"APlayScreenViewController" bundle:nil];
    [[AAppDelegate sharedInstance] pushScreen:playScreenVC animated:YES];
}

- (IBAction)actionSavedGameButtonClicked:(id)sender
{
    ALoadSavedGameScreenViewController *vc = [[ALoadSavedGameScreenViewController alloc] initWithNibName:@"ALoadSavedGameScreenViewController" bundle:nil];
    [[AAppDelegate sharedInstance] pushScreen:vc animated:YES];
}

- (IBAction)actionSetting:(id)sender 
{
    ASettingScreenViewController *settingVC = [[ASettingScreenViewController alloc] initWithNibName:@"ASettingScreenViewController" bundle:nil];
    [[AAppDelegate sharedInstance] pushScreen:settingVC animated:YES];
}

- (void)viewDidUnload {
    [self setPlayWithBluetoothBtn:nil];
    [super viewDidUnload];
}
@end
