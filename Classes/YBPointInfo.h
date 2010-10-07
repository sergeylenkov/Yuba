//
//  YBPointInfo.h
//  Yuba
//
//  Created by Sergey Lenkov on 27.04.10.
//  Copyright 2010 Positive Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBPointInfo : NSObject {
	NSInteger x;
	NSInteger y;
	NSString *title;
}

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;
@property (nonatomic, copy) NSString *title;

@end
