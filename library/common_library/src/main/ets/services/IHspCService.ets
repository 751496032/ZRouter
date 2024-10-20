import { IProvider } from "@hzw/zrouter";

export interface IHspCService extends IProvider {

  getDataFromHspC(): Promise<string>
}