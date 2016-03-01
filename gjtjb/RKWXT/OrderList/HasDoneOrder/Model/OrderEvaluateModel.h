//
//  OrderEvaluateModel.h
//  RKWXT
//
//  Created by SHB on 16/3/1.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    OrderEvaluate_Type_Add = 1,  //添加评价
    OrderEvaluate_Type_LMSearch, //商家联盟查询
    OrderEvaluate_Type_AppSearch, // app查询
}OrderEvaluate_Type;

@protocol OrderEvaluateModelDelegate;

@interface OrderEvaluateModel : NSObject
@property (nonatomic,assign) id<OrderEvaluateModelDelegate>delegate;

-(void)userEvaluateOrder:(NSInteger)orderID andInfo:(NSString*)content type:(OrderEvaluate_Type)type;
@end

@protocol OrderEvaluateModelDelegate <NSObject>
-(void)orderEvaluateSucceed;
-(void)orderEvaluateFailed:(NSString*)errorMsg;

@end
