//
//  TranscriptionMap.h
//  pdbtotxt
//
//  Created by Yevhen Triukhan on 21.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranscriptionMap : NSObject

@property (nonatomic, strong) NSMutableDictionary *map;


+ (instancetype)sharedInstance;
- (NSUInteger)count;
@end
