//
//  ViewController.m
//  Twitter
//
//  Created by Fumiya Ogawa on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

-(void)configureView
{
    customButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    customButton.frame=CGRectMake(40.0, 100.0, 240.0, 40.0);
    [customButton setTitle:@"つぶやく" forState:UIControlStateNormal];
    customButton.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    customButton.backgroundColor=[UIColor clearColor];
    [customButton addTarget:self action:@selector(sendTweet:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(canTweetStatus) name:ACAccountStoreDidChangeNotification object:nil];
    
}

-(void)canTweetStatus
{
    if([TWTweetComposeViewController canSendTweet]){
        customButton.enabled=YES;
    }else{
        customButton.enabled=NO;
    }
    
}

-(void)sendTweet:withStoring
{
    TWTweetComposeViewController *tweetViewController=[[TWTweetComposeViewController alloc]init];
    [tweetViewController setInitialText:[NSString stringWithFormat:@"%@ #sarudeki",withStoring]];
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result){
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                [self dismissModalViewControllerAnimated:YES];
                break;
            case TWTweetComposeViewControllerResultDone:
                [self dismissModalViewControllerAnimated:YES];
                break;
                
            default:
                break;
        }
    }];
    [self presentModalViewController:tweetViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
