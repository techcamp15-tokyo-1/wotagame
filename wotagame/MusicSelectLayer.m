//
//  MusicSelectLayer
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/26.
//  Copyright 2013年 wotagineer. All rights reserved.
//

#import "MusicSelectLayer.h"

@implementation MusicSelectLayer

CCLayer *layerBackGround;

PlayController *playController;

UIView *view;
	UITableView *myTableView;
	UIButton *btnStart;
ScoreFileManager *scoreManager;
ScoreModel *scoreModel;

AVAudioPlayer *player;

#ifdef ISDEBUG
CCLabelTTF *labelInfo;
#endif

//初期化
+(CCScene *) scene {
	CCScene *scene = [CCScene node];
	MusicSelectLayer *layer = [MusicSelectLayer node];
	scoreManager = [ScoreFileManager getInstance];
	scoreModel = [ScoreModel getInstance];
	player = NULL;
    [player prepareToPlay];
	
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
	
	CCSprite *spriteBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
	[layerBackGround addChild: spriteBG];
	
	//---------------------------------------------------------------------------------------------------------
	//曲一覧
	view = [CCDirector sharedDirector].view;
	CGRect viewRect = [view bounds];
	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
																0,
																viewRect.size.width,
																viewRect.size.height)];
	myTableView.delegate = self;
	myTableView.dataSource = scoreManager;
	myTableView.separatorColor = [UIColor colorWithWhite:0 alpha:0];
	myTableView.backgroundColor = [UIColor clearColor];
	myTableView.showsVerticalScrollIndicator = NO;
	[view addSubview:myTableView];

	//開始ボタン
	btnStart = [[UIButton alloc] initWithFrame:CGRectMake(viewRect.size.width/2 + 10, viewRect.size.height-40, viewRect.size.width/2 - 20, 20)];
	[btnStart setTitle:@"Start" forState:UIControlStateNormal];
	[btnStart addTarget:self action:@selector(btnStartTapped) forControlEvents:UIControlEventTouchUpInside];
	btnStart.enabled = NO;

	[view addSubview:btnStart];

	//戻るボタン
	UIButton *btnBackToTop = [[UIButton alloc] initWithFrame:CGRectMake(10, viewRect.size.height-40, viewRect.size.width/2 - 20, 20)];
	[btnBackToTop setTitle:@"Back to Top" forState:UIControlStateNormal];
	[btnBackToTop addTarget:self action:@selector(btnBackToTitle) forControlEvents:UIControlEventTouchUpInside];
	
	[view addSubview:btnBackToTop];
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

//セルの初期化
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.textLabel.textColor = [UIColor whiteColor];
}

//テーブルセルが解除された
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.textLabel.textColor = [UIColor whiteColor];
}
	//テーブルセルが選択された
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	btnStart.enabled = YES;
	
	[SEPlayer play:SE_TYPE_SELECT];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.textLabel.textColor = [UIColor blueColor];

	//楽譜データを読み込む
	NSString *scorePath = [scoreManager getScorePathForIndex:indexPath.row];
	[scoreModel loadScore:scorePath];
	ScoreMeta scoreMeta = scoreModel.getMeta;
	
	//曲を再生
    [player stop];
    NSURL *url = [NSURL fileURLWithPath:scoreMeta.musicPath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player prepareToPlay];
	[player play];
}

//現在のUIをすべて削除
-(void) removeAllSubView {
	view = [CCDirector sharedDirector].view;
	while ([view subviews].count) {
		[[view subviews][0] removeFromSuperview];
	}
}

//画面の遷移前に変数を掃除
-(void) prepareForNavigateScene{
	[player stop];
	[player dealloc];
	
	[self removeAllSubView];
}

-(void) btnStartTapped{
	[SEPlayer play:SE_TYPE_SELECT];

	//遷移の準備
	[self prepareForNavigateScene];
	
	//選択した曲データを保存
	int selectedIndex = myTableView.indexPathForSelectedRow.row;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:[scoreManager getScorePathForIndex:selectedIndex] forKey:KEY_USER_SELECTED_MUSIC];
	
	//遷移
	CCScene *scene = [PlayLayer scene];
	id transition = [CCTransitionCrossFade transitionWithDuration:TRANSITION_DURATION_TIME scene:scene];
	[[CCDirector sharedDirector] replaceScene:transition];	
}

-(void) btnBackToTitle{
	[SEPlayer play:SE_TYPE_SELECT];
	
	//遷移の準備
	[self prepareForNavigateScene];
	
	//遷移
	CCScene *scene = [TopMenuLayer scene];
	id transition = [CCTransitionScene transitionWithDuration:0 scene:scene];
	[[CCDirector sharedDirector] replaceScene:transition];
}
@end

