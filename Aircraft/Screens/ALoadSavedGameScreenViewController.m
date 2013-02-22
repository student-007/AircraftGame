//
//  ALoadSavedGameScreenViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 13-2-20.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import "ALoadSavedGameScreenViewController.h"

@interface ALoadSavedGameScreenViewController()

- (void)loadLocalisedString;
- (void)loadGamesFromRecordMgr;
- (void)loadRecentUnsavedRecords;
- (void)loadSavedGameRecords;

@end

@implementation ALoadSavedGameScreenViewController
@synthesize tableView;
@synthesize recentUnsavedPanel;
@synthesize savedGamePanel;
@synthesize recentUnsavedGameLabel;
@synthesize savedGameLabel;

- (void)loadLocalisedString
{
    self.recentUnsavedGameLabel.text = ALocalisedString(@"recent_unsaved_game");
    self.savedGameLabel.text = ALocalisedString(@"saved_game");
    self.title = ALocalisedString(@"game_records");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.bkgImageView setImage:[UIImage imageForDarkLightRectBackground]];
    
    [self loadLocalisedString];
    
    [self loadGamesFromRecordMgr];
    [self loadRecentUnsavedRecords];
    [self loadSavedGameRecords];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setRecentUnsavedPanel:nil];
    [self setSavedGamePanel:nil];
    [self setRecentUnsavedGameLabel:nil];
    [self setSavedGameLabel:nil];
    [self setTableViewAdapter:nil];
    [self setBkgImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)loadGamesFromRecordMgr
{
    AGameRecordManager *recordMgr = [AGameRecordManager sharedInstance];
    NSArray *recordsArray = [recordMgr loadGameRecordsFromFile];
    if (recordsArray.count > 0)
    {
        _recentUnsavedRecords = [NSMutableArray array];
        _savedRecords = [NSMutableArray array];
    }
    
    for (ASavedGameRecord *record in recordsArray)
    {
        if ([record.isRegularRecord boolValue])
        {
            [_savedRecords addObject:record];
        }
        else
        {
            [_recentUnsavedRecords addObject:record];
        }
    }
}

- (void)loadRecentUnsavedRecords
{
    if (_recentUnsavedRecords)
    {
        if (_recentUnsavedRecords.count > 0)
        {
            [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.recentUnsavedPanel] forKey:@"recentUnsavedPanel" withStyle:ATableViewAdapterPanelStylePlain];
            [self.tableViewAdapter addSection:[ASavedRecordItem class] forKey:@"recentUnsavedRecords" withData:_recentUnsavedRecords target:self action:@selector(userTappedRecord:)];
//            for (ASavedGameRecord *record in _recentUnsavedRecords)
//            {
//                self.tableViewAdapter addView:<#(id<ATableViewAdapterViewDelegate>)#> forKey:<#(NSString *)#> withStyle:<#(ATableViewAdapterPanelStyle)#>
//            }
        }
    }
}

- (void)loadSavedGameRecords
{
    if (_savedRecords)
    {
        if (_savedRecords.count > 0)
        {
            [self.tableViewAdapter addView:[ATableViewAdapterView viewWithView:self.savedGamePanel] forKey:@"savedGamePanel" withStyle:ATableViewAdapterPanelStylePlain];
            [self.tableViewAdapter addSection:[ASavedRecordItem class] forKey:@"savedRecords" withData:_savedRecords target:self action:@selector(userTappedRecord:)];
        }
    }
}

- (void)userTappedRecord:(ASavedRecordItem *)recordItem
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
