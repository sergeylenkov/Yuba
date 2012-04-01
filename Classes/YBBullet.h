//
//  YBBullet.h
//  Yuba
//
//  Created by Sergey Lenkov on 30.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Foundation/Foundation.h>


enum YBBulletTypes {
	YBBulletTypeCircle = 0,
	YBMarkerTypeSquare = 1
};

@interface YBBullet : NSObject {
	NSColor *color;
	NSColor *borderColor;
	NSInteger size;
	NSInteger borderWidht;
	enum YBBulletTypes type;
    BOOL isHighlighted;
}

@property (nonatomic, retain) NSColor *color;
@property (nonatomic, retain) NSColor *borderColor;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger borderWidht;
@property (nonatomic, assign) enum YBBulletTypes type;
@property (nonatomic, assign) BOOL isHighlighted;

- (void)drawAtPoint:(NSPoint)point;
- (void)drawAtPoint:(NSPoint)point highlighted:(BOOL)highlighted;

@end
