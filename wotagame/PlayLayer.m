//
//  PlayLayer.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/21.
//  Copyright 2013年 wotagineer. All rights reserved.
//

#import "PlayLayer.h"

@implementation PlayLayer
const int Z_BG = 0;
const int Z_AB = 5;	//AB : Action Batch
const int Z_UI = 10;
const int Z_MENU = 50;
const int Z_PAUSE = 1000;
NSString *FONT_NAME = @"HiraKakuProN-W6";

CCLayer *layerBackGround;
CCSpriteBatchNode *tapActionBatch;
	NSMutableArray *cells;
CCMenu *menu;
	CCMenuItem *btnPause;
	CCMenuItem *btnStart;
CCLayer *layerPause;

PlayController *playController;

#ifdef ISDEBUG
	CCLabelTTF *labelInfo;
#endif


NSMutableArray *tapActionFrames;
CCAnimation *tapAnimation;

//初期化
+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	PlayLayer *layer = [PlayLayer node];
	
	playController = [PlayController getInstance];
	[playController setPlayLayer:layer];

	[layer initialize];
	[scene addChild: layer];
	return scene;
}

//シーン初期化
-(id) initialize {

	//スプライトセット読み込み
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cell.plist"];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	float cx = winSize.width/2;
	float cy = winSize.height/2;
	//背景レイヤー
	layerBackGround = [CCLayer node];
	layerBackGround.position =  ccp(cx, cy);
	layerBackGround.scale = min(winSize.width / layerBackGround.contentSize.width, winSize.height / layerBackGround.contentSize.height);
	[self addChild:layerBackGround z: Z_BG];
	
	//ポーズ画面レイヤー
	layerPause = [CCLayer node];
	layerPause.position = ccp(cx, cy);
	layerPause.scale = min(winSize.width / layerPause.contentSize.width, winSize.height / layerPause.contentSize.height);
	[layerPause setVisible: NO];
	[self addChild:layerPause z: Z_PAUSE];
	
	//ポーズ画面背景
	CCSprite *spritePauseBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spritePauseBG.scaleX = winSize.width / spritePauseBG.contentSize.width + 0.1;
	spritePauseBG.scaleY = winSize.height / spritePauseBG.contentSize.height + 0.1;
	[layerPause addChild: spritePauseBG];
	
	//ポーズボタン
	btnPause = [CCMenuItemSprite itemWithNormalSprite:[CCSprite  spriteWithSpriteFrameName:@"btnPause.png"]
									   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btnPause.png"]
									   disabledSprite:[CCSprite spriteWithSpriteFrameName:@"btnPause.png"]
											   target:playController
											 selector:@selector(btnPauseTapped:)];
	btnPause.position = ccp(cx - btnPause.contentSize.width / 2 - 20, cy - btnPause.contentSize.height / 2 - 20);
	[btnPause setVisible:NO];
	
	//スタートボタン
	btnStart = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btnPlay.png"]
									   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btnPlay.png"]
									   disabledSprite:[CCSprite spriteWithSpriteFrameName:@"btnPlay.png"]
											   target:playController
											 selector:@selector(btnStartTapped:)];
	btnStart.position = ccp(0, 0);
		
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
		
	//メニュー
	menu = [CCMenu menuWithItems:
			btnStart,
			btnPause, nil];
	menu.position =  ccp(cx, cy);
	[self addChild:menu z:Z_MENU];

	//アクションノードバッチ
	CCSpriteBatchNode *tapActionBatch = [CCSpriteBatchNode batchNodeWithFile:@"cell.png"];
	[self addChild:tapActionBatch z: Z_AB];
		
	tapActionFrames = [NSMutableArray array];
	[tapActionFrames retain];
	for (int i=1; i<=16; i++) {
		[tapActionFrames addObject:
		 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
		[NSString stringWithFormat:@"gauge%02d.png",i]]];
	}
		
	//セル
	cells = [[NSMutableArray alloc] init];
	CCSprite *sprite;
	float spriteWidth = winSize.width/3;
	float spriteHeight = winSize.height/3;
	for(int i = 0; i <= 8; i++) {
		sprite = [CCSprite spriteWithSpriteFrameName:@"gauge01.png"];
		sprite.position = ccp(cx + spriteWidth * (i%3-1), cy + spriteHeight * (i/3 - 1));
		sprite.scaleX = spriteWidth / sprite.contentSize.width;
		sprite.scaleY = spriteHeight / sprite.contentSize.height;
		sprite.tag = i;
		
		[tapActionBatch addChild:sprite];
		[cells addObject:sprite];
	}
	
	[self schedule:@selector(update:)];
	self.touchEnabled = YES;
	
	return self;
}

//ゲーム開始準備
-(void)prepareStart:(ScoreMeta)meta {
	//	//背景の準備
	//	if ([[NSFileManager defaultManager] fileExistsAtPath:path_bg]) {
	//		CCSprite *spriteBG = [CCSprite spriteWithFile:path_bg];
	//
	//		CGSize winSize = [[CCDirector sharedDirector] winSize];
	//		spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	//		spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
	//		[layerBackGround addChild: spriteBG];
	//	}
	//	[self initializeToStart];
	//
	//	//アニメーションの準備
	//	tapAnimation = [CCAnimation animationWithSpriteFrames:tapActionFrames delay:60.0f / 149 / 16];
	//	[tapAnimation retain];
	//
	//	//UIの準備
	//	[btnPause setVisible:YES];
	//	[btnStart setVisible:NO];
	//	[layerPause setVisible:NO];
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
	float b = [playController getBeat];
	[labelInfo setString:[NSString stringWithFormat:@"fps: %d \nbeat:%1.3f \nScore:%d", [self getFPS], b, playController.score]];
}
#endif

//シーン更新処理
-(void) update:(ccTime)dt {
	
	#ifdef ISDEBUG
	//ラベルの更新
	[self updateInfoLabel];
	#endif
	
	if (!playController.isPlaying) return;
	//時間切れノードを非表示に戻す
	
	//新しく現れたノードを表示する
	NSMutableArray *showNodeList = [playController getShowNodeList];
	for (ScoreNode *node in showNodeList) {
		if (!node.isShowed) {
			node.isShowed = true;
			NSArray *tags = [node.value componentsSeparatedByString:@","];
			int cell_id = ((NSString *)tags[0]).intValue;
			CCSprite *cell = cells[cell_id];
		
			[cell stopAllActions];
			
			[cell runAction:[CCSequence actions:[CCAnimate actionWithAnimation: tapAnimation],[CCCallFuncND actionWithTarget:self selector:@selector(hideActionCell:)	data:nil], nil]];
		}
	}
}

//セルを初期状態に戻す
-(void) hideActionCell: (CCSprite *)cell {
	[cell setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gauge01.png"]];
}

//一時停止
-(void)pause {
	[layerPause setVisible:YES];
	[btnPause setVisible:NO];
}

//イベントハンドラを登録
-(void) registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:playController priority:0 swallowsTouches:YES];
}

//タッチされた
/*- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
 
 CGPoint touchPos = [touch locationInView:[touch view]];
 touchPos = [[CCDirector sharedDirector] convertToGL:touchPos];
 
 if (controller.isPlaying) {
 //ゲームプレイ中
 float beat = [controller getBeat];
 
 for (CCSprite *cell in cells) {
 if(CGRectContainsPoint(cell.boundingBox, touchPos)) {
 [controller onTouchBegan:beat ofCellID:cell.tag];
 break;
 }
 }
 } else {
 if (controller.isLoaded) {
 //一時停止時
 if(CGRectContainsPoint(layerPause.boundingBox, touchPos)) {
 [self restart];
 }
 } else {
 //ゲーム開始時
 [self start];
 }
 }
 
 return YES;
 }*/

@end
