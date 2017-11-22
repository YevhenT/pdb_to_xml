//
//  TranscriptionMap.m
//  pdbtotxt
//
//  Created by Yevhen Triukhan on 21.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "TranscriptionMap.h"

@interface TranscriptionMap ()


@end

@implementation TranscriptionMap

+ (instancetype)sharedInstance{
    static TranscriptionMap *_sharedMap = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedMap = [[self alloc] init];

    });
    
    return _sharedMap;
}



- (instancetype)init{
    self = [super init];
    if (self) {
        _map = @{@"q": @"ə",
                 @"x": @"æ",
                 @"2": @"ɑ:",
                 @"3": @"œ̃",
                 @"Q": @"ɑ",
                 @"W": @"ə:",
                 @"E": @"ɜ",
                 @"R": @"ɑ:",
                 @"T": @"θ",
                 @"Y": @"ɛ̃",
                 @"U": @"ã",
                 @"I": @"i",
                 @"O": @"ø",
                 @"P": @"ɔ",
                 @"A": @"ʌ",
                 @"S": @"ʃ",
                 @"D": @"ð",
                 @"F": @"ɛ",
                 @"G": @"ʤ",
                 @"H": @"u:",
                 @"J": @"i:",
                 @"K": @"ɔ̃",
                 @"L": @"ɔ:",
                 @"Z": @"ʒ",
                 @"X": @"œ",
                 @"C": @"ʧ",
                 @"V": @"ʋ",
                 @"B": @"ɥ",
                 @"N": @"ŋ",
                 @"M": @"ɲ",}.mutableCopy;
    }
    
    return self;
}

- (NSUInteger)count{
    return self.map.count;
}

@end
