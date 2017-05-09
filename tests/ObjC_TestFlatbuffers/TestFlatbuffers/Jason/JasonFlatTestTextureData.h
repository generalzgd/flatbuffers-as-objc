// automatically generated, do not modify !!!

/**
 *文理数据结构
 */
#import "FBTable.h"


@interface JasonFlatTestTextureData : FBTable 

@property (nonatomic, assign)int32_t image_size;

@property (nonatomic, strong)FBMutableArray<NSNumber *> *image_data;

@property (nonatomic, assign)int32_t test_num2;

@property (nonatomic, assign)int16_t image_test;

/// get json obj from flatbuffer
- (NSDictionary *) getJsonObj;
@end
