import { AttributeUpdater, NavDestinationModifier } from "@ohos.arkui.modifier";

/**
 * @author: HZWei
 * @date: 2024/12/7
 * @desc:  NavDest模版的自定义属性基础类
 * 通过此类可以实现NavDestination自定义属性的初始化
 * 详情可见官网文档：
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-universal-attributes-attribute-modifier-V5#applyselectedattribute
 */
export abstract  class ZAttributeModifier extends AttributeUpdater<NavDestinationModifier, NavDestinationInterface>{
  abstract initModifier(instance: NavDestinationModifier)
  initializeModifier(instance: NavDestinationModifier): void {
    this.initModifier(instance)
    // 不支持title属性，调用此方法会报错
  }
}