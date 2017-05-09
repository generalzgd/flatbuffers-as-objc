// automatically generated, do not modify !!!

/**
 *文理数据结构
 */
#import "JasonFlatTestTextureData.h"

@implementation JasonFlatTestTextureData 

- (int32_t) image_size {

    _image_size = [self fb_getInt32:4 origin:_image_size];

    return _image_size;

}

- (void) add_image_size {

    [self fb_addInt32:_image_size voffset:4 offset:4];

    return ;

}

- (FBMutableArray<NSNumber *> *) image_data {

    _image_data = [self fb_getNumbers:6 origin:_image_data type:FBNumberUint8];

    return _image_data;

}

- (void) add_image_data {

    [self fb_addNumbers:_image_data voffset:6 offset:8 type:FBNumberUint8];

    return ;

}

- (int32_t) test_num2 {

    _test_num2 = [self fb_getInt32:8 origin:_test_num2];

    return _test_num2;

}

- (void) add_test_num2 {

    [self fb_addInt32:_test_num2 voffset:8 offset:12];

    return ;

}

- (int16_t) image_test {

    _image_test = [self fb_getInt16:10 origin:_image_test];

    return _image_test;

}

- (void) add_image_test {

    [self fb_addInt16:_image_test voffset:10 offset:16];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 18;

        origin_size = 18+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:12 offset:bb_pos];

        [bb setInt16:12 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:18 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

/// get json obj from flatbuffer
- (NSDictionary *) getJsonObj {
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	FBMutableArray *vec; int i; NSMutableArray *arr;

	[dic setValue:@([self image_size]) forKey:@"image_size"];
	vec = [self image_data];
	arr = [NSMutableArray array];
	for(i=0; i<vec.count; i++){
		[arr addObject:[vec objectAtIndex:i]];
	}
	[dic setValue:arr forKey:@"image_data"];
	[dic setValue:@([self test_num2]) forKey:@"test_num2"];
	[dic setValue:@([self image_test]) forKey:@"image_test"];
	return dic;
}
@end
