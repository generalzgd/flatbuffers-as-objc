// automatically generated, do not modify !!!

/**
 *testAppend注释
 */
#import "JasonFlatTestTestAppend.h"

@implementation JasonFlatTestTestAppend 

- (int32_t) test_num {

    _test_num = [self fb_getInt32:4 origin:_test_num];

    return _test_num;

}

- (void) add_test_num {

    [self fb_addInt32:_test_num voffset:4 offset:4];

    return ;

}

- (int32_t) test_num2 {

    _test_num2 = [self fb_getInt32:6 origin:_test_num2];

    return _test_num2;

}

- (void) add_test_num2 {

    [self fb_addInt32:_test_num2 voffset:6 offset:8];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 14;

        origin_size = 12+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:8 offset:bb_pos];

        [bb setInt16:8 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:12 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

/// get json obj from flatbuffer
- (NSDictionary *) getJsonObj {
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

	[dic setValue:@([self test_num]) forKey:@"test_num"];
	[dic setValue:@([self test_num2]) forKey:@"test_num2"];
	return dic;
}
@end
