//
//  Extract7z.m
//  lzmaSDK
//
//  Created by Pawan Dhawan on 04/05/17.
//
//
#import "LZMAExtractor.h"
#import "RarClasses.h"
#import "Extract7z.h"
#import "SmartZip-swift.h"

@implementation Extract7z


- (void) testFilesAndDirs
{
    NSString *archiveFilename = @"files_dirs.7z";
    NSString *archiveResPath = [[NSBundle mainBundle] pathForResource:archiveFilename ofType:nil];
    NSAssert(archiveResPath, @"can't find %@", archiveFilename);
    
    NSArray *contents = [LZMAExtractor extract7zArchive:archiveResPath
                                                dirName:NSTemporaryDirectory()
                                            preserveDir:TRUE];
    if (contents.count > 0) {
        NSLog(@"FIle unzip successfully");
    }
    
    
}

- (void) uncompressFiles:(NSString*)inFilePath
{
    UnZipExternal* abc = [UnZipExternal new];
    NSString *path = [abc tempUnzipPathWith7zWithZipPath:inFilePath];
    
    NSArray *contents = [LZMAExtractor extract7zArchive:inFilePath
                                                dirName:path
                                            preserveDir:TRUE];
    if (contents.count > 0) {
        NSLog(@"FIle unzip successfully");
    }

    
}


- (void)uncompressFilesFromOutside:(NSString*)inFilePath{
    
    NSString *folderPath = [[CommonFunctions sharedInstance] docDirPath];
    NSString* fileName = [[inFilePath lastPathComponent] stringByReplacingOccurrencesOfString:@".7z" withString:@""];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@", folderPath,fileName];
    
    UnZipExternal* abc = [UnZipExternal new];
    NSString *path = [abc tempUnzipPathWith7zWithZipPath:filePath];
    
    NSArray *contents = [LZMAExtractor extract7zArchive:inFilePath
                                                dirName:path
                                            preserveDir:TRUE];
    if (contents.count > 0) {
        NSLog(@"FIle unzip successfully");
    }
    
    
}


@end
