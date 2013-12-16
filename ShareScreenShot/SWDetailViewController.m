//
//  SWDetailViewController.m
//  ShareScreenShot
//
//  Created by Snow on 12/16/13.
//  Copyright (c) 2013 RbBtSn0w. All rights reserved.
//

#import "SWDetailViewController.h"
#import "SWShareScreenShot.h"

@interface SWDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SWDetailViewController

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
	// Do any additional setup after loading the view.
//    if (self.image) {
//        self.imageView.image = self.image;    
//    }
    
    
    UIImage *image = [[SWShareScreenShot shareManager].images objectForKey:@"SWShareViewController"];
    
    if (image) {
        self.imageView.image = image;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
