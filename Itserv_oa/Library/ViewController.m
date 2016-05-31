//
//  ViewController.m
//  testlib
//
//  Created by APPLE on 2/2/15.
//  Copyright (c) 2015年 hsl. All rights reserved.
//

#import "ViewController.h"
#import "MyGLViewController.h"
#import "HSLSDK/inc/IPCClientNetLib.h"
#import "HSLSDK/inc/StreamPlayLib.h"

void STDCALL CallBack_Event(unsigned int nType, void *pUser)
{
    id pThiz = (id)pUser;
    [pThiz ProcessEvent:nType];
}

/*
 * P2P模式回调
 */
void STDCALL CallBack_P2PMode(unsigned int nType, void *pContext)
{
    id pThiz = (id)pContext;
    [pThiz ProcessP2pMode:nType];
}

/*
 * 警报消息回调
 */
void STDCALL CallBack_AlarmMessage(unsigned int nType, void *pContext)
{
    id pThiz = (id)pContext;
    [pThiz ProcessAlarmMessage:nType];
}

/*
 * 获取参数结果回调函数
 */
void STDCALL CallBack_GetParam(unsigned int nType, const char *pszMessage, unsigned int nLen, void *pUser)
{
    id pThiz = (id)pUser;
    [pThiz ProcessGetParam:nType Data:pszMessage DataLen:nLen];
}

/*
 * 设置参数结果回调函数
 */
void STDCALL CallBack_SetParam(unsigned int nType, unsigned int nResult, void *pUser)
{
    id pThiz = (id)pUser;
    [pThiz ProcessSetParam:nType Result:nResult];
}

// 解码后的YUV420数据
void STDCALL CallBack_YUV420Data(unsigned char *pYUVData, int width, int height, void *pUserData)
{
    id pThiz = (id)pUserData;
    [pThiz ProcessYUV420Data:pYUVData Width:width Height:height];
}



@interface ViewController ()
{
    MyGLViewController *m_glView;
    int userid;
    int playid;
}
@end


@implementation ViewController

/*
 * 音视频数据回调
 */
void STDCALL CallBack_AVData(const char *pBuffer, unsigned int nBufSize, void *pUser)
{
    //    NSLog(@"data size:%d", nBufSize);
    ViewController* pThiz = (ViewController *)pUser;
    // 写入解码库解码
    x_player_inputNetFrame(pThiz->playid, pBuffer, nBufSize);
}

// 压缩后的音频数据
void STDCALL CallBack_EncodeAudioData(const char *pData, int nSize, void *pUserData)
{
    id pThiz = (id)pUserData;
    [pThiz ProcessEncodeAudioData:pData Len:nSize];
}

- (void)ProcessEncodeAudioData:(const char *)pData Len:(int)len
{
    NSLog(@"encode audio data len=%d", len);
    device_net_work_sendTalkData(userid, pData, len);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    m_glView = [[MyGLViewController alloc] init];
    m_glView.view.frame = CGRectMake(0, 20, self.view.frame.size.width, 300);
    [self.view addSubview:m_glView.view];
    
    // connect
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"连接设备" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    btn.frame = CGRectMake(10, 330, 80, 40);
    [btn addTarget:self action:@selector(btnConnect) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // free
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"释放" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    btn.frame = CGRectMake(100, 330, 80, 40);
    [btn addTarget:self action:@selector(btnStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // open video
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"查看视频" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    btn.frame = CGRectMake(10, 380, 80, 50);
    [btn addTarget:self action:@selector(btnOpenVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"关闭视频" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    btn.frame = CGRectMake(100, 380, 80, 50);
    [btn addTarget:self action:@selector(btnCloseVideo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // open audio
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"监听" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    btn.frame = CGRectMake(10, 440, 80, 40);
    [btn addTarget:self action:@selector(btnOpenSound) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // close audio
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"关闭监听" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    btn.frame = CGRectMake(100, 440, 80, 40);
    [btn addTarget:self action:@selector(btnCloseSound) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // open talk
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"对讲" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    btn.frame = CGRectMake(10, 490, 80, 40);
    [btn addTarget:self action:@selector(btnOpenTalk) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // close talk
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"关闭对讲" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor grayColor];
    btn.frame = CGRectMake(100, 490, 80, 40);
    [btn addTarget:self action:@selector(btnCloseTalk) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    userid = -1;
    playid = -1;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnConnect
{
    if (userid >= 0) return;
    struct __login_user_info_t info = {0};
    strcpy(info.szDid, "HSL-220561-GWRPP");
    strcpy(info.szUser, "admin");
    strcpy(info.szPwd, "");
    int nettype = 1;  // 0/1 tcp/p2p
    userid = device_net_work_createInstance(info, nettype);
    if (userid >= 0)
    {
        device_net_work_set_event_callback(userid, CallBack_Event, self);
        device_net_work_set_p2pmode_callback(userid, CallBack_P2PMode, self);
        device_net_work_set_alarmMessage_callback(userid, CallBack_AlarmMessage, self);
        device_net_work_param_callback(userid, CallBack_GetParam, CallBack_SetParam, self);
        device_net_work_start(userid);
    }
}

- (void)btnStop
{
    if (userid >= 0) {
        device_net_work_destroyInstance(userid);
        userid = -1;
    }
}

- (void)btnOpenVideo
{
    if (userid >= 0) {
        // 建立解码实例
        playid = x_player_createPlayInstance(0, 0);
        if (playid < 0) {
            NSLog(@"x_player_createPlayInstance failed.");
            return;
        }
        // 启动视频解码
        int ret = x_player_startPlay(playid);
        if (ret != AP_ERROR_SUCC) {
            // 释放解码实例
            x_player_destroyPlayInstance(playid);
            playid = -1;
            return;
        }
        // 注册函数接收解码后YUV数据
        x_player_RegisterVideoCallBack(playid, CallBack_YUV420Data, self);
        
        // substream 0/1/2 主/子/次码流
        device_net_work_startStreamV2(userid, 0, 1, CallBack_AVData, self);
    }
}

- (void)btnCloseVideo
{
    if (userid >= 0) {
        // 结束实时视频请求
        device_net_work_stopStream(userid);
        // 释放解码实例
        x_player_destroyPlayInstance(playid);
        playid = -1;

    }
}

/*!!!!!!!!!!!!!!请注意监听和对讲互斥!!!!!!!!!!!!!!!!!!!!*/
- (void)btnOpenSound
{
    if (playid < 0 || userid < 0) {
        return;
    }
    
    // 打开音频解码
    if (x_player_openSound(playid) != AP_ERROR_SUCC) {
        return;
    }
    x_player_RegisterAudioCallBack(playid, NULL, self);
    // 请求音频数据
    device_net_work_startAudio(userid, 0, CallBack_AVData, self);
}
     
- (void)btnCloseSound
{
    // 结束音频数据
    device_net_work_stopAudio(userid);
    // 关闭音频解码
    x_player_closeSound(playid);
}

- (void)btnOpenTalk
{
    if (playid < 0 || userid < 0) {
        return;
    }
    x_player_StartTalk(playid, CallBack_EncodeAudioData, self);
}

- (void)btnCloseTalk
{
    if (playid < 0 || userid < 0) {
        return;
    }
    x_player_StopTalk(playid);
}

/*
 * 事件处理，若显示到控件必须转到主线程处理
 */
- (void)ProcessEvent:(int)nType
{
    NSLog(@"event type=%d\n", nType);
}

- (void)ProcessP2pMode:(int)mode
{
    NSLog(@"P2P Mode = %d",mode);
}

- (void)ProcessAlarmMessage:(int)nType
{
    NSLog(@"alarm type = %d", nType);
}

- (void)ProcessGetParam:(int)nType Data:(const char*)szMsg DataLen:(int)len
{
    NSLog(@"GetParam type:%x len:%d", nType, len);
    switch (nType) {
        case GET_PARAM_NETWORK:     // 网络参数
            break;
        default:
            break;
    }
}

- (void)ProcessSetParam:(int)nType Result:(int)result
{

}

- (void)ProcessYUV420Data:(Byte *)yuv420 Width:(int)width Height:(int)height
{
    [m_glView WriteYUVFrame:yuv420 Len:width * height * 3 / 2 width:width height:height];
}

@end
