//
//  MTRoundedImageViewView.h
//  MTRoundedImageView
//
//  Created by Mike Daley on 26/03/2010.
//  Copyright 2010 71Squared. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MTRoundedImageViewView : NSView {
	
	/////////////////// Properties
	NSString *description;
	NSImage *image;
	NSImage *reflectionImage;
	NSInteger radius;
	NSColor *shadowColor;
	NSColor *highlightColor;
	NSShadow *shadow;
	BOOL clickable;				// Set to yes if clicking the image should cause the click method
								// in the defined delegate to be called
	id delegate;				// Delegate to be called when the image is clicked
	BOOL mouseInImage;	
	
	/////////////////// Flags
	BOOL selected;
	BOOL drawMouseHighlight;
	
	/////////////////// ivars
	int trackingRect;
}

@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSImage *image;
@property (nonatomic, assign) NSInteger radius;
@property (nonatomic, retain) NSColor *shadowColor;
@property (nonatomic, retain) NSColor *highlightColor;
@property (nonatomic, assign) BOOL clickable;
@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) BOOL selected;

@end