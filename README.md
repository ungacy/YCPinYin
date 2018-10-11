# YCPinYin

[![CI Status](http://img.shields.io/travis/ungacy/YCPinYin.svg?style=flat)](https://travis-ci.org/ungacy/YCPinYin)
[![Version](https://img.shields.io/cocoapods/v/YCPinYin.svg?style=flat)](http://cocoapods.org/pods/YCPinYin)
[![License](https://img.shields.io/cocoapods/l/YCPinYin.svg?style=flat)](http://cocoapods.org/pods/YCPinYin)
[![Platform](https://img.shields.io/cocoapods/p/YCPinYin.svg?style=flat)](http://cocoapods.org/pods/YCPinYin)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

Installation
==========================

### Installation with CocoaPods

YCEasyTool is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "YCPinYin"
```

### Installation with Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate `YCPinYin` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "ungacy/YCPinYin"
```

Run `carthage` to build the frameworks and drag the appropriate framework (`YCPinYin.framework`) into your Xcode project according to your need. Make sure to add only one framework and not both.

## Usage

### 首字母

 设置输出格式,初始化一次就好.
 
```objective-c
[YCPinYin sharedInstance].defaultFormat = YCPinYinOutoutFormatFirstLetter;
```

用吧

```objective-c
NSString *string = @"你好";
NSString *pinyin = [string yc_toPinYin];//nh
NSParameterAssert([pinyin isEqualToString:@"nh"]);
```

###  全部字母


 设置输出格式,初始化一次就好.
 
```objective-c
[YCPinYin sharedInstance].defaultFormat = YCPinYinOutoutFormatAllLetter;
```

用吧

```objective-c
NSString *string = @"你好";
NSString *pinyin = [string yc_toPinYin];//nihao
NSParameterAssert([pinyin isEqualToString:@"nihao"]);
```

### 首字母+全部字母

 设置输出格式,初始化一次就好.
 
```objective-c
[YCPinYin sharedInstance].defaultFormat = YCPinYinOutoutFormatDefault;
```

or

```objective-c
[YCPinYin sharedInstance].defaultFormat = YCPinYinOutoutFormatAllLetter | YCPinYinOutoutFormatFirstLetter;
```

用吧

```objective-c
NSString *string = @"你好";
NSString *pinyin = [string yc_toPinYin];//nh#nihao
NSParameterAssert([pinyin isEqualToString:@"nh#nihao"]);
```

### 多音字

```
`单贝` => `db#cb#sb#danbei#chanbei#shanbei` or `db#cb#sb` or `danbei#chanbei#shanbei`
```

### 声调

感觉用处不多,见demo

### 更多

见demo

## Author

ungacy, ungacy@126.com

## License

YCPinYin is available under the MIT license. See the LICENSE file for more info.
