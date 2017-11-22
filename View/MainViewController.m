//
//  MainViewController.m
//  pdbtotxt
//
//  Created by Yevhen Triukhan on 17.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()
@property (weak) IBOutlet NSTextField *engLabel;
@property (weak) IBOutlet NSTextField *transLabel;
@property (weak) IBOutlet NSTextField *rusLabel;
@property (weak) IBOutlet NSArray *checkList;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)loadView{
    [super loadView];
    [self.exportButton setEnabled:NO];
}

- (void)reloadViewWith:(NSMutableDictionary*)dictionaries{
    
#warning only one array yet
    NSMutableDictionary *dictionary = [[dictionaries allValues] firstObject];
    
    
    self.recordsCount.stringValue = [NSString stringWithFormat:@"%lu", dictionary.count];
        [self.exportButton setEnabled:YES];
    //вывод данных в таблицу, перенести в ВьюКонтроллер
    NSString *dictAsString = @"";
    NSString *russianString;
    NSString *transcriptionString;
    NSString *englishString;
    
    for (int index = 0; index < dictionary.count; index++) {
        NSString *indexString = [[NSNumber numberWithInt:index] stringValue];
        NSArray *recordArray = [NSArray arrayWithArray: dictionary[indexString]];
        englishString = recordArray[0];
        transcriptionString = recordArray[1];
        russianString = recordArray[2];
        
        

    
        
        
        //@"%-26s%-26s%@\n"
        NSString *recordString = [NSString stringWithFormat:@"%-30s%s\n",
                                  [englishString UTF8String],
                                  [russianString cStringUsingEncoding:NSWindowsCP1251StringEncoding]];
        //        NSLog(@"%@", recordString);
        dictAsString = [dictAsString stringByAppendingString:recordString];
    }
    
    //    NSLog(@"dict as string %@", dictAsString);
    [self.recordsList setFont:[NSFont fontWithName:@"Courier" size:12]];
    [self.recordsList setString:dictAsString ];
}

#pragma mark -
#pragma mark Controls
- (IBAction)openButton:(NSButton *)sender {
//    [self openDocument:nil];
}
- (IBAction)exportButton:(NSButton *)sender {
}


@end
