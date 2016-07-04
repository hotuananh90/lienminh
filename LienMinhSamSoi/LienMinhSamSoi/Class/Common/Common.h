//utf-8;
//  Ligue1
//
//  Created by Mac on 6/10/15.
//  Copyright (c) 2015 MacbookPro. All rights reserved.
//

//#define Ligue1_Common_h

//#define BASE_URL                      @"http://54.245.83.127/tmapp/"
#define BASE_URL                      @"http://157.7.133.212/"

#define KEY_API                       @"b531556e-a9a8-48b8-9edb-46d9276a8cd8"
#define NOTIFICATION_CHAMPION         @"NOTIFICATION_CHAMPION"

#define NAVIGATION_TEXT_COLOR                   [UIColor blackColor]
#define SCREEN_WIDTH                                [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT                               [[UIScreen mainScreen] bounds].size.height
#define gPUSHSUCCESS                  @"gPushSuccess"
#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

#define BNazanin(x)                  [UIFont fontWithName:@"BNazanin" size:(x)]
#define BNaznnBd(x)                  [UIFont fontWithName:@"BNaznnBd" size:(x)]
#define BNazaninBold(x)              [UIFont fontWithName:@"BNazaninBold" size:(x)]
