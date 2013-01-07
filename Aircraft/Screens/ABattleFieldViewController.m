//
//  ABattleFieldViewController.m
//  Aircraft
//
//  Created by Yufei Lang on 1/1/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import "ABattleFieldViewController.h"

@interface ABattleFieldViewController ()

@property (strong, nonatomic) NSMutableArray *aircraftModelAry;

@end

@implementation ABattleFieldViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setView:nil];
    [super viewDidUnload];
}

- (BOOL)checkPositionForAircraft:(AAircraftModel *)aircraft
{
    
}

- (BOOL)addAircraft:(AAircraftModel *)aircraft error:(NSError **)error
{
    
}

- (BOOL)removeAircraft:(AAircraftModel *)aircraft error:(NSError **)error
{
    
}

/*!
 @discussion return the defined string: kAttackRMiss kAttackRHit kAttackRDestroy. points are row and col(intgers value)
 */
- (NSString *)attackResultInGridAtPoint:(CGPoint)point
{
    
}
@end
