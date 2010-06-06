//
//  PTPointInfo.m
//  Yuba
//
//  Created by Sergey Lenkov on 27.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import "PTPointInfo.h"

@implementation PTPointInfo

@synthesize x;
@synthesize y;
@synthesize title;

- (void)dealloc {
	[title release];
	[super dealloc];
}

@end
