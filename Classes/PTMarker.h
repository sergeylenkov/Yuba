//
//  PTMarker.h
//  Yuba
//
//  Created by Sergey Lenkov on 28.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	PTMarkerTypeRect = 0,
	PTMarkerTypeRoundedRect = 1,
	PTMarkerTypeRectWithArrow = 2
};

@interface PTMarker : NSObject {
	NSFont *font;
	NSColor *textColor;
	NSColor *backgroundColor;
	NSColor *borderColor;
	NSInteger borderWidht;
	NSInteger type;
	NSInteger position;
	BOOL shadow;
}

@property (nonatomic, retain) NSFont *font;
@property (nonatomic, retain) NSColor *textColor;
@property (nonatomic, retain) NSColor *backgroundColor;
@property (nonatomic, retain) NSColor *borderColor;
@property (nonatomic, assign) NSInteger borderWidht;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) BOOL shadow;

- (void)drawAtPoint:(NSPoint)point inRect:(NSRect)rect withTitle:(NSString *)title;

@end
