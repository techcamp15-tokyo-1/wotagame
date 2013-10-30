//
//  SEPlayer.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/28.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "SEPlayer.h"

@implementation SEPlayer

static AVAudioPlayer *playerOK;
static AVAudioPlayer *playerCancel;
static AVAudioPlayer *playerSelect;
static AVAudioPlayer *playerBgmMenu;

+(void)initialize {
	NSString *path;
	NSURL *url;
	
	path = [[NSBundle mainBundle] pathForResource:@"ok" ofType:@"mp3"];
	url = [NSURL fileURLWithPath:path];
	playerOK = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[playerOK prepareToPlay];
	[playerOK setVolume:0.6];

	path = [[NSBundle mainBundle] pathForResource:@"cancel" ofType:@"mp3"];
	url = [NSURL fileURLWithPath:path];
	playerCancel = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[playerCancel prepareToPlay];
	[playerCancel setVolume:0.6];

	path = [[NSBundle mainBundle] pathForResource:@"select" ofType:@"mp3"];
	url = [NSURL fileURLWithPath:path];
	playerSelect = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[playerSelect prepareToPlay];
	[playerOK setVolume:0.6];

	path = [[NSBundle mainBundle] pathForResource:@"bgm_menu" ofType:@"mp3"];
	url = [NSURL fileURLWithPath:path];
	playerBgmMenu = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[playerBgmMenu prepareToPlay];
	[playerBgmMenu setVolume:0.15];
}

+(void)play:(enum SE_TYPE)type{
	switch (type) {
		case SE_TYPE_BGM_MENU:
			[playerBgmMenu play];
			break;
			
		case SE_TYPE_OK:
			[playerOK play];
			break;
			
		case SE_TYPE_CANCEL:
			[playerCancel play];
			break;

		case SE_TYPE_SELECT:
			[playerSelect play];
			break;
			
		default:
			break;
	}
}

+(void)stop:(enum SE_TYPE)type{
	switch (type) {
		case SE_TYPE_BGM_MENU:
			[playerBgmMenu stop];
			break;
			
		case SE_TYPE_OK:
			[playerOK stop];
			break;
			
		case SE_TYPE_SELECT:
			[playerSelect stop];
			break;
			
		default:
			break;
	}
}
@end
