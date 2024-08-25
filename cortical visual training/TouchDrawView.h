//
//  TouchDrawView.h
//  CaplessCoderPaint
//
//  Created by crossmo/yangcun on 14/10/29.
//  Copyright (c) 2014年 yangcun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Line.h"

@interface TouchDrawView : UIView {
    BOOL isCleared;
}

@property (nonatomic) Line *currentLine;
@property (nonatomic) NSMutableArray *linesCompleted;
@property (nonatomic) UIColor *drawColor;
@property (nonatomic) NSString* fileName;
@property (assign) int strokeWidth;

- (void)undo;
- (void)redo;
- (void)clearAll;


-(void)loadFromFile:(NSString*)fileName;
-(void)saveToFile:(NSString*)fileName;

-(BOOL)hasContents;

@end
