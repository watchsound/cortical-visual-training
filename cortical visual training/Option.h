//
//  Option.h
//  r9
//
//  Created by Hanning Ni on 10/12/13.
//  Copyright (c) 2013 Hanning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Option : NSObject

@property (retain) NSString* text;
@property (retain) NSString* detail;
@property (retain) UIImage*  image;
@property (assign) int  oid;

-(NSString*)description;
-(BOOL)isEqual:(id)object;

@end
