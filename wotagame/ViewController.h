//
//  ViewController.h
//  Twitter
//
//  Created by Fumiya Ogawa on 2013/08/22.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//


/* Twitter用のフレームワークインストール*/
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface ViewController : UIViewController
{
    UIButton *customButton;
    
}

-(void)configureView;
-(void)canTweetStatus;
-(void)sendTweet;

@end
