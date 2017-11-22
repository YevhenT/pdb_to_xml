//
//  PDBParser.m
//  pdbtotxt
//
//  Created by Yevhen Triukhan on 21.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import "PDBParser.h"
#import "TranscriptionMap.h"

@interface PDBParser ()

@property (nonatomic, strong) TranscriptionMap *transMap;

@end



@implementation PDBParser



- (NSMutableDictionary*) parseDataPDB: (NSData*)dataPDB{
    DatabaseHdrType header;
    [dataPDB getBytes:&header length:sizeof(header)];
    int numberOfRecords = CFSwapInt16HostToBig(header.numberOfRecords);
    if (numberOfRecords == 0) {
        return nil;
    }
    RecordInfo info;
    int headerSize = sizeof(header);
    int infoSize = sizeof(info);
    long archiveEnd = dataPDB.length;
    
    
    int currRecordOffset = 0;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    
#warning надо метод разбить на два, разбор заголовков и разбор записей
    //это перебор структур хранящих информацию о конкретных записях
    for (UInt32 index = 0; index < numberOfRecords; index++) {
        
        int recordLocation = headerSize + (infoSize * index);
        NSRange range = {.location = recordLocation, .length = infoSize};
        
        
        
        [dataPDB getBytes:&info range:range];
        currRecordOffset = CFSwapInt16HostToBig(info.highPartOffset);
        //в этот момент у меня есть смещения очередной записи, но нет ее длинны
        
        int wordSize = 0;
        long bufferSize = 500;
        if(currRecordOffset + bufferSize > archiveEnd) {
            bufferSize = archiveEnd - currRecordOffset;
        }
        
        char* buffer = malloc(bufferSize);
        
        NSMutableArray *array = [NSMutableArray new];
        
        for (int i = 0; i < 3; i++) {
            [dataPDB getBytes:buffer range:(NSRange){currRecordOffset, bufferSize}];
            

            
            //нужна защит от непр кодировок
            NSString *str = [NSString stringWithCString:buffer
                                               encoding:NSUTF8StringEncoding];
            if (!str) {
                str = [NSString stringWithCString:buffer
                                         encoding:NSWindowsCP1251StringEncoding];
            } else if (!str) {
                NSLog(@"не достаточно вариантов кодировки");
            }

            
            if (i == 1) {
                str = [self decode:str];
            }
            
            
            
            wordSize = (int)str.length;
            currRecordOffset = currRecordOffset + wordSize + 1;
            bufferSize = bufferSize - wordSize - 1;
            [array addObject:str];
        }
        [dict setObject:array forKey:[NSString stringWithFormat:@"%d", index]];
    }
    return dict;
}

- (NSString*)decode:(NSString*)string{
    //В этом методе я получаю строку и должен просмотреть ее и заменить отдельные
    //символ на соотв из таблицы.
//    CFStringRef string = [string UTF8String];
    NSMutableString *tempStr = [NSMutableString stringWithString:string];
    NSRange range = {};
    
    for (NSString *key in self.transMap.map) {
        range = [string rangeOfString:key];
        if (range.length > 0){
            [tempStr replaceCharactersInRange:range
                                  withString:[self.transMap.map valueForKey:key]];
        }
    }

    NSString *decodedStr = [NSString stringWithString:tempStr];
    

    
    return decodedStr;
}


- (void) printHeader:(DatabaseHdrType) header{
//    NSLog(@"name : %s", header.name);
//    NSLog(@"attributes : %x", CFSwapInt16HostToBig(header.attributes));
//    NSLog(@"version : %d", CFSwapInt16HostToBig(header.version));
//    NSLog(@"creationDate : %d", CFSwapInt32HostToBig(header.creationDate));
//    NSLog(@"creationDate : %d", CFSwapInt32HostToBig(header.modificationDate));
//    NSLog(@"modificationDate : %d", CFSwapInt32HostToBig(header.lastBackupDate));
//    NSLog(@"modificationNumber : %d", CFSwapInt32HostToBig(header.modificationNumber));
//    NSLog(@"appInfoID : %d", CFSwapInt32HostToBig(header.appInfoID));
//    NSLog(@"sortInfoID : %d", CFSwapInt32HostToBig(header.sortInfoID));
//    NSLog(@"type : %c%c%c%c", header.type[0],header.type[1],header.type[2],header.type[3]);
//    NSLog(@"creator : %c%c%c%c", header.creator[0],header.creator[1],header.creator[2],header.creator[3]);
//    NSLog(@"uniqueIDSeed : %d", header.uniqueIDSeed);
//    NSLog(@"nextRecordList : %d", header.nextRecordList);
//    NSLog(@"numberOfRecords : %d", CFSwapInt16HostToBig(header.numberOfRecords));
}

- (TranscriptionMap*)transMap{
    if (!_transMap) {
        _transMap = [TranscriptionMap sharedInstance];
    }
    return _transMap;
}

@end
