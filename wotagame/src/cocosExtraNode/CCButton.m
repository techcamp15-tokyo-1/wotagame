//
//  CCButton.m
//  wotagame
//
//  Created by KikruaYuichirou on 2013/08/28.
//  Copyright (c) 2013 wotagineer. All rights reserved.
//

#import "CCButton.h"

@implementation CCButton

//コンストラクタ
+(CCButton *) button:(NSString *)spriteFrameName selectedSprite:(NSString *)selectedSpriteFrameName {
	CCSprite *s = [CCSprite spriteWithSpriteFrameName:spriteFrameName];
	CCSprite *s2 = [CCSprite spriteWithSpriteFrameName:selectedSpriteFrameName];
	return [CCButton itemWithNormalSprite:s selectedSprite:s2];
}

//ラベルボタンを作る
+(CCButton *) buttonOfText:(NSString *)text {
	CCLabelTTF *label = [CCLabelTTF node];
	[label setString:text];
	
	CCButton *button = [CCButton node];
	[button addChild:label];
	return button;
}

//指定サイズに変形する
-(void)setSize:(CGSize)size {
	self.scaleX = size.width / self.contentSize.width;
	self.scaleY = size.height / self.contentSize.height;
}

//イベントをセットする
-(void) setTapEvent:(id)object toSelector:(SEL)sel {
	[self setTarget:object selector:sel];
}

@end