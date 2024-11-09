import { IProvider } from "@hzw/zrouter";

export interface IHarAService extends IProvider {
  showToast(msg: string): void

  getUserInfo(): Promise<string>
}