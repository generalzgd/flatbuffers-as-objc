// automatically generated, do not modify !!!

#import "JasonFlatTestColorFactory.h"


@implementation JasonFlatTestColorFactory

+ (instancetype)getInstance:(uint32_t)protocolId buf:(NSMutableData *)buf {
	switch (protocolId) {
		case 1:
			return [JasonFlatTestRad getRootAs:(FBMutableData *)buf];
		case 2:
			return [JasonFlatTestGreen getRootAs:(FBMutableData *)buf];
		case 3:
			return [JasonFlatTestBlue getRootAs:(FBMutableData *)buf];
		default:
			break;
	}
	return nil;
}

@end
