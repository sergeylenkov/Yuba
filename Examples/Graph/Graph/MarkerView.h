//
//  MarkerView.h
//  Graph
//
//  Created by Sergey Lenkov on 18.01.12.
//  Copyright (c) 2012 Positive Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarkerView : NSView {
    IBOutlet NSTextField *titleField;
    NSString *text;
}

@property (nonatomic, copy) NSString *text;

@end
