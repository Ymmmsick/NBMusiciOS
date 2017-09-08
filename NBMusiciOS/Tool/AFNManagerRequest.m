//
//  AFNManagerRequest.m
//  womaijia_ios
//
//  Created by apple on 2017/7/28.
//  Copyright © 2017年 scsx. All rights reserved.
//

#import "AFNManagerRequest.h"

@implementation AFNManagerRequest

/**
 * 类方法
 */
+ (AFNManagerRequest *)sharedUtil {
    
    static dispatch_once_t onceToken;
    static AFNManagerRequest * setSharedInstance;
    
    dispatch_once(&onceToken, ^{
        setSharedInstance = [[AFNManagerRequest alloc] init];
        
    });
    return setSharedInstance;
}

/**
 * iOS自带网络请求框架
 */
+ (void)requestURL:(NSString *)urlstring
        httpMethod:(NSString *)method
            params:(NSMutableDictionary *)params
       complection:(void(^)(id result))block{
    
    //1.构造URL
    urlstring = [BASE_URL stringByAppendingString:urlstring];
    NSURL *url = [NSURL URLWithString:urlstring];
    
    //2.构造request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:method];
    
    //1>拼接请求参数:username=wxhl&password=123456&key=value&….
    NSMutableString *paramsString = [NSMutableString string];
    NSArray *allKeys = params.allKeys;
    for (int i=0; i<params.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = params[key];
        
        [paramsString appendFormat:@"%@=%@",key,value];
        
        if (i < params.count-1) {
            [paramsString appendString:@"&"];
        }
    }
    
    //2>添加请求参数:
    /*
     请求参数的格式1： username=wxhl&password=123456&key=value&….
     请求参数的格式2 JSON：{username:wxhl,password:12345,….}
     */
    //将字典 —-> JSON字符串
    //JSONKit
    // NSString *jsonString = [params JSONString];
    // NSLog(@”%@”,jsonString);
    
    /**
     * 判断请求方式：
     GET ： 参数拼接在URL后面
     POST ： 参数添加到请求体中
     */
    if ([method isEqualToString:@"GET"]) {
        
        NSString *separe = url.query?@"&":@"?";
        NSString *paramsURL = [NSString stringWithFormat:@"%@%@%@",urlstring,separe,paramsString];
        
        request.URL = [NSURL URLWithString:paramsURL];
    }
    else if([method isEqualToString:@"POST"]) {
        
        NSData *bodyData = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
    }
    
    //3.构造连接对象
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError != nil) {
            NSLog(@"网络请求失败 : %@",connectionError);
            return ;
        }
        
        //1.解析JSON
        // JSON字符串 —> 字典、数组
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //2.回到主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //回调block
            block(result);
            
        });
    }];
}

/**
 * AF网络请求
 */
+(void)requestAFURL:(NSString *)URLString
         httpMethod:(NSInteger)method
         parameters:(id)parameters
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure
{
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@%@",BASE_URL,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSLog(@"\n AF网络请求参数列表:%@\n\n 接口名: %@\n\n",parameters,URLString);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html 或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil, nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    // 5.选择请求方式 GET 或 POST
    switch (method) {
        case METHOD_GET:
        {
            [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [AFNManagerRequest dictionaryWithJsonString:responseStr];
                NSMutableDictionary *dic = @{}.mutableCopy;
                dic[@"data"] = [AFNManagerRequest dictionaryWithJsonString:dict[@"data"]];
                dic[@"sign"] = dict[@"sign"];
                dic[@"status"] = dict[@"status"];
                
                succeed(dic);
                
                NSLog(@"\n 请求成功:%@\n\n",dict[@"data"]);
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                failure(error);
                
                NSLog(@"\n 请求失败:%@\n\n",error);
            }];
        }
            break;
            
        case METHOD_POST:
        {
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                succeed([AFNManagerRequest dictionaryWithJsonString:responseStr]);
                
                NSLog(@"\n 请求成功:%@\n\n",[AFNManagerRequest dictionaryWithJsonString:responseStr]);
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                
                
                failure(error);
                
                NSLog(@"\n 请求失败:%@\n\n",error);
                
            }];
        }
            break;
            
        default:
            break;
    }
}

/**
 * 上传单张图片
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
          imageData:(NSData *)imageData
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure
{
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@%@",BASE_URL,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSLog(@"\n POST上传单张图片参数列表:%@\n\n%@\n",parameters,[AFNManagerRequest URLEncryOrDecryString:parameters IsHead:false]);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html 或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil ,nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    // 5. POST数据
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss"; // 设置时间格式
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        succeed([AFNManagerRequest dictionaryWithJsonString:responseStr]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}

/**
 * 上传多张图片
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
     imageDataArray:(NSArray *)imageDataArray
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure
{
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@%@",BASE_URL,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSLog(@"\n POST上传多张图片参数列表:%@\n\n%@\n",parameters,[AFNManagerRequest URLEncryOrDecryString:parameters IsHead:false]);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html 或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil, nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    // 5. POST数据
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i<imageDataArray.count; i++){
            
            NSData *imageData = imageDataArray[i];
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSString *name = [NSString stringWithFormat:@"image_%d.png",i ];
            
            //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        succeed([AFNManagerRequest dictionaryWithJsonString:responseStr]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}

/**
 * 上传文件
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
           fileData:(NSData *)fileData
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure
{
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@%@",BASE_URL,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
//    NSLog(@"\n POST上传文件参数列表:%@\n\n%@\n",parameters,[Utilit URLEncryOrDecryString:parameters IsHead:false]);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html 或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil ,nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    // 5. POST数据
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //将得到的二进制数据拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        [formData appendPartWithFileData :fileData name:@"file" fileName:@"audio.MP3" mimeType:@"audio/MP3"];
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        succeed([AFNManagerRequest dictionaryWithJsonString:responseStr]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}

/*json
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}

/*json
 * @brief 把字典转换成字符串
 * @param jsonString JSON格式的字符串
 * @return 返回字符串
 */
+(NSString*)URLEncryOrDecryString:(NSDictionary *)paramDict IsHead:(BOOL)_type
{
    
    NSArray *keyAry = [paramDict allKeys];
    NSString *encryString = @"";
    for (NSString *key in keyAry)
    {
        NSString *keyValue = [paramDict valueForKey:key];
        encryString = [encryString stringByAppendingFormat:@"&"];
        encryString = [encryString stringByAppendingFormat:@"%@",key];
        encryString = [encryString stringByAppendingFormat:@"="];
        encryString = [encryString stringByAppendingFormat:@"%@",keyValue];
    }
    
    return encryString;
}

@end
