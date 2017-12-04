#import <Foundation/Foundation.h>

@class AVAsset;

@interface FBAVAssetReverse : NSObject

+ (AVAsset *)assetByReversingAsset:(AVAsset *)asset outputURL:(NSURL *)outputURL;

@end
