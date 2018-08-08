//
//  YCPinYin.h
//  YCPinYin
//
//  Created by ungacy on 2017/2/24.
//  Copyright (c) 2017 ungacy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, YCPinYinOutoutFormat) {
    YCPinYinOutoutFormatDefault = 0,
    YCPinYinOutoutFormatTone = 1 << 0,
    YCPinYinOutoutFormatFirstLetter = 1 << 1,
    YCPinYinOutoutFormatAllLetter = 1 << 2,
};

@interface YCPinYin : NSObject

+ (instancetype)sharedInstance;

/**
 default is `YCPinYinOutoutFormatFirstLetter | YCPinYinOutoutFormatAllLetter`
 */
@property (nonatomic, assign) YCPinYinOutoutFormat defaultFormat;

/**
 default is `#`
 */
@property (nonatomic, copy) NSString *defaultSeparator;

@end

@interface NSString (SIPinYin)

/**
`单贝` => `db#cb#sb#danbei#chanbei#shanbei` or `db#cb#sb` or `danbei#chanbei#shanbei`
 @return PinYin separated by `#`
 */
- (NSString *)yc_toPinYin;

/**
 @see above

 @param @format @see YCPinYinOutoutFormat
 @return PinYin separated by `#` with `format`
 */
- (NSString *)yc_toPinYinWithFormat:(YCPinYinOutoutFormat)format;

/**
 @see above

 @param @separator  @see above
 @param @tone 声调
         YES : 在 => zai4
         NO  : zai => zai
 @return PinYin with `tone` [or not] separated by `separator`
 */
- (NSString *)yc_toPinYinWithFormat:(YCPinYinOutoutFormat)format separator:(NSString *)separator;

- (NSArray *)yc_matchToWord:(NSString *)word;

@end

