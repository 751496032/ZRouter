import { IProvider } from "./IProvider";

/**
 * @author: HZWei
 * @date: 2024/10/17
 * @desc: 服务管理类
 */
export class ServiceMgr {

    private static _instance: ServiceMgr;

    private _services: Map<string, IProvider> = new Map();

    public static get instance(): ServiceMgr {
        if (!this._instance) {
            this._instance = new ServiceMgr();
        }
        return this._instance;
    }

    public addService(name: string, service: IProvider) {
        if (!this._services.has(name)) {
            this._services.set(name, service)
        }
    }

    public getService<T extends IProvider | null>(name: string): T | null {
        if (this._services.has(name)) {
            return this._services.get(name) as T
        }
        return null
    }

}