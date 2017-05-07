// automatically generated, do not modify !!!

/**
 *文理结构
 */
#import "FBTable.h"
#import "JasonFlatTestTextureData.h"
#import "JasonFlatTestTestAppend.h"


@interface JasonFlatTestTexture : FBTable 

@property (nonatomic, strong)NSString *texture_name;

@property (nonatomic, assign)int16_t num_textures;

@property (nonatomic, strong)FBMutableArray<JasonFlatTestTextureData *> *textures;

@property (nonatomic, assign)int16_t num_test;

@property (nonatomic, assign)int16_t num_test2;

@property (nonatomic, strong)JasonFlatTestTestAppend *test_append;

/// get json obj from flatbuffer
- (NSDictionary *) getJsonObj;
@end
