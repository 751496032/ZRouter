/**
 * @author: HZWei
 * @date: 2024/9/22
 * @desc:
 */

export enum ErrorCode {
  PARAMETER_ERROR = 401,
  INTERNAL_ERROR = 100001,
  NOT_REGISTERED = 100005,
  NOT_FOUND = 100006,
  INTERCEPTED = 301
}

export enum RedirectType {
  REPLACE = 'replace',
  PUSH = 'push',
  REMOVE = 'remove',
}

// export class InterceptorNames {
//   public static readonly PageNavigateInterceptor: string = 'PageNavigateInterceptor'
// }
