
/**
 * @author: HZWei
 * @date: 2024/7/18
 * @desc:
 */
export class ObjectUtil {
  private constructor() {
  }

  /**
   *  判断是否是对象
   * @param obj
   * @returns
   */
  static isObject(obj: Object | undefined | null): boolean {
    return typeof obj === 'object' && obj !== null
  }

  /**
   * 判断是否为空
   * @param obj
   * @returns
   */
  static isEmpty(obj: Object | undefined | null): boolean {
    let isEmpty = obj === undefined || obj === null
    if (typeof obj === 'string') {
      isEmpty = isEmpty || obj.trim().length === 0
    } else if (ObjectUtil.isObject(obj)) {
      isEmpty = isEmpty || Object.keys(obj).length === 0
    }
    return isEmpty
  }

  /**
   * 判断是否不为空
   * @param obj
   * @returns
   */
  static isNotEmpty(obj: Object | undefined | null): boolean {
    return !ObjectUtil.isEmpty(obj)
  }

  /**
   * 判断是否存在属性
   * @param obj
   * @param propertyName
   * @returns
   */
  static hasProperty(obj: Object | undefined | null, propertyName: string): boolean {
    if (!ObjectUtil.isObject(obj)) {
      return false
    }
    for (const key of Object.keys(obj!)) {
      if (key === propertyName) {
        return true
      }
    }
    return false
  }

  /**
   * 对象深拷贝
   * @param obj
   * @returns
   */
  static deepCopy(obj: Object | undefined | null): ESObject {
    if (typeof obj !== 'object' || obj === null) {
      return obj;
    }
    let copy: ESObject;
    if (Array.isArray(obj)) {
      copy = [];
      for (let i = 0; i < obj.length; i++) {
        copy[i] = ObjectUtil.deepCopy(obj[i]);
      }
    } else {
      copy = {};
      for (let key of Object.keys(obj)) {
        if (ObjectUtil.hasProperty(obj, key)) {
          let keyStr = key + '';
          let suffix = '__ob_'
          if (keyStr.startsWith(suffix)) {
            const newKey = keyStr.substring(suffix.length)
            copy[newKey] = ObjectUtil.deepCopy(obj[key]);
          }else {
            copy[key] = ObjectUtil.deepCopy(obj[key]);
          }
        }
      }
    }
    return copy;
  }

  /**
   * 对象浅拷贝
   * @param obj
   * @returns
   */
  static shallowCopy(obj: object): object {
    let newObj: Record<string, Object> = {};
    for (let key of Object.keys(obj)) {
      newObj[key] = obj[key];
    }
    return newObj;
  }

  static merge(objs: object[]): object {
    let newObj: Record<string, Object> = {};
    objs.forEach((obj) => {
      for (let key of Object.keys(obj)) {
        newObj[key] = obj[key];
      }
    })
    return newObj;
  }

}