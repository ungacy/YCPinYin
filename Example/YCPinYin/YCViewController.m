//
//  YCViewController.m
//  YCPinYin
//
//  Created by ungacy on 02/24/2017.
//  Copyright (c) 2017 ungacy. All rights reserved.
//

#import "YCViewController.h"
#import "YCPinYin.h"

@interface YCViewController ()

@end

@implementation YCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *string = @"你好";
    NSString *pinyin;
    
    [YCPinYin sharedInstance].defaultFormat = YCPinYinOutoutFormatFirstLetter | YCPinYinOutoutFormatAllLetter;
    
    pinyin = [string yc_toPinYin];
    NSParameterAssert([pinyin isEqualToString:@"nh#nihao"]);
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatFirstLetter];
    NSParameterAssert([pinyin isEqualToString:@"nh"]);
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatAllLetter];
    NSParameterAssert([pinyin isEqualToString:@"nihao"]);
    
    string = @"单贝";
    pinyin = [string yc_toPinYin];
    NSParameterAssert([pinyin isEqualToString:@"db#cb#sb#danbei#chanbei#shanbei"]);
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatFirstLetter];
    NSParameterAssert([pinyin isEqualToString:@"db#cb#sb"]);
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatAllLetter];
    NSParameterAssert([pinyin isEqualToString:@"danbei#chanbei#shanbei"]);
    
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatAllLetter separator:@"$"];
    NSParameterAssert([pinyin isEqualToString:@"danbei$chanbei$shanbei"]);
    
    pinyin = [string yc_toPinYinWithFormat:YCPinYinOutoutFormatAllLetter | YCPinYinOutoutFormatTone];
    NSParameterAssert([pinyin isEqualToString:@"dan1bei4#chan2bei4#shan4bei4"]);
	// Do any additional setup after loading the view, typically from a nib.
    
    string = @"iOS好";
    pinyin = [string yc_toPinYin];
    NSParameterAssert([pinyin isEqualToString:@"ih#iOShao"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
