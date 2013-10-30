//
//  SettingScene.m
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/24.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "SettingScene.h"

@implementation SettingScene

-(id) init {
	[super init];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGPoint center = ccp(winSize.width/2, winSize.height/2);
	
	/*----------------------------------------------------------------------------
	 Background
	 ----------------------------------------------------------------------------*/
	CCLayer* layerBackground;
	layerBackground = [CCLayer node];
	layerBackground.position = center;
	[self addChild:layerBackground];
	
	CCSprite *spriteBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
	[layerBackground addChild: spriteBG];
	
	/*----------------------------------------------------------------------------
	 Wave
	 ----------------------------------------------------------------------------*/
	layerWave = [WaveLayer node];
	layerWave.position = center;
	[self addChild: layerWave];
	
	/*----------------------------------------------------------------------------
	 Menu
	 ----------------------------------------------------------------------------*/
	//Button re-install preset data
	CCLabelTTF *label = [CCLabelTTF labelWithString:@"楽曲データの再インストール" fontName:FONT_NAME fontSize:20];
	label2 = [CCLabelTTF labelWithString:@"アプリに初めから入っている楽曲データを再インストールします。" fontName:FONT_NAME fontSize:12];
	label2.position = ccp(label.boundingBox.size.width/2, -20);
	
	CCButton* btnReInstallPresetData;
	btnReInstallPresetData =[CCMenuItemLabel itemWithLabel:label target:self selector:@selector(btnReInstallTapped)];
	[btnReInstallPresetData addChild:label2];
	[btnReInstallPresetData setPosition:center];
	
	//Button back to TopMenu
	CCButton* btnBackToTop;
	btnBackToTop = [CCButton button:@"btnBackToTitle.png" selectedSprite:@"btnBackToTitle_tapped.png"];
	[btnBackToTop setTapEvent:self toSelector:@selector(btnBackToTopTapped)];
	btnBackToTop.scale = (winSize.width/2 - 20) / btnBackToTop.contentSize.width;
	[btnBackToTop setPosition:ccp(winSize.width/4, 20+btnBackToTop.contentSize.height/2)];
	
	//Menu container
	CCMenu* menu;
	menu = [CCMenu menuWithItems:btnBackToTop, btnReInstallPresetData, nil];
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

-(void) btnReInstallTapped{
	[label2 setString:@"しばらくお待ちください"];
	[SEPlayer play:SE_TYPE_SELECT];
	
	[[ScoreFileManager manager] installZipFile];
	
	[SEPlayer play:SE_TYPE_OK];
	[label2 setString:@"インストールが完了しました"];
}

@end
