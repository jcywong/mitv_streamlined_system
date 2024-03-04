#!/bin/bash

echo "请先在电视上完成以下操作，并确保电脑和你的电视在同一个局域网中："
echo "1. 打开开发者模式，设置：关于-版本号(产品型号)狂按确认"
echo "2. 打开 adb 调试，设置：账号与安全-ADB调试，改为允许，关闭智能更新"
echo "3. 查看 IP，设置：无线/有线-选择你已经连接的网络-IPV4 地址就是你电视的 IP"
echo "----------- 本脚本保留 VPN 组件，可以自己安装 Clash 等软件 -----------"
echo "警告：继续执行将会删除小米电视上的部分功能与软件，数据无法恢复，请谨慎操作。"

echo -n "请输入电视 IP 地址，按回车键确认，此时电视会提示是否连接电脑，选择确认即可："
read ip

echo "正在连接，请稍后..."
matchStr="connected"

while true; do
    result=$(adb connect "$ip" | grep "$matchStr")
    if [ $? -eq 0 ]; then
        echo "连接成功"
        break
    else
        echo "连接失败，正在重试..."
        sleep 1
    fi
done

read -p "按 Enter 键开始："
echo "正在精简中，请耐心等待..."

# 以下是要卸载的应用程序列表
apps=(
    "com.xm.webcontent"                 # 电视活动中心
    "com.sogou.speech.offlineservice"   # 搜狗离线语音识别引擎
    "com.xiaomi.tweather"               # 天气
    # "com.xiaomi.mimusic2"               # 本地音乐播放器
    # "com.mitv.videoplayer"              # 小米TV播放器
    "com.android.providers.downloads"   # 下载管理程序
    "com.xiaomi.mitv.handbook"          # 用户手册
    "com.android.certinstaller"         # 证书安装
    "com.android.captiveportallogin"    # wifi认证
    "com.mitv.appstore.component.land"  # 应用商店内容land
    # "com.xiaomi.mitv.tvmanager"         # 电视管家
    "com.mitv.alarmcenter"              # 定时提醒
    "com.xiaomi.mitv.calendar"          # 日历
    "com.mitv.gallery"                  # 相册
    "com.xiaomi.gamecenter.sdk.service.mibox"  # 小米服务安全插件
    # "com.mitv.care"                     # adcare
    "com.xiaomi.mitv.karaoke.service"   # 卡拉OK服务
    "com.xiaomi.miplay"                 # MIOTHOST
    "com.xiaomi.mibox.gamecenter"       # 游戏中心
    "com.xiaomi.mitv.upgrade"           # 系统更新
    # "com.xiaomi.account"                # 小米帐号
    "com.droidlogic"                    # droidlogic系统
    "com.xiaomi.mitv.payment"           # 小米支付
    # "com.xiaomi.mitv.pay"               # 电视支付
    "com.xiaomi.tv.appupgrade"          # 应用更新
    "com.xiaomi.mitv.tvpush.tvpushservice"  # 电视推送
    # "com.xiaomi.account.auth"           # 小米帐号授权
    "com.xiaomi.statistic"               # 统计
    "com.mipay.wallet.tv"               # 小米钱包
    "com.xiaomi.smarthome.tv"           # 米家
    "com.xiaomi.mitv.appstore"          # 应用商店
    "com.miui.tv.analytics"             # 分析
    "com.xiaomi.mitv.shop"              # 小米商城
    # "com.xiaomi.devicereport"           # 设备报告
    "com.xiaomi.mibox.lockscreen"       # 锁屏
    "com.mi.umi"                        # 小米音响服务
    "com.mi.umifrontend"                # 音响前端
    "com.android.proxyhandler"          # 代理
    "com.xiaomi.mitv.advertise"         # 广告应用
    "com.android.location.fused"        # 一体化位置信息
    "com.xiaomi.screenrecorder"         # 录屏
    "com.miui.systemAdSolution"         # 去除开机广告
    # "com.xiaomi.tv.gallery"             # 时尚画报
    "com.duokan.videodaily"             # 今日头屏
    # 不建议删除应用
    # "com.mitv.screensaver"              # 智能屏保
    # "com.android.packageinstaller"      # 软件包安装程序
    # "com.sohu.inputmethod.sogou.tv"     # 搜狗输入法
    # "com.mitv.mivideoplayer"            # 小米电视播放器
    # "com.pacprocessor"                  # pacprocessor
    # "com.xiaomi.mitv.mediaexplorer"     # 高清播放器
    # "com.android.bluetooth"             # 蓝牙共享
    # "com.xiaomi.mitv.tvplayer"          # 模拟电视
    # "com.xiaomi.upnp"                   # upnp
    # "com.xiaomi.mitv.smartshare"        # 无线投屏
    # "com.xiaomi.milink.udt"             # 米联
    # "com.mi.miplay.mitvupnpsink"        # upnpapp
    # "com.xiaomi.dlnatvservice"          # DLNA连接
    # "com.xiaomi.mitv.assistant.manual"   # 投屏神器
    # "com.duokan.airkan.tvbox"           # milink服务
    # "com.android.statementservice"      # AppLinks功能
    "com.mitv.tvhome"                   # 桌面
    # "mitv.service"                      # 无说明未测试   可能为开机广告
    # "com.xiaomi.mitv.service"           # 无说明未测试
    # "com.mitv.codec.update"             # 无说明未测试
    # "com.mitv.shoplugin"             # 无说明未测试
    # "com.xiaomi.mitv.providers.settings"             # 无说明未测试
    # "com.xiaomi.mitv.legal.webview"             # 无说明未测试
    # "com.android.vpndialogs"             # VPN
    # "com.xiaomi.mitv.remotecontroller.service"             # 无说明未测试
    # "com.gitvdemo.video"             # 无说明未测试
    # "com.xiaomi.smarthome.tv.service"             # 无说明未测试
    # ""             # 无说明未测试
    # ""             # 无说明未测试
    # ""             # 无说明未测试


)


for app in "${apps[@]}"; do
    adb shell pm uninstall --user 0 "$app"
done

echo "恭喜您，精简成功！快去重启电视，看看效果吧！"

read -p "按 Enter 键退出"
