// automatically generated, do not modify !!!

/**
 *文理结构
 */
#import "JasonFlatTestTexture.h"

@implementation JasonFlatTestTexture 

- (NSString *) texture_name {

    _texture_name = [self fb_getString:4 origin:_texture_name];

    return _texture_name;

}

- (void) add_texture_name {

    [self fb_addString:_texture_name voffset:4 offset:4];

    return ;

}

- (int16_t) num_textures {

    _num_textures = [self fb_getInt16:6 origin:_num_textures];

    return _num_textures;

}

- (void) add_num_textures {

    [self fb_addInt16:_num_textures voffset:6 offset:8];

    return ;

}

- (FBMutableArray<JasonFlatTestTextureData *> *) textures {

    _textures = [self fb_getTables:8 origin:_textures className:[JasonFlatTestTextureData class]];

    return _textures;

}

- (void) add_textures {

    [self fb_addTables:_textures voffset:8 offset:10];

    return ;

}

- (int16_t) num_test {

    _num_test = [self fb_getInt16:10 origin:_num_test];

    return _num_test;

}

- (void) add_num_test {

    [self fb_addInt16:_num_test voffset:10 offset:14];

    return ;

}

- (int16_t) num_test2 {

    _num_test2 = [self fb_getInt16:14 origin:_num_test2];

    return _num_test2;

}

- (void) add_num_test2 {

    [self fb_addInt16:_num_test2 voffset:14 offset:16];

    return ;

}

- (JasonFlatTestTestAppend *) test_append {

    _test_append = [self fb_getTable:16 origin:_test_append className:[JasonFlatTestTestAppend class]];

    return _test_append;

}

- (void) add_test_append {

    [self fb_addTable:_test_append voffset:16 offset:18];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 24;

        origin_size = 22+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:18 offset:bb_pos];

        [bb setInt16:18 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:22 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

/// get json obj from flatbuffer
- (NSDictionary *) getJsonObj {
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
	FBMutableArray *vec,int len, int i,NSMutableArray *arr;

	[dic setValue:[self texture_name] forKey:@"texture_name"]
	[dic setValue:[self num_textures] forKey:@"num_textures"]
	vec = [self textures]
	len = [vec count]
	arr = [NSMutableArray arrayWithCapacity:len];
	for(i=0; i<len; i++){
		[arr addObject:[[vec objectAtIndex:i] getJsonObj]]
	}
	[dic setValue:arr forKey:@"textures"]
	[dic setValue:[self num_test] forKey:@"num_test"]
	[dic setValue:[self num_test2] forKey:@"num_test2"]
	[dic setValue:[[self test_append] getJsonObj] forKey:@"test_append"]
	return dic;
}
@end
