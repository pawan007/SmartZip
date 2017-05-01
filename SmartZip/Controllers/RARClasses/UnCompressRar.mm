//
//  UnCompressRar.m
//  UnrarExample
//
//  Created by Pawan Dhawan on 01/05/17.
//
//

#import "UnCompressRar.h"

@implementation UnCompressRar

- (void)uncompressFiles:(NSString*)inFilePath{
    
    Unrar4iOS *unrar = [[Unrar4iOS alloc] init];
    BOOL ok = [unrar unrarOpenFile:inFilePath];
    if (ok) {
        NSArray *array = [inFilePath componentsSeparatedByString:@"."];
        BOOL ok2 =  [unrar unrarFileTo:array.firstObject overWrite:YES];
        if (ok2) {
            [unrar unrarCloseFile];
        }
    }
    else
        [unrar unrarCloseFile];

}

@end
