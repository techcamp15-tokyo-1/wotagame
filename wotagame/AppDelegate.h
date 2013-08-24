//
//  AppDelegate.h
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/21.
//  Copyright wotagineer 2013年. All rights reserved.
//
//	アプリのエントリポイント
#import <UIKit/UIKit.h>
#import "cocos2d.h"

#define ISDEBUG ;

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;

	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (readonly) CCDirectorIOS *director;

@end