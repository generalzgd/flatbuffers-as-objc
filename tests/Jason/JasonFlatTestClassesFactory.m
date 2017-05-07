// automatically generated, do not modify !!!

#import "JasonFlatTestClassesFactory.h"


@implementation JasonFlatTestClassesFactory

+ (NSObject *)getInstance:(uint32_t)protocolId buf:(NSMutableData *)buf {
	switch (protocolId) {
		case 1:
			return [JasonFlatTestTestAppend getRootAs:(FBMutableData *)buf];
		case 2:
			return [JasonFlatTestTextureData getRootAs:(FBMutableData *)buf];
		case 3:
			return [JasonFlatTestTexture getRootAs:(FBMutableData *)buf];
		default:
			break;
	}
	return nil;
}

@end
