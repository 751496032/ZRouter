/**
 * @author: HZWei
 * @date: 2024/10/23
 * @desc: 生命周期抽象接口
 */

export interface ILifeCycle {
  onMount(): void
  onUnMount(): void
}