//
//  SWViewController.m
//  ShareScreenShot
//
//  Created by Snow on 12/16/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import "SWViewController.h"
#import "SWDetailViewController.h"
#import "SWShareScreenShot.h"

@interface SWViewController ()

@end

@implementation SWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    [[SWShareScreenShot shareManager] keepImageByCurrentViewController:self withName:@"SWShareViewController"];
    
}


@end
