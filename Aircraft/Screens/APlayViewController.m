//
//  APlayViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 1/1/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "APlayViewController.h"

@interface APlayViewController ()

@property (strong, nonatomic) AGameOrganizer *organizer;
@property (strong, nonatomic)AChattingViewController *chatVC;

- (void)resetAndLoadOrganizer;
- (void)loadChattingView;

@end

@implementation APlayViewController

@synthesize organizer = _organizer;
@synthesize chatVC = _chatVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self resetAndLoadOrganizer];
    [self loadChattingView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetAndLoadOrganizer
{
    if (self.organizer)
        [self.organizer reset];
    self.organizer = [[AGameOrganizer alloc] init];
}

- (void)loadChattingView
{
    self.chatVC = [self.organizer getChatVC];
    CGRect chatViewFrame = _chatVC.view.frame;
    chatViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - chatViewFrame.size.height;
    _chatVC.view.frame = chatViewFrame;
    [self.view addSubview:_chatVC.view];
}

@end
