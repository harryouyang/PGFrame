# PGFrame
简单App框架

## 文件结构
>> pangu
>>> category
>>> ui
>>>> tableCell

## 功能使用说明
### 消息弹出提示

### 等待框
  可以通过自定义样式，目前只有两种。可以继承PGWaitingView扩展个性化的等待视图。

```object-c
- (void)showWaitingView:(NSString *)text viewStyle:(PGWaitingViewStyle)style {
    if(self.waitingView == nil) {
        if(style == EWaitingViewStyle_Rotation) {
            self.waitingView = [[PGRotaionWaitingView alloc] initWithFrame:CGRectMake(0, 0, PGHeightWith1080(280), PGHeightWith1080(280))];
        } else {
            self.waitingView = [[PGCustomWaitingView alloc] initBgColor:UIColorFromRGBA(0x858585, 0.8) apla:1.0 font:nil textColor:nil activeColor:[UIColor whiteColor]];
            self.waitingView.layer.cornerRadius = 5.0;
        }
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:self.waitingView];
    
    [self.view addSubview:bgView];
    
    self.bShowProgressView = YES;
    
    [self.waitingView showText:text];
    self.waitingView.center = self.waitingView.superview.center;
}
```
  调用示例
```object-c  
[self showWaitingView:nil viewStyle:EWaitingViewStyle_Rotation];
```
### 网络请求
    基本上目前市面上所有app都需要有的功能模块，通过网络接口从服务器获取业务数据。
    网络请求模块尽可能与UI界面逻辑分开，在Controller请求数据时尽可能简单。
  * PGHttpClient 封装具体的网络http请求逻辑
  * PGAPI 封装业务相关的接口地址与解析数据入口
  * PGResultObject 接口请求解析完成后返回给View的数据
  * PGEncrypt 封装一些加密操作，如接口签名等
  * PGDataParseManager 接口请求的回来的数据进行解析
  * PGRequestManager 接口请求管理，为所有业务数据请求提供统一的入口

```object-c
  [self showWaitingView:nil viewStyle:EWaitingViewStyle_Rotation];
    
    [PGRequestManager startPostClient:API_TYPE_LOGIN
                                param:@{@"userName":@"name",@"password":@"123456"}
                               target:self
                                  tag:@"login"];
```
  回调处理
```object-c
- (void)dataRequestSuccess:(PGResultObject *)resultObj
{
    [self hideWaitingView];
}

- (void)dataRequestFailed:(PGResultObject *)resultObj
{
    [self hideWaitingView];
    [self showMsg:resultObj.szErrorDes];
}
```
