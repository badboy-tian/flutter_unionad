import { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import { AdSlotBuilder, CSJAdSdk, CSJSplashAd, CSJSplashAdCloseType, CSJSplashAdInteractionListener, CSJSplashAdLoadListener, CSJSplashAdLoadParam, ExpressAdInteractionListener, NativeExpressAdListener } from '@csj/openadsdk';
import { MethodChannel } from '@ohos/flutter_ohos';
import { window } from '@kit.ArkUI';
import SplashConstants from './SplashConstants';

@Component
export struct SplashNativeView {
  @Prop params: Params;

  @State splashAd?: CSJSplashAd = undefined

  timeout: number = 0;
  mCodeId: string = '';
  viewWidth: number = 0;
  viewHeight: number = 0;
  channel?: MethodChannel
  windowStage?: window.WindowStage

  @State isClose: boolean = false
  @State mWindow?: window.Window = undefined

  mAdCreator = CSJAdSdk.getAdCreator()

  build() {
    if (!this.isClose) {
      Row() {
        if (this.splashAd && this.mWindow) {
          NodeContainer(this.splashAd.getAdComponent(false, this.mWindow))
        }
      }.width(this.viewWidth).height(this.viewHeight)
    }
  }

  aboutToAppear(): void {
    this.mCodeId = SplashConstants.mCodeId;
    this.viewWidth = SplashConstants.viewWidth;
    this.viewHeight = SplashConstants.viewHeight;
    this.timeout = SplashConstants.timeout;
    this.channel = SplashConstants.channel;
    this.windowStage = SplashConstants.windowStage;

    let adSlot = new AdSlotBuilder()
      .setCodeId(this.mCodeId)
      .setAcceptSize(this.viewWidth, this.viewHeight)
      .build()

    let mSplashAdInteractionListener: CSJSplashAdInteractionListener = {
      onDidShow: () => {
        console.log("开屏回调 - onDidShow")
        this.channel?.invokeMethod("onShow", "开屏广告展示成功")
      },

      onDidClose: (closeType: CSJSplashAdCloseType) => {
        console.log(`开屏回调 - onDidClose 关闭原因：${closeType.value}`)
        if(closeType == CSJSplashAdCloseType.CLICK_SKIP){
          this.channel?.invokeMethod("onSkip", "开屏广告跳过")
        }else{
          this.channel?.invokeMethod("onFinish", "开屏广告倒计时结束")
        }
        this.splashAd = undefined
        // 方式二：需自行移除广告
        this.mWindow?.destroyWindow()
      },

      onDidClick: () => {
        console.log("开屏回调 - onDidClick")
        this.channel?.invokeMethod("onClick", "开屏广告点击")
      },

      onVideoDidPlayFinish: () => {

      },

      onVideoDidPlayFail: () => {
        console.log("开屏回调 - onVideoDidPlayFail")
        this.channel?.invokeMethod("onFail", "开屏广告播放失败")
        this.isClose = true;
        this.mWindow?.destroyWindow()
      }
    }

    let expressLoadAdListener: CSJSplashAdLoadListener = {
      onError: (code: number, message: string) => {
        //广告加载失败
        this.channel?.invokeMethod("onFail", `${code}, ${message}`);
        this.isClose = true;
      },
      onAdLoaded: (splashAd: CSJSplashAd) => {
        // 开屏加载成功
        this.splashAd = splashAd;
        this.splashAd.setInteractionListener(mSplashAdInteractionListener)
        if (this.mWindow) {
          return;
        }

        this.windowStage?.createSubWindow("splashAdWindow", (err, window) => {
          if (!window) {
            return;
          }
          this.mWindow = window
          let localStorage = new LocalStorage()
          localStorage.setOrCreate('splashAd', this.splashAd)
          localStorage.setOrCreate('splashAdWindow', window)
          localStorage.setOrCreate('splashCustomCloseBtn', false)
          window.loadContentByName("SplashAdShowPage", localStorage)
          window.showWindow()
        })
      },
      onRenderSuccess: (splashAd: CSJSplashAd): void => {
        this.channel?.invokeMethod("onSuccess", `${splashAd.getMediaExtraInfo()}`);
      },
      onRenderFail: (code: number, message: string): void => {
        this.channel?.invokeMethod("onFail", `${code}, ${message}`);
      }
    }

    let loadParam = new CSJSplashAdLoadParam(adSlot, expressLoadAdListener, this.getUIContext(), this.timeout)
    this.mAdCreator.loadSplashAd(loadParam)
  }
}

@Builder
export function SplashBuilder(params: Params) {
  SplashNativeView({
    params: params,
  })
}