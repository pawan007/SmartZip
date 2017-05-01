//
//  RarClasses.m
//  SmartZip
//
//  Created by Pawan Dhawan on 01/05/17.
//  Copyright © 2017 Pawan Kumar. All rights reserved.
//

#import "URKArchive.h"
#import "RarClasses.h"

@implementation RarClasses


- (void)uncompressFiles:(NSString*)inFilePath{
    
    NSArray *array = [inFilePath componentsSeparatedByString:@"."];
    NSError *archiveError = nil;
    URKArchive *archive = [[URKArchive alloc] initWithPath:inFilePath error:&archiveError];
    NSError *error = nil;
    
    NSString *folderPath = [NSString stringWithFormat:@"%@",array.firstObject];
    
    BOOL extractFilesSuccessful =  [archive extractFilesTo:folderPath overwrite:NO progress:^(URKFileInfo *currentFile, CGFloat percentArchiveDecompressed) {
        NSLog(@"Extracting %@: %f%% complete", @"", percentArchiveDecompressed);
    } error:&error];
    
    if (extractFilesSuccessful) {
        NSLog(@"Successful");
    }
    
}


@end
