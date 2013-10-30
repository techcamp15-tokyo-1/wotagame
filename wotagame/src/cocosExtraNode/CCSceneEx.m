//
//  CCSceneEx.m
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/24.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "CCSceneEx.h"

@implementation CCSceneEx

-(void)fadeTo:(CCScene *)scene {
	id transition = [CCTransitionFade transitionWithDuration:TRANSITION_DURATION_TIME scene:scene];
	[[CCDirector sharedDirector] replaceScene:transition];
}

@end
