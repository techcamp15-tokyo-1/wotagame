//
//  SEPlayer.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/28.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "SEPlayer.h"

@implementation SEPlayer

static AVAudioPlayer *playerOK;
static AVAudioPlayer *playerSelect;

+(void)initialize {
	NSString *path;
	NSURL *url;
	
	path = [[NSBundle mainBundle] pathForResource:@"ok" ofType:@"mp3"];
	url = [NSURL fileURLWithPath:path];
	playerOK = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[playerOK prepareToPlay];
	[playerOK setVolume:0.6];

	path = [[NSBundle mainBundle] pathForResource:@"select" ofType:@"mp3"];
	url = [NSURL fileURLWithPath:path];
	playerSelect = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	[playerSelect prepareToPlay];
	[playerOK setVolume:0.6];
}

+(void)play:(enum SE_TYPE)type{
	switch (type) {
		case SE_TYPE_OK:
			[playerOK play];
			break;
			
		case SE_TYPE_SELECT:
			[playerSelect play];
			break;
			
		default:
			break;
	}
}
@end
