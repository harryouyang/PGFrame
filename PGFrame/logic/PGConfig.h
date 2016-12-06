//
//  PGConfig.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#ifndef PGConfig_h
#define PGConfig_h

/////////////////////////////////////////////////////////////////
//测试环境
#define USE_TEST            1
//预上线环境
#define USE_PRE             2
//生产环境
#define USE_PRODUCT         3

#define USE_CURRENT_ENVIRONMENT     USE_TEST


#if USE_CURRENT_ENVIRONMENT == USE_TEST
#define BASE_URL                    @"http://api.yks.com/apiv3/public"
#define VERSION_MARK                @" -->测试库版本"
#elif USE_CURRENT_ENVIRONMENT == USE_PRE
#define BASE_URL                    @""
#define VERSION_MARK                @" -->预上线版本"
#else
#define BASE_URL                    @""
#define VERSION_MARK                @""
#endif

/////////////////////////////////////////////////////////////////
#define PG_IMAGE_PATH               @"Image"
#define PG_CACHES_DATA_PATH         @"CachesData"

/////////////////////////////////////////////////////////////////
#define Color_For_Cell                      UIColorFromRGB(0x333333)
#define Color_For_separatorColor            UIColorFromRGB(0xe2e2e2)
#define Color_For_ControllerBackColor       UIColorFromRGB(0xf0f1f2)
#define Color_For_SubmitColor               UIColorFromRGB(0xf08200)
#define Color_For_TextColor                 UIColorFromRGB(0x333333)
#define Color_For_GrayTextColor             UIColorFromRGB(0xadaeae)
#define Color_For_BlackColor                UIColorFromRGB(0x000000)
#define Color_For_NavBarColor               UIColorFromRGB(0x3d454f)
#define Color_For_BlueButton                UIColorFromRGB(0x00b4ff)
#define Color_For_OrangeButton              UIColorFromRGB(0xf08300)
#define Color_For_ClickedButton             UIColorFromRGB(0xc07c1e)

#endif /* PGConfig_h */
