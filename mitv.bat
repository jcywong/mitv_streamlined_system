@echo off
echo 请先在电视上完成以下操作，并确保电脑和你的电视在同一个局域网中：
echo 1. 打开开发者模式，设置：关于-版本号(产品型号)狂按确认
echo 2. 打开 adb 调试，设置：账号与安全-ADB调试，改为允许，关闭智能更新
echo 3. 查看 IP，设置：无线/有线-选择你已经连接的网络-IPV4 地址就是你电视的 IP
echo ----------- 本脚本保留 VPN 组件，可以自己安装 Clash 等软件 -----------
echo 警告：继续执行将会删除小米电视上的部分功能与软件，数据无法恢复，请谨慎操作。

set /p ip="请输入电视 IP 地址，按回车键确认，此时电视会提示是否连接电脑，选择确认即可："

echo 正在连接，请稍后...
set matchStr=connected

:connect
for /f "tokens=*" %%i in ('adb connect %ip% ^| findstr /i /c:"%matchStr%"') do set result=%%i

echo %result% | find /i "%matchStr%" >nul && (
    echo 连接成功
) || (
    echo 连接失败，正在重试...
    ping -n 2 127.0.0.1 >nul
    goto connect
)

pause
echo 正在精简中，请耐心等待...

REM 以下是要卸载的应用程序列表
for %%a in (
    "com.xm.webcontent"                 REM 电视活动中心
    "com.sogou.speech.offlineservice"   REM 搜狗离线语音识别引擎
    "com.xiaomi.tweather"               REM 天气
    REM "com.xiaomi.mimusic2"               REM 本地音乐播放器
    REM "com.mitv.videoplayer"              REM 小米TV播放器
    "com.android.providers.downloads"   REM 下载管理程序
    "com.xiaomi.mitv.handbook"          REM 用户手册
    "com.android.certinstaller"         REM 证书安装
    "com.android.captiveportallogin"    REM wifi认证
    "com.mitv.appstore.component.land"  REM 应用商店内容land
    REM "com.xiaomi.mitv.tvmanager"         REM 电视管家
    "com.mitv.alarmcenter"              REM 定时提醒
    "com.xiaomi.mitv.calendar"          REM 日历
    "com.mitv.gallery"                  REM 相册
    "com.xiaomi.gamecenter.sdk.service.mibox"  REM 小米服务安全插件
    REM "com.mitv.care"                     REM adcare
    "com.xiaomi.mitv.karaoke.service"   REM 卡拉OK服务
    "com.xiaomi.miplay"                 REM MIOTHOST
    "com.xiaomi.mibox.gamecenter"       REM 游戏中心
    "com.xiaomi.mitv.upgrade"           REM 系统更新
    REM "com.xiaomi.account"                REM 小米帐号
    "com.droidlogic"                    REM droidlogic系统
    "com.xiaomi.mitv.payment"           REM 小米支付
    REM "com.xiaomi.mitv.pay"               REM 电视支付
    "com.xiaomi.tv.appupgrade"          REM 应用更新
    "com.xiaomi.mitv.tvpush.tvpushservice"  REM 电视推送
    REM "com.xiaomi.account.auth"           REM 小米帐号授权
    "com.xiaomi.statistic"               REM 统计
    "com.mipay.wallet.tv"               REM 小米钱包
    "com.xiaomi.smarthome.tv"           REM 米家
    "com.xiaomi.mitv.appstore"          REM 应用商店
    "com.miui.tv.analytics"             REM 分析
    "com.xiaomi.mitv.shop"              REM 小米商城
    REM "com.xiaomi.devicereport"           REM 设备报告
    "com.xiaomi.mibox.lockscreen"       REM 锁屏
    "com.mi.umi"                        REM 小米音响服务
    "com.mi.umifrontend"                REM 音响前端
    "com.android.proxyhandler"          REM 代理
    "com.xiaomi.mitv.advertise"         REM 广告应用
    "com.android.location.fused"        REM 一体化位置信息
    "com.xiaomi.screenrecorder"         REM 录屏
    "com.miui.systemAdSolution"         REM 去除开机广告
    REM "com.xiaomi.tv.gallery"             REM 时尚画报
    "com.duokan.videodaily"             REM 今日头屏
    REM 不建议删除应用
    REM "com.mitv.screensaver"              REM 智能屏保
    REM "com.android.packageinstaller"      REM 软件包安装程序
    REM "com.sohu.inputmethod.sogou.tv"     REM 搜狗输入法
    REM "com.mitv.mivideoplayer"            REM 小米电视播放器
    REM "com.pacprocessor"                  REM pacprocessor
    REM "com.xiaomi.mitv.mediaexplorer"     REM 高清播放器
    REM "com.android.bluetooth"             REM 蓝牙共享
    REM "com.xiaomi.mitv.tvplayer"          REM 模拟电视
    REM "com.xiaomi.upnp"                   REM upnp
    REM "com.xiaomi.mitv.smartshare"        REM 无线投屏
    REM "com.xiaomi.milink.udt"             REM 米联
    REM "com.mi.miplay.mitvupnpsink"        REM upnpapp
    REM "com.xiaomi.dlnatvservice"          REM DLNA连接
    REM "com.xiaomi.mitv.assistant.manual"   REM 投屏神器
    REM "com.duokan.airkan.tvbox"           REM milink服务
    REM "com.android.statementservice"      REM AppLinks功能
    "com.mitv.tvhome"                   REM 桌面
    REM "mitv.service"                      REM 无说明未测试   可能为开机广告
    REM "com.xiaomi.mitv.service"           REM 无说明未测试
    REM "com.mitv.codec.update"             REM 无说明未测试
    REM "com.mitv.shoplugin"             REM 无说明未测试
    REM "com.xiaomi.mitv.providers.settings"             REM 无说明未测试
    REM "com.xiaomi.mitv.legal.webview"             REM 无说明未测试
    REM "com.android.vpndialogs"             REM VPN
    REM "com.xiaomi.mitv.remotecontroller.service"             REM 无说明未测试
    REM "com.gitvdemo.video"             REM 无说明未测试
    REM "com.xiaomi.smarthome.tv.service"             REM 无说明未测试
    REM ""             REM 无说明未测试
    REM ""             REM 无说明未测试
    REM ""             REM 无说明未测试
) do (
    adb shell pm uninstall --user 0 %%a
)

echo 恭喜您，精简成功！快去重启电视，看看效果吧！

pause
