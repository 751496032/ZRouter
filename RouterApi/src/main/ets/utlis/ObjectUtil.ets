
/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
export class ObjectUtil {
  private constructor() {
  }
  static hashCode(obj: object): number {
    let hash = 0
    let i = 0
    let chr: number = 0;
    let str = JSON.stringify(obj)
    if (str.length === 0) {
      return hash;
    }
    for (i = 0; i < str.length; i++) {
      chr = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + chr;
      hash |= 0; // 将 hash 转换为 32 位整数
    }
    return hash
  }

  static isObject(obj: Object): boolean {
    return typeof obj === 'object'
  }

}