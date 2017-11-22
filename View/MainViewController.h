//
//  MainViewController.h
//  pdbtotxt
//
//  Created by Yevhen Triukhan on 17.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainViewController : NSViewController

@property (nonatomic, weak) IBOutlet NSTextField * recordsCount;
@property (nonatomic, strong) IBOutlet NSTextView * recordsList;
@property (weak) IBOutlet NSButton *exportButton;

- (void)reloadViewWith:(NSMutableDictionary*)dictionary;
@end
