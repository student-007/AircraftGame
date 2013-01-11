//
//  APlayScreenViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 1/10/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "APlayScreenViewController.h"

@interface APlayScreenViewController ()

@end

@implementation APlayScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.organizer = [AGameOrganizer sharedInstance];
    
    [self setupBattleFields];
    [self setupChattingField];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
}

#pragma mark - setup battle fields

- (void)setupBattleFields
{
    self.battleFldEnemy = [self.organizer getBattleFieldVCFaction:BattleFieldEnemy];
    self.battleFldSelf = [self.organizer getBattleFieldVCFaction:BattleFieldSelf];
    
    self.scrollView.pagingEnabled = YES; // enable paging [Yufei Lang 4/5/2012]
    self.scrollView.showsHorizontalScrollIndicator = NO; // disable scroll indicator [Yufei Lang 4/5/2012]
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.scrollView setDelegate:self]; // set delegate to self in order to respond scroll actions [Yufei Lang 4/5/2012]
    self.scrollView.contentSize = CGSizeMake(self.battleFldEnemy.view.bounds.size.width + self.battleFldSelf.view.bounds.size.width, 1);
    [self loadPage:self.battleFldEnemy.view toScrollView:self.scrollView]; // load my/enemy field into scroll view [Yufei Lang 4/5/2012]
    [self loadPage:self.battleFldSelf.view toScrollView:self.scrollView];
    [self.view addSubview:self.scrollView];
}

- (void)loadPage:(UIView *)viewPage toScrollView: (UIScrollView *)scrollView
{
    int iPageCount = scrollView.subviews.count;
    viewPage.frame = CGRectMake(viewPage.bounds.size.width * iPageCount, 0, viewPage.bounds.size.width, viewPage.bounds.size.height);
    [scrollView addSubview:viewPage];
}

#pragma mark - setup chatting view

- (void)setupChattingField
{
    self.chatVC = [self.organizer getChatVC];
    
    CGRect chatViewFrame = self.chatVC.view.frame;
    chatViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height - 20 - chatViewFrame.size.height;
    self.chatVC.view.frame = chatViewFrame;
    [self.view addSubview:self.chatVC.view];
}


@end
