//
//  UserAliAccountStateCell.m
//  RKWXT
//
//  Created by SHB on 16/4/7.
//  Copyright © 2016年 roderick. All rights reserved.
//

#import "UserAliAccountStateCell.h"
#import "UserAliEntity.h"

@interface UserAliAccountStateCell(){
    WXUIButton *submitBtn;
    WXUIImageView *imgView;
    WXUILabel *nameLabel;
    
    WXUILabel *accountName;
    WXUILabel *accountType;
    WXUILabel *accountInfo;
}

@end

@implementation UserAliAccountStateCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        CGFloat footHeight = UserAliAccountStateCellHeight;
        UIView *footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, IPHONE_SCREEN_WIDTH, footHeight);
        [footerView setBackgroundColor:WXColorWithInteger(0xf6f6f6)];
        [self.contentView addSubview:footerView];
        
        CGFloat btnWidth = IPHONE_SCREEN_WIDTH-2*20;
        CGFloat btnHeight = 40;
        submitBtn = [WXUIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake((IPHONE_SCREEN_WIDTH-btnWidth)/2, footHeight-btnHeight-10, btnWidth, btnHeight);
        [submitBtn setBackgroundColor:WXColorWithInteger(0xf74f35)];
        [submitBtn setTitle:@"绑定提现账户" forState:UIControlStateNormal];
        [submitBtn setTitleColor:WXColorWithInteger(0xffffff) forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:submitBtn];
        
        CGFloat imgWidth = 60;
        CGFloat imgHeight = imgWidth;
        CGFloat commonLabelWidth = 140;
        CGFloat commonLabelHeight = 22;
        CGFloat yOffset = 35;
        imgView = [[WXUIImageView alloc] init];
        imgView.frame = CGRectMake((IPHONE_SCREEN_WIDTH-imgWidth)/2, yOffset, imgWidth, imgHeight);
        [footerView addSubview:imgView];
        
        yOffset += imgHeight+18;
        nameLabel = [[WXUILabel alloc] init];
        nameLabel.frame = CGRectMake((IPHONE_SCREEN_WIDTH-commonLabelWidth)/2, yOffset, commonLabelWidth, commonLabelHeight);
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setTextColor:WXColorWithInteger(0x000000)];
        [nameLabel setFont:WXFont(17.0)];
        [footerView addSubview:nameLabel];
        
        CGFloat yGap = 25;
        CGFloat xOffset = 8;
        CGFloat labelWidth = IPHONE_SCREEN_WIDTH-2*xOffset;
        CGFloat labelHeight = commonLabelHeight;
        accountName = [[WXUILabel alloc] init];
        accountName.frame = CGRectMake(xOffset, yGap, labelWidth, labelHeight);
        [accountName setBackgroundColor:[UIColor clearColor]];
        [accountName setTextAlignment:NSTextAlignmentLeft];
        [accountName setTextColor:WXColorWithInteger(0x5c615d)];
        [accountName setFont:WXFont(14.0)];
        [footerView addSubview:accountName];
        
        yGap += labelHeight+3;
        accountType = [[WXUILabel alloc] init];
        accountType.frame = CGRectMake(xOffset, yGap, labelWidth, labelHeight);
        [accountType setBackgroundColor:[UIColor clearColor]];
        [accountType setText:@"账户类型: 支付宝"];
        [accountType setTextAlignment:NSTextAlignmentLeft];
        [accountType setTextColor:WXColorWithInteger(0x5c615d)];
        [accountType setFont:WXFont(14.0)];
        [footerView addSubview:accountType];
        
        yGap += labelHeight+3;
        accountInfo = [[WXUILabel alloc] init];
        accountInfo.frame = CGRectMake(xOffset, yGap, labelWidth, labelHeight);
        [accountInfo setBackgroundColor:[UIColor clearColor]];
        [accountInfo setTextAlignment:NSTextAlignmentLeft];
        [accountInfo setTextColor:WXColorWithInteger(0x5c615d)];
        [accountInfo setFont:WXFont(14.0)];
        [footerView addSubview:accountInfo];
        
        [imgView setHidden:YES];
        [nameLabel setHidden:YES];
        [accountName setHidden:YES];
        [accountInfo setHidden:YES];
        [accountType setHidden:YES];
    }
    return self;
}

-(void)load{
    UserAliEntity *entity = self.cellInfo;
    [submitBtn setEnabled:YES];
    [imgView setHidden:YES];
    [nameLabel setHidden:YES];
    [accountName setHidden:YES];
    [accountInfo setHidden:YES];
    [accountType setHidden:YES];
    
    //提交申请的情况
    if(entity && entity.userali_type == UserAliCount_Type_Submit){
        [imgView setHidden:NO];
        [nameLabel setHidden:NO];
        
        [imgView setImage:[UIImage imageNamed:@"UserWithdrawals.png"]];
        [nameLabel setText:@"正在审核中..."];
        
        [submitBtn setEnabled:NO];
        [submitBtn setBackgroundColor:[UIColor grayColor]];
    }
    //审核未通过的情况
    if(entity.userali_type == UserAliCount_Type_Failed){
        [imgView setHidden:NO];
        [nameLabel setHidden:NO];
        
        [imgView setImage:[UIImage imageNamed:@"UserAliAccountFailed.png"]];
        [nameLabel setText:@"审核失败..."];
        
        [submitBtn setTitle:@"重新绑定账户" forState:UIControlStateNormal];
    }
    
    //有账号的情况
    if(entity && entity.userali_type == UserAliCount_Type_Succeed){
        [accountName setHidden:NO];
        [accountType setHidden:NO];
        [accountInfo setHidden:NO];
        
        [accountName setText:[NSString stringWithFormat:@"账户名: %@",[self userNameShowType:entity.aliName]]];
        [accountInfo setText:[NSString stringWithFormat:@"收款账户: %@",[self userAliAccountShowWith:entity.aliCount]]];
        
        [submitBtn setTitle:@"重新绑定账户" forState:UIControlStateNormal];
    }
}

//账户名显示部分名字
-(NSString*)userNameShowType:(NSString*)name{
    NSInteger length = name.length;
    NSString *userName = [name substringToIndex:1];
    for (int i = 0; i < length-1; i++){
        userName = [userName stringByAppendingString:@"*"];
    }
    return userName;
}

//收款账号显示部分
-(NSString *)userAliAccountShowWith:(NSString*)oldString{
    BOOL isPhone = [UtilTool determineNumberTrue:oldString];
    NSString *newStr = nil;
    if(isPhone){
        newStr = [oldString substringWithRange:NSMakeRange(0, 3)];
        newStr = [newStr stringByAppendingString:@"****"];
        newStr = [newStr stringByAppendingString:[oldString substringFromIndex:7]];
    }else{
        newStr = [self userEmailAddressShow:oldString];
    }
    return newStr;
}

-(NSString*)userEmailAddressShow:(NSString*)oldEmail{
    NSInteger position = 0;  //记录'@'符号的位置
    for(NSInteger i = 0; i < oldEmail.length; i++){
        if([[oldEmail substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"@"]){
            position = i;
        }
    }
    if(position == 1){  //q@....
        return [NSString stringWithFormat:@"*%@",[oldEmail substringFromIndex:position]];
    }
    if(position == 2){  //qq@...
        return [NSString stringWithFormat:@"%@*%@",[oldEmail substringToIndex:0],[oldEmail substringFromIndex:position]];
    }
    if(position == 3){
        return [NSString stringWithFormat:@"%@**%@",[oldEmail substringToIndex:0],[oldEmail substringFromIndex:position]];
    }
    if(position >= 4){
        return [NSString stringWithFormat:@"%@**%@",[oldEmail substringToIndex:1],[oldEmail substringFromIndex:position]];
    }
    return nil;
}

-(void)submitBtnClicked{
    UserAliEntity *entity = self.cellInfo;
    if(_delegate && [_delegate respondsToSelector:@selector(userSubmitAliAccountBtnClicked:)]){
        [_delegate userSubmitAliAccountBtnClicked:entity];
    }
}

@end
