//
//  RankingScene.m
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/24.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "RankingScene.h"

@implementation RankingScene

- (id)init {
	[super init];
	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cell.plist"];
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGPoint center = ccp(winSize.width/2,winSize.height/2);

	/*----------------------------------------------------------------------------
	 Background
	 ----------------------------------------------------------------------------*/
	CCLayer *layerBackground;
	layerBackground = [CCLayer node];
	layerBackground.position = center;
	[self addChild:layerBackground];
	
	CCSprite *spriteBG;
	spriteBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
	[layerBackground addChild: spriteBG];
	
	/*----------------------------------------------------------------------------
	 Wave
	 ----------------------------------------------------------------------------*/
	layerWave = [WaveLayer node];
	layerWave.position = center;
	[self addChild:layerWave];
	
	/*----------------------------------------------------------------------------
	 Main layer
	 ----------------------------------------------------------------------------*/
	CCLayer *layerMain;
	layerMain = [CCLayer node];
	layerMain.position = center;
	[self addChild:layerMain];
	
	/* Scene Title Label */
	CCLabelTTF *labelTitle = [CCLabelTTF labelWithString:@"ランキング"
												fontName:FONT_NAME
												fontSize:14
											  dimensions:winSize
											  hAlignment:kCCTextAlignmentLeft
											  vAlignment:kCCVerticalTextAlignmentCenter];
	labelTitle.color = ccc3(255, 255, 255);
	labelTitle.contentSize = winSize;
	labelTitle.position = ccp(10, winSize.height/2 - 10 - 7);
	[layerMain addChild:labelTitle];

	CCLabelTTF* label;
	label = [CCLabelTTF labelWithString:@"今後実装する予定です。" fontName:FONT_NAME fontSize:16];
	label.color = ccc3(255, 255, 255);
	label.position = center;
	[self addChild:label];

	/*----------------------------------------------------------------------------
	 Menu
	 ----------------------------------------------------------------------------*/
	//Button back to Top
	CCButton* btnBackToTop;
	btnBackToTop = [CCButton button:@"btnBackToTitle.png" selectedSprite:@"btnBackToTitle_tapped.png"];
	[btnBackToTop setTapEvent:self toSelector:@selector(btnBackToTopTapped)];
	btnBackToTop.scale = (winSize.width/2 - 20) / btnBackToTop.contentSize.width;
	[btnBackToTop setPosition:ccp(winSize.width/4, 20+btnBackToTop.contentSize.height/2)];
	
	//Menu container
	CCMenu* menu;
	menu = [CCMenu menuWithItems:btnBackToTop, nil];
	menu.position = ccp(0, 0);
	[self addChild:menu];
	
	[self scheduleUpdate];
	return self;
}

/*----------------------------------------------------------------------------
 Event Listeners
 ----------------------------------------------------------------------------*/

-(void) update:(ccTime)dt {
	[layerWave update];
}

-(void) btnBackToTopTapped{
	[self unscheduleUpdate];
	[SEPlayer play:SE_TYPE_CANCEL];
	[self fadeTo:[TopMenuScene node]];
}

@end
