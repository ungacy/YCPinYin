//
//  YCPinYin.m
//  YCPinYin
//
//  Created by ungacy on 2017/2/24.
//  Copyright (c) 2017 ungacy. All rights reserved.
//

#import "YCPinYin.h"

static NSString *const kYCPinYinResourceName = @"unicode_to_hanyu_pinyin";

static NSString *const kYCPinYinNoRecord = @"none0";

static NSString *const kYCPinYinDefaultSeparator = @"#";

@interface YCPinYin ()

/**
 default is `#`
 */
@property (nonatomic, copy) NSString *separator;

/**
 default is `YCPinYinOutoutFormatAllLetter | YCPinYinOutoutFormatFirstLetter`
 */
@property (nonatomic, assign) YCPinYinOutoutFormat format;

@property (nonatomic, strong) NSCache *queryCache;

@property (nonatomic, strong) NSDictionary *pinyinDict;

@end

@implementation YCPinYin

+ (instancetype)sharedInstance {
    static dispatch_once_t once = 0;
    static id instance = nil;

    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _queryCache = [[NSCache alloc] init];
        _defaultFormat = YCPinYinOutoutFormatAllLetter | YCPinYinOutoutFormatFirstLetter;
        _defaultSeparator = kYCPinYinDefaultSeparator;
        [self _initResource];
    }
    return self;
}

- (void)_initResource {
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:kYCPinYinResourceName ofType:@"plist"];
    _pinyinDict = [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (NSArray *)toHanyuPinyinStringArrayWithChar:(unichar)ch {
    int codePointOfChar = ch;
    NSString *codepointHexStr = [[NSString stringWithFormat:@"%x", codePointOfChar] uppercaseString];
    NSArray *foundRecords = [[YCPinYin sharedInstance].pinyinDict objectForKey:codepointHexStr];
    if (foundRecords.count == 1 && [foundRecords.firstObject isEqualToString:kYCPinYinNoRecord]) {
        return nil;
    }
    return foundRecords;
}

@end

static inline NSArray *convertStringToPinYinWordsArray(NSString *string) {
    NSMutableArray *pinyinArray = [NSMutableArray arrayWithCapacity:string.length];
    NSMutableString *specialString = [NSMutableString string];
    for (NSUInteger index = 0; index < string.length; index++) {
        unichar letter = [string characterAtIndex:index];
        NSString *key = [string substringWithRange:NSMakeRange(index, 1)];
        if (letter < 0x4e00 || letter > 0x9fff) {
            [specialString appendString:key];
            if (index != string.length - 1) {
                continue;
            }
        }
        if (specialString.length > 0) {
            //Maybe they are not a chinese word, add a special tone `##` to point it out.
            [specialString appendString:kYCPinYinDefaultSeparator];
            [specialString appendString:kYCPinYinDefaultSeparator];
            [pinyinArray addObject:@[[specialString copy]]];
            [specialString setString:@""];
        }
        NSArray *array = (NSArray *)[[YCPinYin sharedInstance].queryCache objectForKey:key];
        if (!array) {
            array = [YCPinYin toHanyuPinyinStringArrayWithChar:letter];
            if (array) {
                [[YCPinYin sharedInstance].queryCache setObject:array forKey:key];
            } else {
                array = @[kYCPinYinDefaultSeparator];
            }
        }
        [pinyinArray addObject:array];
    }
    return pinyinArray;
}

static inline NSArray *flattenJoinArray(NSArray *array, NSArray *previousArray) {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:0];
    [previousArray enumerateObjectsUsingBlock:^(NSString *_Nonnull previous,
                                                NSUInteger idx,
                                                BOOL *_Nonnull stop) {
        [array enumerateObjectsUsingBlock:^(NSString *_Nonnull current,
                                            NSUInteger idx,
                                            BOOL *_Nonnull stop) {
            NSString *resultString = [previous stringByAppendingFormat:@"%@%@", kYCPinYinDefaultSeparator, current];
            [result addObject:resultString];
        }];
    }];
    return result;
}

static inline NSArray *removeToneFromArray(NSArray *pinyinArray) {
    NSMutableSet *set = [NSMutableSet setWithCapacity:pinyinArray.count];
    [pinyinArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj,
                                              NSUInteger idx,
                                              BOOL *_Nonnull stop) {
        [set addObject:[obj substringToIndex:obj.length - 1]];
    }];
    return [set allObjects];
}

static inline NSArray *convertPinYinWordsToPolyphoneArray(NSArray *pinyinArray) {
    __block NSArray *result = nil;
    [pinyinArray enumerateObjectsUsingBlock:^(NSArray *_Nonnull obj,
                                              NSUInteger idx,
                                              BOOL *_Nonnull stop) {
        NSArray *array = obj;
        BOOL tone = [YCPinYin sharedInstance].format & YCPinYinOutoutFormatTone;
        if (!tone) {
            array = removeToneFromArray(obj);
        }
        if (idx == 0) {
            result = array;
            return;
        }
        result = flattenJoinArray(array, result);
    }];
    return result;
}

static inline NSString *convertPolyphoneArrayToString(NSArray *polyphoneArray) {
    NSString *separator = [YCPinYin sharedInstance].separator;
    BOOL firstLetterFlag = [YCPinYin sharedInstance].format & YCPinYinOutoutFormatFirstLetter;
    BOOL allLetterFlag = [YCPinYin sharedInstance].format & YCPinYinOutoutFormatAllLetter;
    NSCAssert(firstLetterFlag || allLetterFlag, @"Please tell me what you want?");
    NSMutableString *firstLetter = [NSMutableString stringWithCapacity:0];
    NSMutableString *allLetter = [NSMutableString stringWithCapacity:0];

    [polyphoneArray enumerateObjectsUsingBlock:^(id _Nonnull obj,
                                                 NSUInteger idx,
                                                 BOOL *_Nonnull stop) {
        NSScanner *scanner = [NSScanner scannerWithString:obj];
        scanner.charactersToBeSkipped = [NSCharacterSet characterSetWithCharactersInString:kYCPinYinDefaultSeparator];
        NSString *letter = nil;
        NSMutableString *currentFirstLetter = [NSMutableString string];
        while ([scanner scanUpToString:kYCPinYinDefaultSeparator intoString:&letter]) {
            if (firstLetterFlag) {
                [currentFirstLetter appendString:[letter substringToIndex:1]];
            }
            if (allLetterFlag) {
                [allLetter appendString:letter];
            }
        }
        if (firstLetterFlag) {
            [currentFirstLetter appendString:separator];
            if (currentFirstLetter.length > 1 && [firstLetter rangeOfString:currentFirstLetter].length == 0) {
                [firstLetter appendString:currentFirstLetter];
            }
        }
        if (allLetterFlag) {
            [allLetter appendString:separator];
        }
    }];
    if (firstLetter && allLetterFlag) {
        [allLetter deleteCharactersInRange:NSMakeRange(allLetter.length - 1, 1)];
        return [firstLetter stringByAppendingString:allLetter];
    }
    if (firstLetter) {
        [firstLetter deleteCharactersInRange:NSMakeRange(firstLetter.length - 1, 1)];
        return firstLetter;
    }
    if (allLetterFlag) {
        [allLetter deleteCharactersInRange:NSMakeRange(allLetter.length - 1, 1)];
        return allLetter;
    }
    return nil;
}

@implementation NSString (YCPinYin)

- (NSString *)yc_toPinYin {
    return [self yc_toPinYinWithFormat:YCPinYinOutoutFormatDefault];
}

- (NSString *)yc_toPinYinWithFormat:(YCPinYinOutoutFormat)format {
    return [self yc_toPinYinWithFormat:format separator:nil];
}

- (NSString *)yc_toPinYinWithFormat:(YCPinYinOutoutFormat)format separator:(NSString *)separator {
    if (format == YCPinYinOutoutFormatDefault) {
        format = [YCPinYin sharedInstance].defaultFormat;
    }
    [YCPinYin sharedInstance].format = format;
    if (!separator) {
        separator = kYCPinYinDefaultSeparator;
    }
    [YCPinYin sharedInstance].separator = separator;
    NSString *key = [self stringByAppendingFormat:@"%zd%@", (unsigned long)[YCPinYin sharedInstance].format, [YCPinYin sharedInstance].separator];
    NSString *result = (NSString *)[[YCPinYin sharedInstance].queryCache objectForKey:key];
    if (result) {
        return result;
    }
    NSArray *pinyinArray = convertStringToPinYinWordsArray(self);
    NSArray *polyphoneArray = convertPinYinWordsToPolyphoneArray(pinyinArray);
    result = convertPolyphoneArrayToString(polyphoneArray);
    [[YCPinYin sharedInstance].queryCache setObject:result forKey:key];
    return result;
}

- (NSArray *)yc_matchToWord:(NSString *)word {
    BOOL isChinese = NO;
    if (word.length > 0) {
        unichar character = [word characterAtIndex:0];
        if (character > 0x4e00 && character < 0x9fff) {
            isChinese = YES;
        }
    }
    NSMutableArray *found = [NSMutableArray array];
    if (isChinese) {
        NSRange range = NSMakeRange(0, 0);
        while (range.location != NSNotFound) {
            range = [self rangeOfString:word options:NSCaseInsensitiveSearch range:NSMakeRange(NSMaxRange(range), self.length - NSMaxRange(range))];
            if (range.length != NSNotFound) {
                [found addObject:[NSValue valueWithRange:range]];
            }
        }
        return found;
    } else {
        NSArray *pinyinArray = [[self yc_toPinYinWithFormat:YCPinYinOutoutFormatFirstLetter] componentsSeparatedByString:@"#"];
        for (NSString *firstLetterPinyin in pinyinArray) {
            NSRange range = NSMakeRange(0, 0);
            while (range.location != NSNotFound) {
                range = [firstLetterPinyin rangeOfString:word options:NSCaseInsensitiveSearch range:NSMakeRange(NSMaxRange(range), self.length - NSMaxRange(range))];
                if (range.length != NSNotFound) {
                    [found addObject:[NSValue valueWithRange:range]];
                }
            }
        }
    }
    return found;
}

@end
