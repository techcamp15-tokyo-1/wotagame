//
//  WaveLayer.m
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/23.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "WaveLayer.h"

@implementation WaveLayer

CCSprite* spriteWave11;
CCSprite* spriteWave12;
CCSprite* spriteWave21;
CCSprite* spriteWave22;

-(id) init {
	[super init];
	CGSize winSize = [[CCDirector sharedDirector] winSize];

	spriteWave11 = [CCSprite spriteWithFile:@"wave1.png"];
	spriteWave11.scaleX = winSize.width / spriteWave11.contentSize.width * 1.4;
	spriteWave11.position = ccp(0, -40);
	[self addChild:spriteWave11 z:1];
	
	spriteWave12 = [CCSprite spriteWithFile:@"wave1.png"];
	spriteWave12.scaleX = winSize.width / spriteWave12.contentSize.width * 1.4;
	spriteWave12.position = ccp(0, -40);
	[self addChild:spriteWave12 z:3];
	
	spriteWave21 = [CCSprite spriteWithFile:@"wave2.png"];
	spriteWave21.scaleX = winSize.width / spriteWave21.contentSize.width * 1.4;
	spriteWave21.position = ccp(0, -40);
	[self addChild:spriteWave21 z:2];
	
	spriteWave22 = [CCSprite spriteWithFile:@"wave2.png"];
	spriteWave22.scaleX = winSize.width / spriteWave22.contentSize.width * 1.4;
	spriteWave22.position = ccp(0, -40);
	[self addChild:spriteWave22 z:4];
	
	return self;
}

/* Update wave */
-(void) update {
	[spriteWave11 setPosition:ccp(spriteWave11.position.x - 2.6, spriteWave11.position.y)];
	if (spriteWave11.position.x < -spriteWave11.contentSize.width * spriteWave11.scaleX) spriteWave11.position = spriteWave12.position;
	[spriteWave12 setPosition:ccp(spriteWave11.position.x + spriteWave12.contentSize.width * spriteWave12.scaleX, spriteWave11.position.y)];
	[spriteWave21 setPosition:ccp(spriteWave21.position.x + 2.1, spriteWave21.position.y)];
	if (spriteWave21.position.x > spriteWave21.contentSize.width * spriteWave21.scaleX) spriteWave21.position = spriteWave22.position;
	[spriteWave22 setPosition:ccp(spriteWave21.position.x - spriteWave22.contentSize.width * spriteWave22.scaleX, spriteWave21.position.y)];
}

@end
