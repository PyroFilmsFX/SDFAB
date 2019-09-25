//
//  ViewController.m
//  popOverAppValley
//
//  Created by Justin on 10/2/18.
//  Copyright © 2018 Justin. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    PopOverView *tempView = [[PopOverView alloc] init];
    [tempView getRemote];
    [tempView prePopOver];
}


@end
