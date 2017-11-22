//
//  AppDelegate.m
//  pdbtotxt
//
//  Created by Yevhen Triukhan on 14.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreFoundation/CoreFoundation.h"

#import "MainViewController.h"
#import "PDBParser.h"

@interface AppDelegate()
@property (nonatomic, strong) MainViewController *mainVC;
@property (nonatomic, weak) IBOutlet NSView *mainView;
@property (nonatomic, strong) NSMutableDictionary *dictOfDict;

@property (nonatomic, strong) PDBParser *parser;

@end



@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.mainVC = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    [self.mainView replaceSubview:self.mainView.subviews[0]
                             with:self.mainVC.view];
#warning delete!
    [self loadArchivesFromURLs:@[[NSURL URLWithString:@"file:///Volumes/HDD/Google%20%D0%94%D0%B8%D1%81%D0%BA/English/activedict.pdb"]]];
}



#pragma mark
#pragma mark Menu Methods
#pragma mark Open

- (void)openDocument:(id)sender{
    
    if (self.dictOfDict.count > 0) {
        [self.dictOfDict removeAllObjects];
    }
    
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    [openDlg setAllowedFileTypes:@[kPDBExtension]];
    [openDlg setAllowsMultipleSelection:YES];
//    [openDlg setCanChooseDirectories:YES];
    NSInteger result = [openDlg runModal];
    
    if (result == NSOKButton) {
        [self loadArchivesFromURLs:[openDlg URLs]];
    }
}

- (void)loadArchivesFromURLs:(NSArray*)URLs{
    
    for (NSURL *URL in URLs) {

        NSData *dataPDB = [[NSData alloc]initWithContentsOfURL:URL];
        //здесь еще должна быть обработка на ошибочный ввод данных
        //добавляется очередной массив
        NSString *dictFileName =
        [[URL.absoluteString componentsSeparatedByString:@"/"] lastObject];
        NSString *dictName = [[dictFileName componentsSeparatedByString:@"."] firstObject];
        [self.dictOfDict setObject:[self.parser parseDataPDB:dataPDB]
                            forKey:dictName];
    }

    
    [self.mainVC reloadViewWith:self.dictOfDict];

  
}

#pragma mark Export
- (IBAction)exportDocuments:(id)sender{
    if (self.dictOfDict.count == 0) {
        //алерт с предложением выбрать словарь
        return;
    }
#warning нужно сделать перебор типов
    int exportType = 1;
    NSString *extension;
    if (exportType) {
        extension = @"plist";
    }
    
    //создать диалоговое окно SaveAs
    NSSavePanel *saveDlg = [NSSavePanel savePanel];
    [saveDlg setAllowedFileTypes:@[extension]];
    //если словарь один -- то его имя
    if (self.dictOfDict.count == 1) {
        [saveDlg setNameFieldStringValue:[[self.dictOfDict allKeys] firstObject]];
    }
    else {
        [saveDlg setNameFieldStringValue:@"filename"];
        [saveDlg setMessage:@"File name will be ignore."];
    }
    
    //открыть диалоговое окно и сохранить по нажатию ОК
    NSInteger result = [saveDlg runModal];
    
    if (result == NSOKButton) {
        NSURL *dirURL = [saveDlg directoryURL];
 
        
        for (NSString *key in self.dictOfDict) {
            //можно получить ключ по значению и создать новый путь
            NSString *fileName = [NSString stringWithFormat:@"%@.%@", key, extension];
            NSURL *fileURL = [dirURL URLByAppendingPathComponent:fileName];
            
            [[self.dictOfDict valueForKey:key] writeToURL:fileURL atomically:YES];
        }
    }
}



#pragma mark Parser init
- (PDBParser*) parser{
    if (!_parser) {
        _parser = [PDBParser new];
    }
    return _parser;
}

#pragma mark dictOfDict init
- (NSMutableDictionary*)dictOfDict{
    if (!_dictOfDict) {
        _dictOfDict = [NSMutableDictionary new];
    }
    return _dictOfDict;
}

@end
