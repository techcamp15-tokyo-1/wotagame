//
//  TopMenuScene.m
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/24.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "TopMenuScene.h"

@implementation TopMenuScene

-(id) init {
	NSLog(@"%d", [@"9" characterAtIndex:0]);
	[super init];

	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGPoint center = ccp(winSize.width/2, winSize.height/2);
	
	/*----------------------------------------------------------------------------
	 Background
	 ----------------------------------------------------------------------------*/
	CCLayer* layerBackground;
	layerBackground = [CCLayer node];
	layerBackground.position =  center;
	layerBackground.scale = min(winSize.width / layerBackground.contentSize.width, winSize.height / layerBackground.contentSize.height);
	[self addChild:layerBackground];
	
	CCSprite *spriteBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
	[layerBackground addChild: spriteBG];
	
	/*----------------------------------------------------------------------------
	 Wave
	 ----------------------------------------------------------------------------*/
	layerWave = [WaveLayer node];
	layerWave.position =  center;
	[self addChild:layerWave];
	
	/*----------------------------------------------------------------------------
	 Menu
	 ----------------------------------------------------------------------------*/
	//Game start button
	CCButton* btnGameStart;
	btnGameStart = [CCButton button:@"GAMESTART2.png" selectedSprite:@"GAMESTART2_tapped.png"];
	[btnGameStart setTapEvent:self toSelector:@selector(btnGameStartTapped)];
	btnGameStart.scale = (winSize.height/4 - 30) / btnGameStart.contentSize.height;
	[btnGameStart setPosition:ccp(winSize.width * 0.30+ btnGameStart.boundingBox.size.width/2, winSize.height/8*7)];
	
	//Movie button
	CCButton* btnMovie;
	btnMovie = [CCButton button:@"MOVIE2.png" selectedSprite:@"MOVIE2_tapped.png"];
	[btnMovie setTapEvent:self toSelector:@selector(btnMovieTapped)];
	btnMovie.scale = (winSize.height/4 - 30) / btnMovie.contentSize.height;
	[btnMovie setPosition:ccp(winSize.width * 0.35 + btnMovie.boundingBox.size.width/2, winSize.height/8*5)];
	
	//Ranking button
	CCButton* btnRanking;
	btnRanking = [CCButton button:@"RANKING2.png" selectedSprite:@"RANKING2_tapped.png"];
	[btnRanking setTapEvent:self toSelector:@selector(btnRankingTapped)];
	btnRanking.scale = (winSize.height/4 - 30) / btnRanking.contentSize.height;
	[btnRanking setPosition:ccp(winSize.width * 0.40 + btnRanking.boundingBox.size.width/2, winSize.height/8*3)];
	
	//Setting button
	CCButton* btnSetting;
	btnSetting = [CCButton button:@"SETTING2.png" selectedSprite:@"SETTING2_tapped.png"];
	[btnSetting setTapEvent:self toSelector:@selector(btnSettingTapped)];
	btnSetting.scale = (winSize.height/4 - 30) / btnSetting.contentSize.height;
	[btnSetting setPosition:ccp(winSize.width * 0.45 + btnSetting.boundingBox.size.width/2, winSize.height/8)];
	
	//Action button
	CCButton* btnAction;
	btnAction = [CCButton button:@"logoAction.png" selectedSprite:@"logoAction.png"];
	[btnAction setSize:CGSizeMake(winSize.width/3, winSize.height/2)];
	[btnAction setPosition:ccp(winSize.width/6, winSize.height/2)];
	
	//Menu container
	CCMenu* menu;
	menu = [CCMenu menuWithItems:btnAction, btnGameStart, btnMovie, btnRanking, btnSetting, nil];
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

-(void) btnGameStartTapped {
	[self unscheduleUpdate];
	[SEPlayer play:SE_TYPE_SELECT];
	[self fadeTo:[MusicSelectScene node]];
}

-(void) btnSettingTapped {
	[self unscheduleUpdate];
	[SEPlayer play:SE_TYPE_SELECT];
	[self fadeTo:[SettingScene node]];
}

-(void) btnRankingTapped {
	[self unscheduleUpdate];
	[SEPlayer play:SE_TYPE_SELECT];
	[self fadeTo:[RankingScene node]];
}

-(void) btnMovieTapped {
	[self unscheduleUpdate];
	[SEPlayer play:SE_TYPE_SELECT];
	[self fadeTo:[SkillCollectionScene node]];
}

@end
