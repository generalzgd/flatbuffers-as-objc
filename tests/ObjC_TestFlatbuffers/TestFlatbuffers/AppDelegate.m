//
//  AppDelegate.m
//  TestFlatbuffers
//
//  Created by zhangguodong on 2017/5/7.
//  Copyright © 2017年 zhangguodong. All rights reserved.
//

#import "AppDelegate.h"

#import "JasonFlatTestTestAppend.h"
#import "JasonFlatTestTexture.h"
#import "JasonFlatTestTextureData.h"
//#import "JasonFlatTestClasses.h"
#import "JasonFlatTestClassesFactory.h"
#import "JasonFlatTestColor.h"
#import "JasonFlatTestClasses.h"
//#import "FBMutableArray.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    //example 1
    //with basic type in struct
//    JasonFlatTestTestAppend *testAppend = [[JasonFlatTestTestAppend alloc] init];
//    testAppend.test_num = 35;
//    testAppend.test_num2 = 88;
//    
//    NSDictionary *dic = [testAppend getJsonObj];
//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
//    if([jsonData length] > 0 && error == nil) {
//        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
//        NSLog(@"data:%@",jsonString);
//    }
//    
//    NSData *bytes = [testAppend getData];
//    NSString *base64 = [bytes base64EncodedStringWithOptions:0];
//    NSLog(@"data:%@", base64);
//
//    bool res = [JasonFlatTestTestAppend verifier:bytes];
//    NSLog(@"data:%d", res);
//    FBMutableData* bb = [[FBMutableData alloc]initWithData:bytes];
//    JasonFlatTestTestAppend* inst = [JasonFlatTestTestAppend getRootAs:bb];
//    NSLog(@"data:%d", inst.test_num);
//    NSLog(@"data:%d", inst.test_num2);
    
    //example 2
    //with array type in struct
//    JasonFlatTestTextureData *data = [[JasonFlatTestTextureData alloc] init];
//    data.image_size = 30;
//    data.image_test = 90;
//    data.test_num2 = 88;
//    
//    FBMutableArray<NSNumber*>*arr = [[FBMutableArray alloc] init];
//    [arr addObject:@(899)];
//    [arr addObject:@(12)];
//    
//    data.image_data = arr;
//    
//    NSData *bytes = [data getData];
//    NSString *base64 = [bytes base64EncodedStringWithOptions:0];
//    NSLog(@"base64:%@", base64);
//    
//    bool res = [JasonFlatTestTextureData verifier:bytes];
//    NSLog(@"res:%d", res);
//    FBMutableData* bb = [[FBMutableData alloc] initWithData:bytes];
//    JasonFlatTestTextureData *inst = [JasonFlatTestTextureData getRootAs:bb];
//    
//    NSDictionary *dic = [inst getJsonObj];
//    NSError *error = nil;
//    NSData *json = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
//    if([json length] >0 && error == nil ){
//        NSString *jsonStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
//        NSLog(@"data:%@", jsonStr);
//    }
    
    //example 3
    //1. with struct/string/array type in struct
    //2. use factury to get instance
    JasonFlatTestTexture *texture = [[JasonFlatTestTexture alloc] init];
    texture.texture_name = @"texture_name";
    texture.num_textures = 2;
    texture.num_test = 2;
    texture.num_test2 = 3;
    
    JasonFlatTestTestAppend *app = [[JasonFlatTestTestAppend alloc] init];
    app.test_num = 33;
    app.test_num2 = 44;
    texture.test_append = app;
    
    FBMutableArray<JasonFlatTestTextureData *> *ts = [[FBMutableArray alloc] init];
    for(int i=1; i<3; i++) {
        JasonFlatTestTextureData *data = [[JasonFlatTestTextureData alloc] init];
        data.image_size = 1024*i;
        data.image_test = 255*i;
        
        FBMutableArray<NSNumber *> *arr = [[FBMutableArray alloc] init];
        [arr addObject:@(345)];
        [arr addObject:@(543)];
        
        data.image_data = arr;
        
        [ts addObject:data];
    }
    texture.textures = ts;
    
    
    NSData *bytes = [texture getData];
    NSString *base64 = [bytes base64EncodedStringWithOptions:0];
    NSLog(@"data:%@", base64);
    
    bool res = [JasonFlatTestTexture verifier:bytes];
    NSLog(@"res:%d", res);
    
    FBMutableData* bb = [[FBMutableData alloc] initWithData:bytes];
    JasonFlatTestTexture *inst = (JasonFlatTestTexture *)[JasonFlatTestClassesFactory getInstance:JasonFlatTestTexture_ buf:bb];
    //JasonFlatTestTexture *inst = [JasonFlatTestTexture getRootAs:bb];
    
    NSDictionary *dic = [inst getJsonObj];
    NSError *error = nil;
    NSData *json = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if([json length] >0 && error == nil ){
        NSString *jsonStr = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
        NSLog(@"data:%@", jsonStr);
    }

}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
