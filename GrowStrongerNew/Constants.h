//
//  Constants.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 2/21/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#ifndef GrowStrongerNew_Constants_h
#define GrowStrongerNew_Constants_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define NavColor UIColorFromRGB(0xFBC723)
#define LinkColor UIColorFromRGB(0x1B6AA5)
#define TabColor UIColorFromRGB(0xB2322F)
#define TabTextColor UIColorFromRGB(0x4A4A4A)
#define ButtonBorderColor UIColorFromRGB(0xB2322F)
#define SetBorderColor UIColorFromRGB(0x4A4A4A)
#define Body_SelectedTextColor UIColorFromRGB(0xB2322F)
//[UIColor colorWithRed:27/255.0 green:106/255.0 blue:165/255.0 alpha:1.0]

#endif
