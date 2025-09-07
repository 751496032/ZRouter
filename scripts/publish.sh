#!/bin/bash
echo "start publish..."

#!/bin/bash

# 加载配置
if [ -f "publish.config" ]; then
    source publish.config
else
    echo "错误: 找不到配置文件 publish.config"
    exit 1
fi

echo "开始发布流程..."

# 提交代码  可选
if [ "$ENABLE_GIT_OPERATIONS" = true ]; then
  echo "提交代码..."
  git add .
  git commit -m "${COMMIT_MESSAGE}"

  # 设置tag版本
  echo "设置tag版本: ${TAG_VERSION}"
  git tag -a "${TAG_VERSION}" -m "${COMMIT_MESSAGE}"
else
   echo "Git操作已禁用，跳过git提交和tag操作"
fi



# 检查har包是否存在
echo "检查har包..."
if ls ${HAR_FILE} 1> /dev/null 2>&1; then
    echo "找到har包文件"
else
    echo "错误: 未找到har包文件，请确认libs目录下存在har文件"
    exit 1
fi

# 4. 发布har包
echo "开始发布har包..."
PUBLISH_SUCCESS=false
for har_file in ${HAR_FILE}; do
    if [ -f "$har_file" ]; then
        echo "发布文件: $har_file"
        # 使用expect自动输入密码并检查执行结果
        expect << EOF
spawn ohpm publish "$har_file"
expect "Password:"
send "${OHPM_PASSWORD}\r"
expect eof
EOF
        # 获取expect命令的退出状态码
        expect_exit_code=$?
        # 判断执行是否成功
        if [ $expect_exit_code -eq 0 ]; then
            # shellcheck disable=SC2034
            PUBLISH_SUCCESS=true
            echo "发布成功: $har_file"
        else
            echo "发布失败: $har_file (退出码: $expect_exit_code)"
            # 退出脚本
             exit 1
        fi
    fi
done


#  推送代码和tag
if [ "$ENABLE_GIT_OPERATIONS" = true ] && [ "$PUBLISH_SUCCESS" = true ]; then
  echo "推送代码和tag..."
  git push origin main
  git push origin "${TAG_NAME}"
  git push github master
  git push github "${TAG_NAME}"
fi
echo "发布流程完成！"
