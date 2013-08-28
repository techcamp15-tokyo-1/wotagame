//
//  ResultLayer.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/27.
//  Copyright (c) 2013年 wotagineer. All rights reserved.
//

#import "ResultLayer.h"

@implementation ResultLayer

CCLayer *layerBackGround;

CCLayer *layerResult;
	CCLabelTTF *labelResult;
	CCSprite *labelResultLogo;
	UIButton *btnBackToMenu;

PlayController *playController;

#ifdef ISDEBUG
CCLabelTTF *labelInfo;
#endif

//初期化
+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	playController = [PlayController getInstance];
	ResultLayer *layer = [ResultLayer node];
	
	[layer initializeFirst];
	[scene addChild: layer];
	return scene;
}
-(id) initializeFirst {
	
	//スプライトセット読み込み
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cell.plist"];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	float cx = winSize.width/2;
	float cy = winSize.height/2;
	
	//---------------------------------------------------------------------------------------------------------
	//背景レイヤー
	layerBackGround = [CCLayer node];
	layerBackGround.position =  ccp(cx, cy);
	layerBackGround.scale = min(winSize.width / layerBackGround.contentSize.width, winSize.height / layerBackGround.contentSize.height);
	[self addChild:layerBackGround z: Z_BackGround];
	
	NSString *path = [playController getMeta].backgroundPath;
	CCSprite *spriteBG = [[CCSprite alloc] init];
	[layerBackGround addChild: spriteBG];
	[spriteBG removeFromParent];
	[spriteBG initWithFile:path];
	spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
	[layerBackGround addChild: spriteBG];
	
	//---------------------------------------------------------------------------------------------------------
	//結果画面レイヤー
	layerResult = [CCLayer node];
	layerResult.position = ccp(cx, cy);
	layerResult.scale = min(winSize.width / layerResult.contentSize.width, winSize.height / layerResult.contentSize.height);
	[self addChild:layerResult z: Z_Result];
	
	//結果画面背景
	CCSprite *spriteResultBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spriteResultBG.scaleX = winSize.width / spriteResultBG.contentSize.width + 0.1;
	spriteResultBG.scaleY = winSize.height / spriteResultBG.contentSize.height + 0.1;
	[layerResult addChild: spriteResultBG];
	
	//結果画面のロゴ
	labelResultLogo = [CCSprite spriteWithSpriteFrameName:@"labelResultLogo.png"];
	labelResultLogo.position = ccp(0, 100);
	labelResultLogo.scale = cx / winSize.width;
	[layerResult addChild:labelResultLogo];
	
	//結果ラベル
	labelResult = [CCLabelTTF labelWithString:@"・PERFECT 〜 OK の各回数\n・最大コンボ数\n・合計得点\nをここに表示する予定"
									 fontName:FONT_NAME
									 fontSize:12
								   dimensions:winSize
								   hAlignment:kCCTextAlignmentCenter
								   vAlignment:kCCTextAlignmentCenter];
	labelResult.color = ccc3(255, 255, 255);
	labelResult.contentSize = winSize;
	
	labelResult.fontSize = 12;
	labelResult.position = ccp(0, 0);
	[layerResult addChild:labelResult];
	
	//戻る
	UIView *view = [CCDirector sharedDirector].view;
	CGRect viewRect = [view bounds];
	btnBackToMenu = [[UIButton alloc] initWithFrame:CGRectMake(0, viewRect.size.height/2, viewRect.size.width, viewRect.size.height/2)];
	[btnBackToMenu addTarget:self action:@selector(btnBackToMenuTapped) forControlEvents:UIControlEventTouchUpInside];
	[btnBackToMenu setTitle:@"メニューへ戻る" forState:UIControlStateNormal];
	[view addSubview:btnBackToMenu];

	//---------------------------------------------------------------------------------------------------------
	//デバッグ用のラベル
#ifdef ISDEBUG
	labelInfo = [CCLabelTTF labelWithString:@""
								   fontName:FONT_NAME
								   fontSize:12
								 dimensions:winSize
								 hAlignment:kCCTextAlignmentLeft
								 vAlignment:kCCTextAlignmentLeft];
	
	labelInfo.color = ccc3(0, 64, 128);
	labelInfo.contentSize = winSize;
	labelInfo.position = ccp(cx + 10, cy - 10);
	[self addChild: labelInfo z:100000];
#endif
	
	return self;
}
-(void) btnBackToMenuTapped {
	[SEPlayer play:SE_TYPE_OK];
	[btnBackToMenu removeFromSuperview];
	[playController stop];
	
	CCScene *scene = [MusicSelectLayer scene];
	id transition = [CCTransitionFade transitionWithDuration:1.0f scene:scene];
	[[CCDirector sharedDirector] replaceScene:transition];
}

@end
