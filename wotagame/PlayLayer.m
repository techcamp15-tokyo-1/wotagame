//
//  PlayLayer.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/21.
//  Copyright 2013年 wotagineer. All rights reserved.
//

#import "PlayLayer.h"

@implementation PlayLayer

CCLayer *layerBackGround;

CCLayer *layerPlay;
	CCSpriteBatchNode *tapActionBatch;
		NSMutableArray *cells_result;
		NSMutableArray *cells;

CCLayer *layerFront;
	CCLabelTTF *labelScore;
	CCLabelTTF *labelMusicInfo;

CCMenu *menu;
	CCMenuItem *btnPause;

CCLayer *layerStart;
	CCLabelTTF *labelMusicInfo2;
	CCMenu *menu2;
		CCMenuItem *btnStart;

CCLayer *layerPause;
	CCSprite *labelPauseLogo;
	CCLabelTTF *labelPause;
	CCMenu *menuPause;
		CCMenuItem *btnBackToMenu;
		CCMenuItem *btnReset;

PlayController *playController;

#ifdef ISDEBUG
	CCLabelTTF *labelInfo;
#endif


NSMutableArray *tapActionFrames;
NSMutableArray *resultFrames;

//初期化
+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	PlayLayer *layer = [PlayLayer node];
	
	playController = [PlayController getInstance];
	[playController setPlayLayer:layer];
	[playController initialize];

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
	float spriteWidth;
	float spriteHeight;

	//---------------------------------------------------------------------------------------------------------
	//背景レイヤー
	layerBackGround = [CCLayer node];
	layerBackGround.position =  ccp(cx, cy);
	layerBackGround.scale = min(winSize.width / layerBackGround.contentSize.width, winSize.height / layerBackGround.contentSize.height);
	[self addChild:layerBackGround z: Z_BackGround];
	
	//---------------------------------------------------------------------------------------------------------
	//ポーズ画面レイヤー
	layerPause = [CCLayer node];
	layerPause.position = ccp(cx, cy);
	layerPause.scale = min(winSize.width / layerPause.contentSize.width, winSize.height / layerPause.contentSize.height);
	[layerPause setVisible: NO];
	[self addChild:layerPause z: Z_Pause];
	
	//ポーズ画面背景
	CCSprite *spritePauseBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spritePauseBG.scaleX = winSize.width / spritePauseBG.contentSize.width + 0.1;
	spritePauseBG.scaleY = winSize.height / spritePauseBG.contentSize.height + 0.1;
	[layerPause addChild: spritePauseBG];
	
	//ポーズ画面のロゴ
	labelPauseLogo = [CCSprite spriteWithSpriteFrameName:@"labelPauseLogo.png"];
	labelPauseLogo.position = ccp(0, 0 + 20);
	labelPauseLogo.scale = cx / winSize.width;
	[layerPause addChild:labelPauseLogo];
	
	//ゲームを再開する説明
	labelPause = [CCLabelTTF labelWithString:@"画面をタップすると再開します"
									fontName:FONT_NAME
									fontSize:14
								  dimensions:winSize
								  hAlignment:kCCTextAlignmentCenter
								  vAlignment:kCCTextAlignmentCenter];
	labelPause.color = ccc3(255, 255, 255);
	labelPause.position = ccp(0, 0 - 20);
	[layerPause addChild:labelPause];

	//メニューへ戻るボタン
	btnBackToMenu = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btnBackToMenu.png"]
											selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btnBackToMenu_tapped.png"]
											disabledSprite:[CCSprite spriteWithSpriteFrameName:@"btnBackToMenu.png"]
													target:playController
												  selector:@selector(btnBackToMenuTapped:)];
	btnBackToMenu.position = ccp(-cx + btnBackToMenu.contentSize.width/2,
								 cy - btnBackToMenu.contentSize.height/2);
	
	//やりなおすボタン
	btnReset = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btnReset.png"]
									   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btnReset_tapped.png"]
									   disabledSprite:[CCSprite spriteWithSpriteFrameName:@"btnReset.png"]
											   target:playController
											 selector:@selector(btnRestartTapped:)];
	btnReset.position = ccp(cx - btnReset.contentSize.width/2,
							cy - btnReset.contentSize.height/2);
	
	//一時停止時のメニュー
	menuPause = [CCMenu menuWithItems:
				 btnReset,
				 btnBackToMenu, nil];
	menuPause.position =  ccp(0, 0);
	[layerPause addChild:menuPause];
	
	//---------------------------------------------------------------------------------------------------------
	//フロントレイヤー
	layerFront = [CCLayer node];
	layerFront.position = ccp(cx, cy);
	layerFront.scale = min(winSize.width / layerFront.contentSize.width, winSize.height / layerFront.contentSize.height);
	[self addChild:layerFront z: Z_Front];
	
	//スコア
	labelScore = [CCLabelTTF labelWithString:@""
									fontName:FONT_NAME
									fontSize:12
								  dimensions:winSize
								  hAlignment:kCCTextAlignmentRight
								  vAlignment:kCCTextAlignmentLeft];
	labelScore.color = ccc3(64, 64, 64);
	labelScore.contentSize = winSize;
	labelScore.position = ccp(-10, -10);
	[layerFront addChild:labelScore];

	//曲情報
	labelMusicInfo = [CCLabelTTF labelWithString:@""
										fontName:FONT_NAME
										fontSize:16
									  dimensions:winSize
									  hAlignment:kCCTextAlignmentLeft
									  vAlignment:kCCTextAlignmentRight];
	labelMusicInfo.color = ccc3(96, 96, 96);
	labelMusicInfo.contentSize = winSize;
	labelMusicInfo.fontSize = 12;
	labelMusicInfo.position = ccp(10, 10);
	[layerFront addChild:labelMusicInfo];
	
	//---------------------------------------------------------------------------------------------------------
	//スタート画面レイヤー
	layerStart = [CCLayer node];
	layerStart.position = ccp(cx, cy);
	layerStart.scale = min(winSize.width / layerStart.contentSize.width, winSize.height / layerStart.contentSize.height);
	[self addChild:layerStart z: Z_Front];
	
	//スタート画面背景
	CCSprite *spriteStartBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spriteStartBG.scaleX = winSize.width / spriteStartBG.contentSize.width + 0.1;
	spriteStartBG.scaleY = winSize.height / spriteStartBG.contentSize.height + 0.1;
	[layerStart addChild: spriteStartBG];
	
	//スタートボタン
	btnStart = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btnPlay.png"]
									   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btnPlay_tapped.png"]
									   disabledSprite:[CCSprite spriteWithSpriteFrameName:@"btnPlay.png"]
											   target:playController
											 selector:@selector(btnStartTapped:)];
	btnStart.scale = winSize.width / btnStart.contentSize.width;
	btnStart.position = ccp(0, 0);

	//メニュー
	menu2 = [CCMenu menuWithItems:
			 btnStart, nil];
	spriteStartBG.scaleX = winSize.width / spriteStartBG.contentSize.width + 0.1;
	spriteStartBG.scaleY = winSize.height / spriteStartBG.contentSize.height + 0.1;
	menu2.position =  ccp(0, 0);
	[layerStart addChild:menu2];
	
	//曲情報
	labelMusicInfo2 = [CCLabelTTF labelWithString:@""
										 fontName:FONT_NAME
										 fontSize:12
									   dimensions:winSize
									   hAlignment:kCCTextAlignmentLeft
									   vAlignment:kCCTextAlignmentCenter];
	labelMusicInfo2.color = ccc3(255, 255, 255);
	labelMusicInfo2.contentSize = btnStart.contentSize;
	labelMusicInfo2.position = ccp(20, 0);
	[layerStart addChild:labelMusicInfo2];
	
	//---------------------------------------------------------------------------------------------------------
	//プレイ画面
	layerPlay = [CCLayer node];
	layerPlay.position = ccp(cx, cy);
	layerPlay.scale = min(winSize.width / layerPlay.contentSize.width, winSize.height / layerPlay.contentSize.height);
	[self addChild:layerPlay z: Z_Play];

	//アクションノードバッチ
	CCSpriteBatchNode *tapActionBatch = [CCSpriteBatchNode batchNodeWithFile:@"cell.png"];
	tapActionBatch.position = ccp(-cx, -cy);
	[layerPlay addChild:tapActionBatch];
		
	tapActionFrames = [[NSMutableArray array] retain];
	for (int i=1; i<=40; i++) {
		[tapActionFrames addObject:
		 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
		[NSString stringWithFormat:@"gauge%02d.png", i]]];
	}
		
	resultFrames = [[NSMutableArray array] retain];
	[resultFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gaugeOK.png"]];
	[resultFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gaugeGood.png"]];
	[resultFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gaugeGreat.png"]];
	[resultFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gaugePerfect.png"]];
	[resultFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gaugeMISS.png"]];
	
	CCSprite *sprite;
	spriteWidth = winSize.width/3;
	spriteHeight = winSize.height/3;
	
	//結果表示セル
	cells_result = [[NSMutableArray alloc] init];
	for(int i = 0; i <= 8; i++) {
		sprite = [CCSprite spriteWithSpriteFrame:tapActionFrames[0]];
		sprite.position = ccp(cx + spriteWidth * (i%3-1), cy + spriteHeight * (i/3 - 1));
		sprite.scaleX = spriteWidth / sprite.contentSize.width;
		sprite.scaleY = spriteHeight / sprite.contentSize.height;
		sprite.tag = i;
		[tapActionBatch addChild:sprite];
		[cells_result addObject:sprite];
	}
	
	//アクションセル
	cells = [[NSMutableArray alloc] init];
	for(int i = 0; i <= 8; i++) {
		sprite = [CCSprite spriteWithSpriteFrame:tapActionFrames[0]];
		sprite.position = ccp(cx + spriteWidth * (i%3-1), cy + spriteHeight * (i/3 - 1));
		sprite.scaleX = spriteWidth / sprite.contentSize.width;
		sprite.scaleY = spriteHeight / sprite.contentSize.height;
		sprite.tag = i;
		[tapActionBatch addChild:sprite];
		[cells addObject:sprite];
	}
	
	[self schedule:@selector(update:)];
	self.touchEnabled = YES;
	
	//ポーズボタン
	btnPause = [CCMenuItemSprite itemWithNormalSprite:[CCSprite  spriteWithSpriteFrameName:@"btnPause.png"]
									   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btnPause_tapped.png"]
									   disabledSprite:[CCSprite spriteWithSpriteFrameName:@"btnPause.png"]
											   target:playController
											 selector:@selector(btnPauseTapped:)];
	btnPause.position = ccp(cx - btnPause.contentSize.width/2 - 10, -cy + btnPause.contentSize.height/2 + 10);
	
	//メニュー
	menu = [CCMenu menuWithItems:
			btnPause, nil];
	menu.position =  ccp(0, 0);
	[layerPlay addChild:menu];

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
	
	[self initialize];
	
	return self;
}


//通常の初期化
-(void)initialize {
	ScoreMeta meta = [playController getMeta];
	
	[layerBackGround removeAllChildren];
	[layerPlay setVisible:NO];
	[layerFront setVisible:NO];
	[layerStart setVisible:YES];
	[layerPause setVisible:NO];
	[self setBackGround:meta.backgroundPath];
	
	[labelMusicInfo2 setString:[NSString stringWithFormat:@"%@ \n%@ \n難易度:%d", meta.title, meta.artist, meta.difficulty]];
	
	for (CCSprite *cell in cells) {
		[cell setDisplayFrame:tapActionFrames[0]];
	}
	for (CCSprite *cell in cells_result) {
		cell.opacity = 0;
	}
}

//ゲーム開始準備
-(void)prepareStart {
	//メタ情報を取得する
	ScoreMeta meta = [playController getMeta];
	
	//UIの準備
	[labelMusicInfo setString:[NSString stringWithFormat:@"%@ \n%@ \n難易度:%d", meta.title, meta.artist, meta.difficulty]];
	[layerPlay setVisible:YES];
	[layerFront setVisible:YES];
	[layerStart setVisible:NO];
	[layerPause setVisible:NO];
}

//背景の準備
-(void)setBackGround:(NSString *)path {
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	CCSprite *spriteBG = [[CCSprite alloc] init];
	[layerBackGround addChild: spriteBG];
	[spriteBG removeFromParent];
	[spriteBG initWithFile:path];
	spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
	[layerBackGround addChild: spriteBG];
}

//更新処理
-(void) update:(ccTime)dt {
#ifdef ISDEBUG
	//ラベルの更新
	[self updateInfoLabel];
#endif
	
	if (!playController.isGameStarted) return;
	//コントローラへ通知する
	[playController update];
}

//スコアの更新
-(void) updateScoreLabel {
	[labelScore setString:[NSString stringWithFormat:@"Score: %d", playController.score]];
}

//結果表示セルの更新
-(void) updateResultCell:(int)cellId {
	CCSprite *cell = cells_result[cellId];
	float opacity = cell.opacity;
	cell.opacity = max(opacity - 6, 0);
}

//タップセルの更新
-(void) updateTapCell:(int)cellId atValueOf:(float)stateValue {
	CCSprite *cell = cells[cellId];
	int frameNo = [tapActionFrames count] * stateValue;
	[cell setDisplayFrame:tapActionFrames[frameNo]];
}

#ifdef ISDEBUG
//FPS計算
-(int) getFPS {
	static double time = 0;
	static int _fps = 0;
	static int fps = 0;
	double _time = [[NSDate date] timeIntervalSince1970];
	if (_time - time > 1.0) {
		time = _time;
		fps = _fps;
		_fps = 0;
	}
	_fps++;
	return fps;
}

//情報ラベルを更新する
-(void) updateInfoLabel {
	[labelInfo setString:[NSString stringWithFormat:@"fps: %d \nFilePath:%@ \nbeat:%1.3f \nScore:%d",
						  [self getFPS],
						  playController.scoreMeta.scorePath,
						  [playController getBeat],
						  playController.score]];
}
#endif


//終了
-(void)finish {
	[layerPlay setVisible:NO];
	[layerFront setVisible:NO];
	[layerStart setVisible:NO];
	[layerPause setVisible:NO];
	[[[CCDirector sharedDirector] touchDispatcher] removeAllDelegates];
	[self unscheduleAllSelectors];
}
//一時停止
-(void)pause {
	[layerPause setVisible:playController.isPause];
	[layerPlay setVisible:!playController.isPause];
	[layerFront setVisible:!playController.isPause];
}

//イベントハンドラを登録
-(void) registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:playController priority:0 swallowsTouches:YES];
}

//タッチ成功エフェクト
-(void)setSuccesEffect:(int)cellId result:(enum RESULT)result{
	[self setEffectSuccess:cellId result:result];
	[self setEffectParticle:cellId];
}

//結果表示セルのエフェクト
-(void)setEffectSuccess:(int) cellId result:(enum RESULT)result {
	CCSprite *cell = cells_result[cellId];
	[cell setDisplayFrame:resultFrames[result]];
	cell.opacity = 255;
}

//パーティクルエフェクト
-(void)setEffectParticle:(int) cellId {
    CCParticleSystem * ps = [CCParticleSystemQuad particleWithFile:@"exploding_ring.plist"];;
    ps.sourcePosition = ((CCSprite *)cells[cellId]).position;
    ps.autoRemoveOnFinish = YES;
    [self addChild:ps];
}

//タッチ失敗エフェクト
-(void)setMissEffect: (int)cellID {
	CCSprite *cell = cells_result[cellID];
	[cell setDisplayFrame:resultFrames[RESULT_MISS]];
	cell.opacity = 255;
}

//位置情報からタップされたセルを求める
-(int)pursueTappedCell:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint touchPos = [touch locationInView:[touch view]];
	touchPos = [[CCDirector sharedDirector] convertToGL:touchPos];
	
	for (CCSprite *cell in cells) {
		if (CGRectContainsPoint(cell.boundingBox, touchPos)) return cell.tag;
	}
	return -1;
}
@end
