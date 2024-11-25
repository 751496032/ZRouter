/**
 * @author: HZWei
 * @date: 2024/11/12
 * @desc:
 */
import { AttributeUpdater, NavDestinationModifier } from '@kit.ArkUI'

abstract class BaseModifier <T> implements AttributeModifier<T> {
  abstract applyNormalAttribute(instance: T): void
}

@Observed
export class NavDesModifier extends AttributeUpdater<NavDestinationModifier, NavDestinationInterface> {


  initializeModifier(instance: NavDestinationModifier): void {
    console.log("AttributeUpdater initializeModifier")
    instance.hideTitleBar(false)
  }

  applyNormalAttribute(instance: NavDestinationModifier): void {
    console.log("AttributeUpdater applyNormalAttribute")
  }


}
