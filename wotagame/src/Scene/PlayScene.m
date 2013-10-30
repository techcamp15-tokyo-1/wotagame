//
//  PlayScene.m
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/26.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "PlayScene.h"

@implementation PlayScene
-(id) init{
	[super init];
	
	self.controller = [PlayController initWithScene:self];
	
	cache = [CCSpriteFrameCache sharedSpriteFrameCache];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGPoint center = ccp(winSize.width/2, winSize.height/2);
	float spriteWidth;
	float spriteHeight;
	
	/*----------------------------------------------------------------------------
	 Background
	 ----------------------------------------------------------------------------*/
	CCLayer* layerBackground = [CCLayer node];
	layerBackground.position =  center;
	[self addChild:layerBackground];
	
	/* Background Image */
	spriteBG = [CCSprite node];
	spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
	[layerBackground addChild:spriteBG];

	/*----------------------------------------------------------------------------
	 Playing view
	 ----------------------------------------------------------------------------*/
	CCLayer* layerPlay = [CCLayer node];
	layerPlay.position = center;
	layerPlay.scale = min(winSize.width / layerPlay.contentSize.width, winSize.height / layerPlay.contentSize.height);
	[self addChild:layerPlay];
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	
	CCSpriteBatchNode* tapActionBatch = [CCSpriteBatchNode batchNodeWithFile:@"cell.png"];
	tapActionBatch.position = ccp(-center.x, -center.y);
	[layerPlay addChild:tapActionBatch];
	
	CCSprite* sprite;
	CCSpriteFrame* frame;
	NSString* frameName;
	
	spriteWidth = winSize.width/3;
	spriteHeight = winSize.height/3;
	
	tapActionFrames = [[NSMutableArray array] retain];
	for (int i=1; i<=40; i++) {
		frameName = [NSString stringWithFormat:@"gauge%02d.png", i];
		frame = [cache spriteFrameByName: frameName];
		[tapActionFrames addObject: frame];
	}
	
	cells = [[NSMutableArray alloc] init];
	for(int i = 0; i < 9; i++) {
		sprite = [CCSprite spriteWithSpriteFrame:[cache spriteFrameByName:@"gauge01.png"]];
		sprite.position = ccp(center.x + spriteWidth * (i%3-1), center.y + spriteHeight * (i/3 - 1));
		sprite.scaleX = spriteWidth / sprite.contentSize.width;
		sprite.scaleY = spriteHeight / sprite.contentSize.height;
		sprite.tag = i;
		[tapActionBatch addChild:sprite];
		[cells addObject:sprite];
	}
	
	resultFrames = [[NSMutableArray array] retain];
	[resultFrames addObject:[cache spriteFrameByName:@"gaugeOK.png"]];
	[resultFrames addObject:[cache spriteFrameByName:@"gaugeGood.png"]];
	[resultFrames addObject:[cache spriteFrameByName:@"gaugeGreat.png"]];
	[resultFrames addObject:[cache spriteFrameByName:@"gaugePerfect.png"]];
	[resultFrames addObject:[cache spriteFrameByName:@"gaugeMISS.png"]];
	
	resultLabels = [[NSMutableArray alloc] init];
	for(int i = 0; i < 9; i++) {
		sprite = [CCSprite spriteWithSpriteFrame:tapActionFrames[0]];
		sprite.position = ccp(center.x + spriteWidth * (i%3-1), center.y + spriteHeight * (i/3 - 1));
		sprite.scaleX = spriteWidth / sprite.contentSize.width;
		sprite.scaleY = spriteHeight / sprite.contentSize.height;
		sprite.tag = i;
		[tapActionBatch addChild:sprite];
		[resultLabels addObject:sprite];
	}

	CCButton* btnPause = [CCButton button:@"btnPause.png" selectedSprite:@"btnPause_tapped.png"];
	[btnPause setTapEvent:self.controller toSelector:@selector(pauseGame)];
	btnPause.position = ccp(center.x - btnPause.contentSize.width/2 - 10, -center.y + btnPause.contentSize.height/2 + 10);
	
	CCMenu* menuPlay = [CCMenu menuWithItems:btnPause, nil];
	menuPlay.position =  ccp(0, 0);
	[layerPlay addChild:menuPlay];
	
	/*----------------------------------------------------------------------------
	 StickMan action Layer
	 ----------------------------------------------------------------------------*/
	
	CCSpriteBatchNode *SMActionBatch = [CCSpriteBatchNode batchNodeWithFile:@"SMAction.png"];
	SMActionBatch.position = ccp(0, 0);
	[layerPlay addChild:SMActionBatch];
	
	actionParamList = [[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SMActionList" ofType:@"plist"]] retain];
	SMActionFrameList = [[NSMutableArray alloc] init];
	
	for (NSDictionary *act in actionParamList) {
		NSMutableArray *frames = [NSMutableArray array];
		int frameIdFrom = [(NSNumber *)[act objectForKey:@"frameIdFrom"] integerValue];
		int frameIdTo = [(NSNumber *)[act objectForKey:@"frameIdTo"] integerValue];
		NSString *actionFileMaskName = [act objectForKey:@"actionFileMaskName"];
		
		for (int i=frameIdFrom; i<=frameIdTo; i++) {
			[frames addObject:
			 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
			  [NSString stringWithFormat:actionFileMaskName, i]]];
		}
		
		[SMActionFrameList addObject:frames];
	}
	
	NSArray *action = SMActionFrameList[0];
	spriteSM = [CCSprite spriteWithSpriteFrame:action[0]];
	spriteSM.position = ccp(0, 0);
	spriteSM.scale = spriteHeight * 3 / spriteSM.contentSize.height;
	[SMActionBatch addChild:spriteSM];

	/*----------------------------------------------------------------------------
	 Pause
	 ----------------------------------------------------------------------------*/
	layerPause = [CCLayer node];
	layerPause.position = center;
	layerPause.scale = min(winSize.width / layerPause.contentSize.width, winSize.height / layerPause.contentSize.height);
	layerPause.visible = NO;
	[self addChild:layerPause];
	
	CCSprite *spritePauseBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spritePauseBG.scaleX = winSize.width / spritePauseBG.contentSize.width + 0.1;
	spritePauseBG.scaleY = winSize.height / spritePauseBG.contentSize.height + 0.1;
	[layerPause addChild: spritePauseBG];
	
	CCSprite* labelPauseLogo = [CCSprite spriteWithSpriteFrameName:@"labelPauseLogo.png"];
	labelPauseLogo.position = ccp(0, 0 + 20);
	labelPauseLogo.scale = center.x / winSize.width;
	[layerPause addChild:labelPauseLogo];
	
	CCLabelTTF* labelPause = [CCLabelTTF labelWithString:@"画面をタップすると再開します"
												fontName:FONT_NAME
												fontSize:14
											  dimensions:winSize
											  hAlignment:kCCTextAlignmentCenter
											  vAlignment:kCCVerticalTextAlignmentCenter];
	labelPause.color = ccc3(255, 255, 255);
	labelPause.position = ccp(0, 0 - 20);
	[layerPause addChild:labelPause];
	
	
	CCButton* btnReset = [CCButton button:@"btnReset.png"
						   selectedSprite:@"btnReset_tapped.png"];
	[btnReset setTapEvent:self.controller toSelector:@selector(resetGame)];
	btnReset.scale = 40 / btnReset.contentSize.height;
	btnReset.position = ccp(center.x - btnReset.boundingBox.size.width/2, center.y - btnReset.boundingBox.size.height/2);
	
	
	CCButton* btnBackToMenu = [CCButton button:@"btnBackToMenu.png"
								selectedSprite:@"btnBackToMenu_tapped.png"];
	[btnBackToMenu setTapEvent:self.controller toSelector:@selector(retireGame)];
	btnBackToMenu.scale = 40 / btnBackToMenu.contentSize.height;
	btnBackToMenu.position = ccp(-center.x + btnBackToMenu.boundingBox.size.width/2, center.y - btnBackToMenu.boundingBox.size.height/2);
	
	CCMenu* menuPause = [CCMenu menuWithItems:
						 btnReset,
						 btnBackToMenu, nil];
	menuPause.position =  ccp(0, 0);
	[layerPause addChild:menuPause];
	
	/*----------------------------------------------------------------------------
	 Before start
	 ----------------------------------------------------------------------------*/
	layerBeforeStart = [CCLayer node];
	layerBeforeStart.position = center;
	[self addChild:layerBeforeStart];
	
	CCSprite* spriteStartBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spriteStartBG.scaleX = winSize.width / spriteStartBG.contentSize.width + 0.1;
	spriteStartBG.scaleY = winSize.height / spriteStartBG.contentSize.height + 0.1;
	[layerBeforeStart addChild: spriteStartBG];
	
	CCButton* btnStart = [CCButton button:@"btnPlay.png" selectedSprite:@"btnPlay_tapped.png"];
	[btnStart setTapEvent:self.controller toSelector:@selector(startGame)];
	btnStart.position = ccp(0, 0);
	
	CCMenu* menuBeforeStart = [CCMenu menuWithItems:
							   btnStart, nil];
	menuBeforeStart.position =  ccp(0, 0);
	[layerBeforeStart addChild:menuBeforeStart];
		
	/*----------------------------------------------------------------------------
	 Result Layer
	 ----------------------------------------------------------------------------*/
	layerResult = [CCLayer node];
	layerResult.position = center;
	layerResult.scale = min(winSize.width / layerResult.contentSize.width, winSize.height / layerResult.contentSize.height);
	layerResult.visible = NO;
	[self addChild:layerResult];
	
	CCSprite *spriteResultBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spriteResultBG.scaleX = winSize.width / spriteResultBG.contentSize.width + 0.1;
	spriteResultBG.scaleY = winSize.height / spriteResultBG.contentSize.height + 0.1;
	[layerResult addChild: spriteResultBG];
	
	CCSprite *labelResultLogo = [CCSprite spriteWithSpriteFrameName:@"labelResultLogo.png"];
	labelResultLogo.position = ccp(0, 100);
	labelResultLogo.scale = center.x / winSize.width;
	[layerResult addChild:labelResultLogo];
	
	labelResult = [CCLabelTTF labelWithString: @""
									 fontName:FONT_NAME
									 fontSize:16
								   dimensions:winSize
								   hAlignment:kCCTextAlignmentCenter
								   vAlignment:kCCVerticalTextAlignmentCenter];
	labelResult.color = ccc3(255, 255, 255);
	labelResult.contentSize = winSize;
	
	labelResult.position = ccp(0, 0);
	[layerResult addChild:labelResult];
	
	CCButton *btnBackToMenu2 = [CCButton button:@"btnBackToMenu.png" selectedSprite:@"btnBackToMenu_tapped.png"];
	[btnBackToMenu2 setTapEvent:self.controller toSelector:@selector(returnTopMenu)];
	btnBackToMenu2.position = ccp(-winSize.width/4, -winSize.height/4-20);
	btnBackToMenu2.scale = (winSize.width/2)/ btnBackToMenu2.contentSize.width;
	
	CCButton *btnTweet = [CCButton button:@"btnTweet.png" selectedSprite:@"btnTweet_tapped.png"];
	[btnTweet setTapEvent:self.controller toSelector:@selector(tweet)];
	btnTweet.position = ccp(winSize.width/4, -winSize.height/4-20);
	btnTweet.scale = (winSize.width/2)/ btnTweet.contentSize.width;

	CCMenu *menu = [CCMenu menuWithItems:btnBackToMenu2, btnTweet, nil];
	menu.position = ccp(0, 0);
	[layerResult addChild:menu];
	
	/*----------------------------------------------------------------------------
	 Informations
	 ----------------------------------------------------------------------------*/
	CCLayer* layerFront = [CCLayer node];
	layerFront.position = center;
	layerFront.scale = min(winSize.width / layerFront.contentSize.width, winSize.height / layerFront.contentSize.height);
	[self addChild:layerFront z:1];
	
	CCLabelTTF* labelScore = [CCLabelTTF labelWithString:@""
												fontName:FONT_NAME
												fontSize:18
											  dimensions:winSize
											  hAlignment:kCCTextAlignmentCenter
											  vAlignment:kCCVerticalTextAlignmentCenter];
	labelScore.color = ccc3(96, 96, 96);
	labelScore.contentSize = winSize;
	labelScore.position = ccp(0, 0);
	[layerFront addChild:labelScore];
	
	labelMusicInfo = [CCLabelTTF labelWithString:@""
										fontName:FONT_NAME
										fontSize:16
									  dimensions:winSize
									  hAlignment:kCCTextAlignmentLeft
									  vAlignment:kCCVerticalTextAlignmentBottom];
	
	labelMusicInfo.color = ccc3(210, 210, 210);
	labelMusicInfo.contentSize = winSize;
	labelMusicInfo.fontSize = 12;
	labelMusicInfo.position = ccp(10, 10);
	[layerFront addChild:labelMusicInfo];

	return self;
}

-(void) initWithScore {
	CGSize winSize = [[CCDirector sharedDirector] winSize];

	resultLabelLifeTime = [[NSMutableArray alloc] init];
	for(int i = 0; i < 9; i++) {
		CCSprite *cell = resultLabels[i];
		cell.opacity = 0.0f;
		[resultLabelLifeTime addObject:@{@"from": @0.0f, @"duration": @1.0f}];
	}
	
	[labelMusicInfo setString:[NSString stringWithFormat:@"%@ \n%@ \n難易度:%d", self.score.title, self.score.artist, self.score.difficulty]];
	[spriteBG initWithFile:self.score.backgroundPath];
	spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
}

/*----------------------------------------------------------------------------
 Update
 ----------------------------------------------------------------------------*/
-(void) update:(ccTime)dt {
	[self.controller update:dt];
}

-(void) updateCell:(int) cellId andValue:(float) value {
	int frameNo = max(min([tapActionFrames count] * value, [tapActionFrames count]-1), 0);
	[cells[cellId] setDisplayFrame:tapActionFrames[frameNo]];
}

-(void) updateResultLabel:(int) cellId andBeat:(float) beat {
	CCSprite *cell = resultLabels[cellId];
	if (cell.opacity == 0) return;
	
	NSDictionary *lifetime = resultLabelLifeTime[cellId];
	float from = ((NSNumber*)[lifetime objectForKey:@"from"]).floatValue;
	float duration = ((NSNumber*)[lifetime objectForKey:@"duration"]).floatValue;
	cell.opacity = max(255.0f * (1.0f -(beat - from) / duration ), 0.0f);
}

-(void) setSpark:(int) cellId {
    CCParticleSystem * ps = [CCParticleSystemQuad particleWithFile:@"exploding_ring.plist"];
    ps.sourcePosition = ((CCSprite *)cells[cellId]).position;
    ps.autoRemoveOnFinish = YES;
    [self addChild:ps];
}

-(void) setResultLabel:(int) cellId result:(enum RESULT)result andLifeTime:(float)beat {
	CCSprite *label = resultLabels[cellId];
	[label setDisplayFrame:resultFrames[result]];
	label.opacity = 255;
	resultLabelLifeTime[cellId] = @{@"from":[NSNumber numberWithFloat:beat], @"duration":@1.0f};
}

-(void) updateSMAction: (int)actionID {
	//	beat length of the action
	int beat_all = ((NSString *)[actionParamList[actionID] objectForKey:@"beat"]).integerValue;
	
	//  now beat
	float beat = [self.controller getBeat];
	
	//	compute the beat in the action
	beat = beat-(int)beat + (int)beat%beat_all;
	
	//	compute frameNo from the beat
	int frameNo = max([SMActionFrameList[actionID] count] * beat / beat_all, 0);
	
	//	change frame
	[spriteSM setDisplayFrame:SMActionFrameList[actionID][frameNo]];
}

-(void) updateResultLayer {
	[labelResult setString:[NSString stringWithFormat:@"%@Perfect : %02d\nGreat : %02d\nGood : %02d\nOK : %02d\nMiss : %02d\nMax Combo : %d\nTotal : \%d",
		self.controller.resultMiss ? @"" : @"FULL COMBO!!\n",
		self.controller.resultPerfect,
		self.controller.resultGreat,
		self.controller.resultGood,
		self.controller.resultOk,
		self.controller.resultMiss,
		self.controller.resultMaxCombo,
		self.controller.resultScore
	 ]];
}

/*----------------------------------------------------------------------------
 State change
 ----------------------------------------------------------------------------*/
-(void) showLayerBeforeStart: (BOOL) isVisible {
	layerBeforeStart.visible = isVisible;
	labelMusicInfo.color = self.controller.state == GAMESTATE_PLAY ? ccc3(0, 0, 0) : ccc3(255, 255, 255);
}

-(void) showLayerPause: (BOOL) isVisible {
	layerPause.visible = isVisible;
	labelMusicInfo.color = self.controller.state == GAMESTATE_PLAY ? ccc3(0, 0, 0) : ccc3(255, 255, 255);
}

-(void) showLayerResult: (BOOL) isVisible {
	layerResult.visible = isVisible;
	if (isVisible) [self updateResultLayer];
	labelMusicInfo.color = self.controller.state == GAMESTATE_PLAY ? ccc3(0, 0, 0) : ccc3(255, 255, 255);
}

-(void) backToMenu {
	[SEPlayer play:SE_TYPE_BGM_MENU];
	[self fadeTo:[MusicSelectScene node]];
}

/*----------------------------------------------------------------------------
 Tap Event
 ----------------------------------------------------------------------------*/
-(int)pursueTappedCell:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint touchPos = [touch locationInView:[touch view]];
	touchPos = [[CCDirector sharedDirector] convertToGL:touchPos];
	
	for (CCSprite *cell in cells) {
		if (CGRectContainsPoint(cell.boundingBox, touchPos)) return cell.tag;
	}
	return -1;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	int tappedCellId;
	switch (self.controller.state) {
		case GAMESTATE_PLAY:
			tappedCellId = [self pursueTappedCell:touch withEvent:event];
			if (tappedCellId >= 0) {
				[self.controller tapCell:tappedCellId];
				return YES;
			} else {
				return NO;
			}
			break;
		
		case GAMESTATE_PAUSE:
			[self.controller restartGame];
			return YES;
			break;
			
		default:
			break;
	}
	return NO;
}

/*----------------------------------------------------------------------------
 Properties
 ----------------------------------------------------------------------------*/
-(void) setScore:(Score*) s {
	self.controller.score = s;
	[self initWithScore];
}

-(Score*) score {
	return self.controller.score;
}

@end
