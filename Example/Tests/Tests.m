//
//  YCPinYinTests.m
//  YCPinYinTests
//
//  Created by ungacy on 02/24/2017.
//  Copyright (c) 2017 ungacy. All rights reserved.
//

@import XCTest;
@import YCPinYin;

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSString *string = @"你好";
    NSString *pinyin;
    
    pinyin = [string yc_toPinYin];
    XCTAssertTrue([pinyin isEqualToString:@"nh#nihao"]);
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatFirstLetter];
    XCTAssertTrue([pinyin isEqualToString:@"nh"]);
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatAllLetter];
    XCTAssertTrue([pinyin isEqualToString:@"nihao"]);
    
    string = @"单贝";
    pinyin = [string yc_toPinYin];
    XCTAssertTrue([pinyin isEqualToString:@"db#cb#sb#danbei#chanbei#shanbei"]);
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatFirstLetter];
    XCTAssertTrue([pinyin isEqualToString:@"db#cb#sb"]);
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatAllLetter];
    XCTAssertTrue([pinyin isEqualToString:@"danbei#chanbei#shanbei"]);
    
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatAllLetter separator:@"$"];
    XCTAssertTrue([pinyin isEqualToString:@"danbei$chanbei$shanbei"]);
    
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatAllLetter | YCPinYinOutoutFormatTone];
    XCTAssertTrue([pinyin isEqualToString:@"dan1bei4#chan2bei4#shan4bei4"]);
}

@end

