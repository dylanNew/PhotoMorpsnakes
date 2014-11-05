//
//  BZViewController.m
//  MorphSnakes
//
//  Created by myname on 14-11-5.
//  Copyright (c) 2014年 Bouzou. All rights reserved.
//

#import "BZViewController.h"
#import "BZImageReader.h"

@interface BZViewController ()

@end

@implementation BZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    BZImageReader *reader = [[BZImageReader alloc] init];
    [reader setImg:[UIImage imageNamed:@"seastar2.png"]];
    [imageView setImage:[reader getGrayImage]];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
