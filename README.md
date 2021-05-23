# tjuthesis

这个库旨在提供同济大学本科生毕业论文的模板, 包括一个文档类, 一些示例以及完整的使用文档, 目前仅有文档类及简单示例, 之后希望可以逐步完善.

## 如何使用

### 下载与编译

首先确保你的电脑中安装了较新的LaTeX发行版和较新的宏包, 推荐安装[texlive](https://www.tug.org/texlive/acquire-netinstall.html), 安装教程可以参考[知乎用户李阿玲](https://www.zhihu.com/people/li-a-ling)的TeXLive安装指南, 目前更新到[2020版](https://zhuanlan.zhihu.com/p/129789360).

然后将这个库下载到你的电脑中. 可以用`git clone`命令, 也可以直接下载压缩包并解压.

请使用`XeLaTeX`与`Biber`进行编译. 推荐采用`LaTeXmk`一键编译, 需要安装[Perl](https://www.perl.org/). 编译命令在`.vscode/settings.json`中给出了, 就算不用VSCode的话也可以去参考一下.

### 开始撰写

首先来看tjusetup.tex这个文件. 先根据注释的指示在`\tjusetup`命令中完善论文的基本信息, 然后再在其后引用你习惯使用的宏包, 做相应的配置, 并定义自己常用的东西.

然后是文章内容的书写. 在`data/`目录下有摘要和致谢对应的文件, 根据注释的指示填写其内容即可. 再在`data/`目录下按照个人习惯建立正文及附录的`.tex`文件, 并像`tjuthesis-example.tex`将这些文件包含在主文件中.

### 文档类提供的接口

我们将要提供一些选项, 尽情期待.

我们将要建立一个`\tjucite`的宏, 来满足一些奇怪的文献引用格式.

我们对常用字号和字体都创建了宏, 可以很方便地使用.

## 注意事项

### 文档类干了什么

文档类中引用了`unicode-math`包来提供数学符号并设置数学字体, 所以不要尝试引用一些别的与数学字体和符号有关的包.

文档类在导言区结束的时候才引用了`hyperref`包, 不过要注意若采用`ntheorem`包进行定理的排版, 需要在引用`hyperref`包之后再使用`\newtheorem`命令定义定理环境.

文档类引用了`biblatex`包并采用了`biblatex-gb7714-2015`宏包内提供的`gb7714-2015`样式, 请参照该宏包的文档来引用文献, 通常来说直接`\cite{<reference>}`或者`\cite[<page>]{<reference>}`就可以了, 也可以用`\footfullcite{<reference>}`在脚注中引用文献, 如果一篇文献仅在脚注中被引用, 那么它将不会出现在参考文献表中. 注意`.bib`文件应该放在`ref/refs.bib`, 建议使用[Zotero](https://www.zotero.org/)一键导出的功能, 我们会尽力确保一键导出的`.bib`文件就能满足要求.

### 字体

需要安装XITS, Computer Modern等字体.

若遇到xdvipdfmx报错"Invalid Font", 可以考虑修改"C:\Users\<username>\AppData\Roaming\MiKTeX\2.9\fontconfig\config\localfonts.conf"文件, 将有关T1字体的行都注释掉, 再重新编译.

## 待完成的工作

- 致谢需要加入TOC中.
- 图表的图题和编号有格式定制.
- 副标题与英文副标题.
- 设置字体时最好能精确到文件.
- 添加draft与final选项.

这里列举一些辣鸡"模板"与学校要求不同的地方.

- [] 页面geometry需要调整, 左右间距似乎不太对.
- [x] 装订线样式.
- [] 前几页不需要有页码.
- [] 各级标题与页眉的距离设置不对.
- [] 待续, 还有很多.

## 致谢

这个项目中的一些代码的用法和思路参考了[tuna/tjuthesis](https://github.com/tuna/thuthesis)和[SXKDZ/tongjithesis](https://github.com/SXKDZ/tongjithesis), 特别感谢他们.
