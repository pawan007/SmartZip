//
//  Extract7z.h
//  lzmaSDK
//
//  Created by Pawan Dhawan on 04/05/17.
//
//

#import <Foundation/Foundation.h>

@interface Extract7z : NSObject

- (void) testFilesAndDirs;
- (void)uncompressFiles:(NSString*)inFilePath;
- (void)uncompressFilesFromOutside:(NSString*)inFilePath;

@end
