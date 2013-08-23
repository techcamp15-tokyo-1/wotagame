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
const int Z_PAUSE = 1000å;

NSString *FONT_NAME = @"HiraKakuProN-W6";
NSString *FILE_NAME = @"bgm2";
NSString *FILE_EXT_MUSIC = @"m4a";
NSString *FILE_EXT_SCORE = @"wmf";

CCLayer *layerBackGround;
CCSpriteBatchNode *tapActionBatch;
	NSMutableArray *cells;
CCMenu *menu;
	CCMenuItem *btnPause;
	CCLabelTTF *labelInfo;
CCLayer *layerPause;

PlayController *controller;

NSMutableArray *tapActionFrames;
CCAnimation *tapAnimation;

+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	PlayLayer *layer = [PlayLayer node];
	
	[scene addChild: layer];
	return scene;
}

//シーン初期化
-(id) init {

	if( (self=[super init])) {
		
		//スプライトセット読み込み
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cell.plist"];
		
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		float cx = winSize.width/2;
		float cy = winSize.height/2;

		//背景レイヤー
		layerBackGround = [CCLayer node];
		layerBackGround.position = ccp(winSize.width / 2, winSize.height/ 2);
		layerBackGround.scale = min(winSize.width / layerBackGround.contentSize.width, winSize.height / layerBackGround.contentSize.height);
		[self addChild:layerBackGround z: Z_BG];
		
		//ポーズ画面レイヤー
		layerPause = [CCLayer node];
		layerPause.position = ccp(winSize.width / 2, winSize.height/ 2);
		layerPause.scale = min(winSize.width / layerPause.contentSize.width, winSize.height / layerPause.contentSize.height);
		[layerPause setVisible: NO];
		[self addChild:layerPause z: Z_PAUSE];
		
		//ポーズ画面背景
		CCSprite *spritePauseBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
		spritePauseBG.scaleX = winSize.width / spritePauseBG.contentSize.width + 0.1;
		spritePauseBG.scaleY = winSize.height / spritePauseBG.contentSize.height + 0.1;
		[layerPause addChild: spritePauseBG];
		
		//ポーズボタン
		btnPause = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btnPause.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"btnPause.png"] disabledSprite:[CCSprite spriteWithSpriteFrameName:@"btnPause.png"] target:self selector:@selector(btnPauseTapped:)];
		btnPause.position = ccp(winSize.width / 2 - btnPause.contentSize.width / 2 - 20, winSize.height / 2 - btnPause.contentSize.height / 2 - 20);
		
		//ラベル
		labelInfo = [CCLabelTTF labelWithString:@"" fontName:FONT_NAME fontSize:12];
		labelInfo.color = ccc3(255, 255, 255);
		labelInfo.anchorPoint = ccp(0, 1);
		labelInfo.position = ccp(0, winSize.height);
		[labelInfo setHorizontalAlignment:kCCTextAlignmentLeft];
		[self addChild: labelInfo];
		
		//メニュー
		menu = [CCMenu menuWithItems:btnPause, nil];
		menu.position = ccp(winSize.width / 2, winSize.height / 2);
		[menu setVisible:NO];
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
		for(int i = 0; i < 16; i++) {
			sprite = [CCSprite spriteWithSpriteFrameName:@"gauge01.png"];
			sprite.position = ccp(cx + spriteWidth * (i%3-1), cy + spriteHeight * (i/3 - 1));
			sprite.scaleX = spriteWidth / sprite.contentSize.width;
			sprite.scaleY = spriteHeight / sprite.contentSize.height;
			sprite.tag = i;
			
			[tapActionBatch addChild:sprite];
			[cells addObject:sprite];
		}
		
		controller = [PlayController initialize];

		[self schedule:@selector(update:)];
		self.isTouchEnabled = YES;
	}
	
	return self;
}

//シーン更新処理
-(void) update:(ccTime)dt {
	//ラベルの更新
	[self updateInfoLabels];

	if (!controller.isPlaying) return;

	//時間切れノードを非表示に戻す
	
	//新しく現れたノードを表示する
	NSMutableArray *showNodeList = [controller getShowNodeList];
	for (ActionNode *node in showNodeList) {
		if (!node.isShowed) {
			node.isShowed = true;
			NSArray *tags = [node.value componentsSeparatedByString:@","];
			int cell_id = ((NSString *)tags[0]).intValue;
			CCSprite *cell = cells[cell_id];
		
			[cell stopAllActions];
			[cell runAction:[CCSequence actions:[CCAnimate actionWithAnimation: tapAnimation],[CCCallFuncND actionWithTarget:self selector:@selector(hideActionNode:)	data:nil], nil]];
		}
	}
}

//ノードを初期状態に戻す
-(void) hideActionNode: (CCSprite *)cell {
	[cell setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"gauge01.png"]];
}

//情報ラベルを更新する
-(void) updateInfoLabels {
	if (!controller.isLoaded) {
		[labelInfo setString:@"タップで再生開始"];
		return;
	}
	
	float b = [controller getBeat];
	[labelInfo setString:[NSString stringWithFormat:@"beat:%1.3f \nScore:%d", b, controller.score]];
}

//イベントハンドラを登録
-(void) registerWithTouchDispatcher {
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:controller priority:0 swallowsTouches:YES];
}

//タッチされた
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	
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
}

//一時停止ボタンが押された
- (void)btnPauseTapped:(id)sender {
	if (!controller.isPlaying) return;
	[self pause];
}

//ゲーム開始
-(void)start {
	//ファイル読み込み
	NSString *path_music = [[NSBundle mainBundle] pathForResource:FILE_NAME ofType:FILE_EXT_MUSIC];
	NSString *path_score = [[NSBundle mainBundle] pathForResource:FILE_NAME ofType:FILE_EXT_SCORE];
	NSString *path_bg = [[NSBundle mainBundle] pathForResource:FILE_NAME ofType:@"png"];
	if ([[NSFileManager defaultManager] fileExistsAtPath:path_bg]) {
		CCSprite *spriteBG = [CCSprite spriteWithFile:path_bg];
		[layerBackGround addChild: spriteBG];
	}
	[controller loadFile:path_music withScorePath:path_score];
	
	//アニメーションの準備
	tapAnimation = [CCAnimation animationWithSpriteFrames:tapActionFrames delay:60.0f / 149 / 16];
	[tapAnimation retain];
	
	//UIの準備
	[menu setVisible:YES];
	[layerPause setVisible:NO];
	
	[controller playMusic];
}

//一時停止
-(void)pause {
	[controller pauseMusic];
	[layerPause setVisible:YES];
	[menu setVisible:NO];
}

//再開
-(void)restart {
	[controller restartMusic];
	[layerPause setVisible:NO];
	[menu setVisible:YES];
}
@end
