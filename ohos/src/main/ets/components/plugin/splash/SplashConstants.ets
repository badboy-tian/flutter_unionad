import { MethodChannel } from "@ohos/flutter_ohos";
import { window } from "@kit.ArkUI";

export default class SplashConstants {
  static mCodeId = "";
  static viewWidth = 0.0
  static viewHeight = 0.0
  static timeout = 3000
  static channel: MethodChannel
  static windowStage: window.WindowStage
}