//
//  PDBParser.h
//  pdbtotxt
//
//  Created by Yevhen Triukhan on 21.11.17.
//  Copyright (c) 2017 Yevhen Triukhan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kPDBExtension = @"pdb";

typedef struct {
    UInt8           name[32];
    UInt16          attributes;
    UInt16          version;
    UInt32          creationDate;
    UInt32          modificationDate;
    UInt32          lastBackupDate;
    UInt32          modificationNumber;
    UInt32          appInfoID;
    UInt32          sortInfoID;
    char            type[4];
    char            creator[4];
    UInt32          uniqueIDSeed;
    UInt32          nextRecordList;
    UInt16          numberOfRecords;
} DatabaseHdrType;

typedef struct {
    UInt16          highPartOffset;
    UInt16          lowPartOffset;
    UInt32           recordID;
    
} RecordInfo;

@interface PDBParser : NSObject

- (NSMutableDictionary*) parseDataPDB: (NSData*)dataPDB;
//- (void)decode:(NSString*)string;


@end
