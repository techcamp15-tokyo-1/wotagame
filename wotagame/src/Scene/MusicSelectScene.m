//
//  MusicSelectScene.m
//  wotagame
//
//  Created by KikuraYuichirou on 2013/10/24.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "MusicSelectScene.h"

@implementation MusicSelectScene

-(id) init {
	[super init];
	scoreManager = [ScoreFileManager manager];
	
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGPoint center = ccp(winSize.width/2, winSize.height/2);
	
	/*----------------------------------------------------------------------------
	 Background
	 ----------------------------------------------------------------------------*/
	CCLayer *layerBackground;
	layerBackground = [CCLayer node];
	layerBackground.position = center;
	[self addChild:layerBackground];
		
	/* Background Image */
	CCSprite *spriteBG = [CCSprite spriteWithSpriteFrameName:@"bgPause.png"];
	spriteBG.scaleX = winSize.width / spriteBG.contentSize.width + 0.1;
	spriteBG.scaleY = winSize.height / spriteBG.contentSize.height + 0.1;
	[layerBackground addChild:spriteBG];
	
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
	CCLabelTTF *labelTitle = [CCLabelTTF labelWithString:@"プレイする曲を選択してください"
												fontName:FONT_NAME
												fontSize:14
											  dimensions:winSize
											  hAlignment:kCCTextAlignmentLeft
											  vAlignment:kCCVerticalTextAlignmentCenter];
	labelTitle.color = ccc3(255, 255, 255);
	labelTitle.contentSize = winSize;
	labelTitle.position = ccp(10, winSize.height/2 - 10 - 7);
	[layerMain addChild:labelTitle];
	
	/*----------------------------------------------------------------------------
	 Menu
	 ----------------------------------------------------------------------------*/
	
	/* btnStart */
	btnStart = [CCButton button:@"btnPlay.png" selectedSprite:@"btnPlay_tapped.png"];
	[btnStart setTapEvent:self toSelector:@selector(btnStartTapped)];
	btnStart.scale = (winSize.width/2 - 20) / btnStart.contentSize.width;
	[btnStart setPosition:ccp(winSize.width/4*3, 20+btnStart.contentSize.height/2)];
	btnStart.isEnabled = NO;
	[btnStart setVisible:NO];
	
	/* btnBackToTop */
	btnBackToTop = [CCButton button:@"btnBackToTitle.png" selectedSprite:@"btnBackToTitle_tapped.png"];
	[btnBackToTop setTapEvent:self toSelector:@selector(btnBackToTopTapped)];
	btnBackToTop.scale = (winSize.width/2 - 20) / btnBackToTop.contentSize.width;
	[btnBackToTop setPosition:ccp(winSize.width/4, 20+btnBackToTop.contentSize.height/2)];
	
	/* menu container */
	menu = [CCMenu menuWithItems:btnBackToTop, btnStart, nil];
	menu.position = ccp(0, 0);
	[self addChild:menu];
	
	/*----------------------------------------------------------------------------
	 Music List (TableView)
	 ----------------------------------------------------------------------------*/
	UIView *view;
	view = [CCDirector sharedDirector].view;

	myTableView = [[UITableView alloc] initWithFrame:CGRectMake(20,
																50,
																winSize.width/2,
																winSize.height - 120)];
	myTableView.delegate = self;
	myTableView.dataSource = scoreManager;
	myTableView.separatorColor = [UIColor colorWithWhite:0 alpha:0];
	myTableView.backgroundColor = [UIColor clearColor];
	myTableView.showsVerticalScrollIndicator = NO;
	myTableView.hidden = YES;
	[view addSubview:myTableView];
	
	/*----------------------------------------------------------------------------
	 Music Info Layer
	 ----------------------------------------------------------------------------*/
	
	/* Layer */
	CCLayer *layerMusicInfo;
	layerMusicInfo = [CCLayer node];
	layerMusicInfo.position =  center;
	[self addChild:layerMusicInfo];
	
	/* Label */
	musicInfo = [CCLabelTTF labelWithString:@""
								   fontName:FONT_NAME
								   fontSize:12
								 dimensions:winSize
								 hAlignment:kCCTextAlignmentLeft
								 vAlignment:kCCVerticalTextAlignmentTop];
	musicInfo.color = ccc3(255, 255, 255);
	musicInfo.contentSize = CGSizeMake(winSize.width/2 - 40, winSize.height/2 - 100);
	musicInfo.position = ccp(winSize.width/2 + 20, -winSize.height/2);
	[layerMusicInfo addChild:musicInfo];
	
	/* Music Image */
	spriteBgImg = [CCSprite node];
	[layerMusicInfo addChild:spriteBgImg];
	
	/* Locked Music Image */
	spriteBgImgCover = [CCSprite spriteWithSpriteFrameName:@"locked.png"];
	spriteBgImgCover.scaleX = (winSize.width/2 - 40) / spriteBgImgCover.contentSize.width;
	spriteBgImgCover.scaleY = (winSize.height/2 - 40) / spriteBgImgCover.contentSize.height;
	spriteBgImgCover.position = ccp(winSize.width/4, winSize.height/4);
	spriteBgImgCover.visible = NO;
	[layerMusicInfo addChild:spriteBgImgCover];
	
	[self scheduleUpdate];
	return self;
}

-(void) selectScore:(int) index {
	btnStart.isEnabled = NO;
	
	// Load score data
	NSString *scorePath = [scoreManager getScorePathForIndex:index];
	Score* score = [Score score:scorePath];
	
	// Play music
    [player dealloc];
    NSURL *url = [NSURL fileURLWithPath:score.musicPath];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [player prepareToPlay];
	[player play];
	
	// Show score info
	NSString *difficulty = @"";
	for (int i = 0; i<score.difficulty; i++) difficulty = [NSString stringWithFormat:@"%@★", difficulty];
	for (int i = score.difficulty; i<5; i++) difficulty = [NSString stringWithFormat:@"%@☆", difficulty];
	[musicInfo setString:[NSString stringWithFormat:@"%@\nアーティスト : %@\n難易度 : %@",
						  score.scoreName,
						  score.artist,
						  difficulty]];
	
	// Show score image
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	[spriteBgImg initWithFile:score.backgroundPath];
	spriteBgImg.scaleX = (winSize.width/2 - 40) / spriteBgImg.contentSize.width;
	spriteBgImg.scaleY = (winSize.height/2 - 40) / spriteBgImg.contentSize.height;
	spriteBgImg.position = ccp(winSize.width/4, winSize.height/4);
	if (score.isLocked) {
		// Show locked image
		spriteBgImgCover.visible = YES;
		
		[btnStart setVisible:NO];
		btnStart.isEnabled = NO;
	} else {
		// Hide locked image
		spriteBgImgCover.visible = NO;
		
		[btnStart setVisible:YES];
		btnStart.isEnabled = YES;
	}
}

/*----------------------------------------------------------------------------
 TableView Method Override
 ----------------------------------------------------------------------------*/

/* Initialize cell */
-(void) initializeTableViewCell:(UITableViewCell *)cell {
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor =  cell.isSelected
		? [UIColor colorWithHue:143.0f/255 saturation:232.0f/255 brightness:1.0f alpha:1]
		: [UIColor whiteColor];
	cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
}

/* When a table-cell is unfocused */
-(void) setTableViewCellBlur:(UITableViewCell *)cell {
	cell.textLabel.textColor = [UIColor whiteColor];
}

/* When a table-cell is focused */
-(void) setTableViewCellFocus:(UITableViewCell *)cell {
	[SEPlayer play:SE_TYPE_SELECT];
	cell.textLabel.textColor = [UIColor colorWithHue:143.0f/255 saturation:232.0f/255 brightness:1.0f alpha:1];
}

/*----------------------------------------------------------------------------
 Event Listeners
 ----------------------------------------------------------------------------*/

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	[self initializeTableViewCell:cell];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self setTableViewCellFocus:[tableView cellForRowAtIndexPath:indexPath]];
	[self selectScore:indexPath.row];
}

-(void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self setTableViewCellBlur:[tableView cellForRowAtIndexPath:indexPath]];
}

-(void) onEnterTransitionDidFinish {
	myTableView.hidden = NO;
}

-(void) update:(ccTime)dt {
	[layerWave update];
}

-(void) onExitTransitionDidStart {
	[player stop];
	
    [myTableView removeFromSuperview];
	[myTableView dealloc];
    myTableView = nil;
}

-(void) btnStartTapped{
	[SEPlayer stop:SE_TYPE_BGM_MENU];
	
	NSString *scorePath = [scoreManager getScorePathForIndex:myTableView.indexPathForSelectedRow.row];
	Score* score = [Score score:scorePath];

	PlayScene *scene = [PlayScene node];
	scene.score = score;

	[self unscheduleUpdate];
	[SEPlayer play:SE_TYPE_OK];
	[self fadeTo:scene];
}

-(void) btnBackToTopTapped{
	[self unscheduleUpdate];
	[SEPlayer play:SE_TYPE_CANCEL];
	[self fadeTo:[TopMenuScene node]];
}

@end
