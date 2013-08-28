//
//  menu.m
//  wotagame
//
//  Created by Fumiya Ogawa on 2013/08/28.
//  Copyright 2013年 wotagineer. All rights reserved.
//
#import "TopMenuLayer.h"

UIView *view;
UIButton *btnGameStart;
UIButton *btnMovie;
UIButton *btnRanking;
UIButton *btnSetting;
UIButton *btnTwitter;
CCLayer *layerBackGround;

@implementation TopMenuLayer

+(CCScene *) scene{
	CCScene *scene = [CCScene node];
	TopMenuLayer *layer = [TopMenuLayer node];
	
	[layer initialize];
	[scene addChild:layer];
	return scene;
}

- (id)initialize {
	//スプライトセット読み込み
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cell.plist"];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	float cx = winSize.width/2;
	float cy = winSize.height/2;
	
	view = [CCDirector sharedDirector].view;
	CCSprite *sp;
	
	//---------------------------------------------------------------------------------------------------------
	//背景レイヤー
	layerBackGround = [CCLayer node];
	layerBackGround.position =  ccp(cx, cy);
	layerBackGround.scale = min(winSize.width / layerBackGround.contentSize.width, winSize.height / layerBackGround.contentSize.height);
	[self addChild:layerBackGround];
	
	//背景スプライト
	CCSprite *spriteBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
	[layerBackGround addChild: spriteBG];
	
	//---------------------------------------------------------------------------------------------------------
	//GAMESTARTボタン設定
	UIButton *btnGameStart = [[UIButton alloc] initWithFrame:CGRectMake(winSize.width/3, 0, winSize.width/3, winSize.height/2)];
	sp = [CCSprite spriteWithSpriteFrameName:@"GAMESTART2.png"];
	[btnGameStart setImage:[self renderUIImageFromSprite:sp] forState:UIControlStateNormal];
	[view addSubview:btnGameStart];
	[btnGameStart addTarget:self action:@selector(btnGameStartTapped) forControlEvents:UIControlEventTouchUpInside];
	
	//---------------------------------------------------------------------------------------------------------
	//MOVIEボタン設定
	UIButton *btnMovie = [[UIButton alloc] initWithFrame:CGRectMake(winSize.width/3, winSize.height/2, winSize.width/3, winSize.height/2)];
	sp = [CCSprite spriteWithSpriteFrameName:@"MOVIE2.png"];
	[btnMovie setImage:[self renderUIImageFromSprite:sp] forState:UIControlStateNormal];
	[view addSubview:btnMovie];

	//---------------------------------------------------------------------------------------------------------
	//RANKINGボタン設定
	UIButton *btnRanking = [[UIButton alloc] initWithFrame:CGRectMake(winSize.width/3*2, 0, winSize.width/3, winSize.height/2)];
	sp = [CCSprite spriteWithSpriteFrameName:@"RANKING2.png"];
	[btnRanking setImage:[self renderUIImageFromSprite:sp] forState:UIControlStateNormal];
	[view addSubview:btnRanking];

	//---------------------------------------------------------------------------------------------------------
	//SETTINGボタン設定
	UIButton *btnSetting = [[UIButton alloc] initWithFrame:CGRectMake(winSize.width/3*2, winSize.height/2, winSize.width/3, winSize.height/2)];
	sp = [CCSprite spriteWithSpriteFrameName:@"SETTING2.png"];
	[btnSetting setImage:[self renderUIImageFromSprite:sp] forState:UIControlStateNormal];
	[view addSubview:btnSetting];

//	//---------------------------------------------------------------------------------------------------------
//	//TWITTERボタン設定
//	UIButton *btnSNS = [[UIButton alloc] initWithFrame:CGRectMake(winSize.width/3*2, 0, winSize.width/3, winSize.height/2)];
//	sp = [CCSprite spriteWithSpriteFrameName:@"TWITTERtag2.png"];
//	[btnSNS setImage:[self renderUIImageFromSprite:sp] forState:UIControlStateNormal];
//	[view addSubview:btnSNS];
//
	//---------------------------------------------------------------------------------------------------------
	//ACTIONボタン設定
	UIButton *btnAction = [[UIButton alloc] initWithFrame:CGRectMake(0, winSize.height/4, winSize.width/3, winSize.height/2)];
	sp = [CCSprite spriteWithSpriteFrameName:@"logoAction.png"];
	[btnAction setImage:[self renderUIImageFromSprite:sp] forState:UIControlStateNormal];
	[view addSubview:btnAction];
	
	view.
	return self;
}

-(UIImage *)renderUIImageFromSprite:(CCSprite *)sprite {
	
	int tx = sprite.contentSize.width;
	int ty = sprite.contentSize.height;
	
	CCRenderTexture *renderer = [CCRenderTexture renderTextureWithWidth:tx height:ty];
	
	sprite.anchorPoint  = CGPointZero;
	
	[renderer begin];
	[sprite visit];
	[renderer end];
	
	UIImage *image = [renderer getUIImageFromBuffer];
	return [image stretchableImageWithLeftCapWidth:1 topCapHeight:1];
}

//現在のUIをすべて削除
-(void) removeAllSubView {
	view = [CCDirector sharedDirector].view;
	while ([view subviews].count) {
		[[view subviews][0] removeFromSuperview];
	}
}

-(void) btnGameStartTapped {
	[SEPlayer play:SE_TYPE_SELECT];
	
	//遷移の準備
	[self removeAllSubView];
	
	//遷移
	CCScene *scene = [MusicSelectLayer scene];
	id transition = [CCTransitionScene transitionWithDuration:0 scene:scene];
	[[CCDirector sharedDirector] replaceScene:transition];
}
@end
