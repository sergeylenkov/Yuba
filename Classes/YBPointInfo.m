//
//  YBPointInfo.m
//  Yuba
//
//  Created by Sergey Lenkov on 27.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import "YBPointInfo.h"

@implementation YBPointInfo

@synthesize x;
@synthesize y;
@synthesize title;

- (void)dealloc {
	[title release];
	[super dealloc];
}

@end
