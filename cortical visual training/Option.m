//
//  Option.m
//  r9
//
//  Created by Hanning Ni on 10/12/13.
//  Copyright (c) 2013 Hanning. All rights reserved.
//

#import "Option.h"

@implementation Option

@synthesize text = _text;
@synthesize image = _image;
@synthesize detail = _detail;
@synthesize oid = _oid;

-(NSString*)description{
    return _detail == nil ? _text : _detail;
}
-(BOOL)isEqual:(id)object{
   
    if (! [object isKindOfClass: [Option class]])
        return FALSE;
    if ( _oid ){
        return _oid == ((Option*)object).oid;
    }
    return [_text isEqualToString:((Option*)object).text];
}

@end
