/**
 * @author: HZWei
 * @date: 2025/8/14
 * @desc:
 * runCatching 函数
 * 安全并捕获任何异常
 * @param block
 * @returns 成功结果或错误的 Result 对象
 */
export function runCatching<T>(block: () => T): Result<T> {
  try {
    const result = block();
    return new Result(success(result));
  } catch (error) {
    return new Result(failure(error));
  }
}

/**
 * Result 类，表示操作的结果，可以是成功或失败
 */
export class Result<T> {
  private readonly _value: Success<T> | Failure;

  constructor(value: Success<T> | Failure) {
    this._value = value;
  }


  get isSuccess(): boolean {
    return this._value instanceof Success;
  }


  get isFailure(): boolean {
    return this._value instanceof Failure;
  }

  /**
   * 获取成功的结果，如果失败则抛出异常
   */
  getOrNull(): T | null {
    if (this._value instanceof Success) {
      return this._value.value;
    }
    return null;
  }

  /**
   * 获取成功的结果，如果失败则抛出异常
   */
  getOrThrow(): T {
    if (this._value instanceof Success) {
      return this._value.value;
    }
    throw this._value.error;
  }

  /**
   * 获取错误，如果是成功的则返回 null
   */
  exceptionOrNull(): any | null {
    if (this._value instanceof Failure) {
      return this._value.error;
    }
    return null;
  }

  /**
   * 如果成功则执行 onSuccess 回调，如果失败则执行 onFailure 回调
   */
  fold<R>(onSuccess: (value: T) => R, onFailure: (error: any) => R): R {
    if (this._value instanceof Success) {
      return onSuccess(this._value.value);
    } else {
      return onFailure(this._value.error);
    }
  }

  /**
   * 如果成功则执行给定的块
   */
  onSuccess(block: (value: T) => void): Result<T> {
    if (this._value instanceof Success) {
      block(this._value.value);
    }
    return this;
  }

  /**
   * 如果失败则执行给定的块
   */
  onFailure(block: (error: any) => void): Result<T> {
    if (this._value instanceof Failure) {
      block(this._value.error);
    }
    return this;
  }

  /**
   * 转换成功值，如果当前是失败则保持不变
   */
  map<R>(transform: (value: T) => R): Result<R> {
    if (this._value instanceof Success) {
      try {
        return new Result(success(transform(this._value.value)));
      } catch (error) {
        return new Result(failure(error));
      }
    } else {
      return new Result(failure(this._value.error));
    }
  }

  /**
   * 链式操作，如果当前是成功则执行下一个 runCatching 操作
   */
  flatMap<R>(transform: (value: T) => Result<R>): Result<R> {
    if (this._value instanceof Success) {
      try {
        return transform(this._value.value);
      } catch (error) {
        return new Result(failure(error));
      }
    } else {
      return new Result(failure(this._value.error));
    }
  }
}


class Success<T> {
  constructor(public readonly value: T) {}
}


class Failure {
  constructor(public readonly error: any) {}
}


function success<T>(value: T): Success<T> {
  return new Success(value);
}


function failure(error: any): Failure {
  return new Failure(error);
}
