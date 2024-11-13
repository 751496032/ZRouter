/**
 * @author: HZWei
 * @date: 2024/11/12
 * @desc:
 */
import { NavDestinationModifier } from '@kit.ArkUI'

abstract class BaseModifier <T> implements AttributeModifier<T> {
  abstract applyNormalAttribute(instance: T): void
}

class NavDesModifier extends BaseModifier<NavDestinationModifier> {
  applyNormalAttribute(instance: NavDestinationModifier): void {

  }
}
