//
//  YBBullet.h
//  Yuba
//
//  Created by Sergey Lenkov on 30.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	PTBulletTypeCircle = 0,
	PTMarkerTypeSquare = 1
};

@interface YBBullet : NSObject {
	NSColor *color;
	NSColor *borderColor;
	NSInteger size;
	NSInteger borderWidht;
	NSInteger type;
}

@property (nonatomic, retain) NSColor *color;
@property (nonatomic, retain) NSColor *borderColor;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, assign) NSInteger borderWidht;
@property (nonatomic, assign) NSInteger type;

- (void)drawAtPoint:(NSPoint)point;

@end
