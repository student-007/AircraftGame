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

@property (nonatomic, strong) AChattingViewController *chatVC;

@end

@implementation AViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.organizer = [[AGameOrganizer alloc] init];
//    self.chatVC = [self.organizer getChatVC];
//    CGRect chatViewFrame = self.chatVC.view.frame;
//    chatViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - chatViewFrame.size.height;
//    self.chatVC.view.frame = chatViewFrame;
//    [self.view addSubview:self.chatVC.view];
    
//    [self.organizer makeConnectionWithType:ConnectionTypeBluetooth];
    self.testLabel.userInteractionEnabled = YES;
    
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
//    pan.delegate = self;
//    [self.testImageView addGestureRecognizer:pan];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
//    tap.delegate = self;
//    [self.testImageView addGestureRecognizer:tap];
    
}
- (IBAction)testBtnClicked:(id)sender
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(timerDone) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)timerDone
{
    NSLog(@"timer done.");
}

- (IBAction)tapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"tapped!");
}

- (IBAction)panGesture:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translate = [sender translationInView:self.view];
        
        CGRect newFrame = self.testLabel.frame;
        newFrame.origin.x += translate.x;
        newFrame.origin.y += translate.y;
        self.testLabel.frame = newFrame;
        
        [sender setTranslation:CGPointZero inView:self.view];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
    [self setTestImageView:nil];
    [super viewDidUnload];
}
@end
