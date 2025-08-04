/**
 * @author: HZWei
 * @date: 2024/12/22
 * @desc:
 */

export class Student {
  s_name: string = "李沁哲"
  s_age: number = 25

  constructor(name: string = "lili", age: number = 22) {
    this.s_name = name
    this.s_age = age
  }
}