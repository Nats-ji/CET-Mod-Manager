### 现已支持中文，需要把控制台的默认字体改成中文字体
点按钮 <kbd>!</kbd> 选择语言。

![](https://staticdelivery.nexusmods.com/mods/3333/images/895/895-1611766356-1945566139.png)

# 如何更改字体：
1. 用文本编辑器打开 `\Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\config.json`

2. 把 `font_path` 这一项改为：`"C:\\Windows\\Fonts\\simhei.ttf"`

3. 把 `font_glyph_ranges` 这一项改为 `"ChineseFull"`

详细请参照：https://wiki.cybermods.net/cyber-engine-tweaks/v/jian-ti-zhong-wen-chinese/getting-started/configuration/change-font-and-font-size

# 功能
- 在游戏中启用或者禁用基于Cyber Engine Tweaks的mod
- 用不到的mod在游戏中一键关闭
- 可以直接从mod管理器运行使用`dofile()`命令的脚本mod

![](https://mod.3dmgame.com/ueditor/php/upload/image/20210114/1610567995552748.png) ![](https://mod.3dmgame.com/ueditor/php/upload/image/20210114/1610567995298943.png)

# 安装
1. 首先安装 控制台MOD Cyber Engine Tweaks 最新版
2. 解压后把 `bin` 文件夹放到游戏安装主路径

- 安装后目录应该像这样

   Cyberpunk 2077<br>
   └── bin<br>
   　　　└── x64<br>
   　　　　　　└── plugins<br>
   　　　　　　　　　├── cyber_engine_tweaks<br>
   　　　　　　　　　│　　└── mods<br>
   　　　　　　　　　│　　　　　└── **cet_mod_manager**<br>
   　　　　　　　　　│　　　　　　　　└── **<文件>**<br>
   　　　　　　　　　├── **cet_mod_manager.asi**<br>
   　　　　　　　　　└── cyber_engine_tweaks.asi<br>


# 使用方法
1. 在游戏中按绑定的热键打开Mod管理界面
2. 点`扫描`按钮扫描安装的mod （如果你的游戏是全屏模式的话会弹到桌面，再切换回游戏就行了，把游戏改成全屏无边框窗口的话就不会弹到桌面了）
3. 把不需要的mod勾掉
4. 点控制台的`Reload All Mods`按钮以重载Cyber Engine Tweaks
5. 在游戏中按绑定的热键可以打开脚本Mod运行界面
6. 要从mod管理器运行脚本mod的话，把脚本文件直接放到 `cet_mod_manager` 文件夹里的`dofiles`文件夹（点mod管理器里的`Dofile文件夹`按钮可以直接打开）。
7. 点左上角的`Dofile Mods`按钮进入脚本mod的列表。
8. 点mod前面的`运行`按钮就可以直接运行了。
9. 自带了几个示例脚本，不需要的话自行删除即可。

# 卸载
1. 先把所有mod都重新启用
2. 删除 `<赛博朋克2077的安装路径>/bin/x64/plugins/` 里的 `cet_mod_manager.asi`
3. 删除 `<赛博朋克2077的安装路径>/bin/x64/plugins/cyber_engine_tweaks/mods/` 里的 `cet_mod_manager`文件夹

# 目前支持的语言
- 英文
- 简体中文（翻译者：Ming）
- 繁体中文（翻译者：Ming）
- 日语（翻译者：Ming）
- 德语（翻译者：keanuWheeze）
- 俄语（翻译者：vanja-san）
- 土耳其语（翻译者：sebepne）
- 罗马尼亚语（翻译者：Maddmaniak）

# Github
https://github.com/Nats-ji/CET-Mod-Manager
