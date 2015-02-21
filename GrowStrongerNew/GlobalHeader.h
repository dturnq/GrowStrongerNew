//
//  GlobalHeader.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 2/20/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#ifndef GrowStrongerNew_GlobalHeader_h
    #define GrowStrongerNew_GlobalHeader_h

#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#endif
