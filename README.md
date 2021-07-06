# tjuthesis

这个库旨在提供同济大学本科生毕业论文的模板, 包括一个文档类, 一些示例以及完整的使用文档, 目前仅有文档类及简单示例, 之后希望可以逐步完善.

请用户在使用之前先阅读完 [如何使用](#如何使用) 部分.

## 如何使用

### 下载与编译

首先确保你的电脑中安装了较新的LaTeX发行版和较新的宏包, 要求 LaTeX 版本不旧于 2020-10-01 版. 推荐安装[TeX Live 2021](https://www.tug.org/texlive/acquire-netinstall.html), 安装教程可以参考 [知乎用户李阿玲](https://www.zhihu.com/people/li-a-ling) 的 TeXLive 安装指南, 目前更新到 [2020 版](https://zhuanlan.zhihu.com/p/129789360), 2021 版也类似.

然后将这个库下载到你的电脑中. 可以用`git clone https://github.com/NotoOotori/tjuthesis.git`命令, 也可以直接下载压缩包并解压.

请使用 `XeLaTeX` 与 `Biber` 进行编译. 推荐采用 `LaTeXmk` 一键编译, 需要安装 [Perl](https://www.perl.org/). 编译命令为

```bash
  latexmk -synctex=1 -interaction=nonstopmode -file-line-error --shell-escape -xelatex <filename>
```

在 `.vscode/settings.json` 中我们也对 VSCode 配置了编译命令.

如果读者想要像示例中那样使用 `minted` 包进行代码块的排版, 则需要按照 [Python](https://wiki.python.org/moin/BeginnersGuide/Download) 和其中的 [Pygments](https://pygments.org/download/) 包.

### 开始撰写

首先来看 tjusetup.tex 这个文件. 先根据注释的指示在 `\tjusetup` 命令中完善论文的基本信息, 然后再在其后引用你习惯使用的宏包, 做相应的配置, 并定义自己常用的东西.

然后是文章内容的书写. 在 `data/` 目录下有摘要和致谢对应的文件, 根据注释的指示填写其内容即可. 再在 `data/` 目录下按照个人习惯建立正文及附录的 `.tex` 文件, 并像 `tjuthesis-example.tex` 将这些文件包含在主文件中.

## 文档类提供的接口

### 选项

#### 载入选项

以下是这个文档类特有的选项, 只能在加载文档类时设置.

- degree (学位)
  - **bacholar** (学士): 这是目前默认的也是唯一的选项.
- tju-style (样式)
  - **standard**: 主要按照 [2021 届本科生毕业设计 (论文) 工作手册](./archive/2021届毕业设计（论文）工作手册-完整版.pdf) 中对于工科类及理科类专业的要求进行排版, 并模仿 [Word 模板](./archive/毕业设计（论文）模板（理工类）.pdf) 中的排版细节.
  - math: 模仿 17 级应用数学专业被要求使用的 [TeX "模板"](./archive/应数毕业论文模板new/应数毕业论文模板new.tex) 的 [排版效果](./archive/应数毕业论文模板new/应数毕业论文模板new.pdf).

用户也可以设置其它 ctexart 文档类支持的选项.

- twoside: 适合于双面打印.

#### 其它选项

待续.

### 命令

我们将要建立一个 `\tjucite` 的宏, 来满足一些奇怪的文献引用格式.

我们对常用字号和字体都创建了宏, 可以很方便地使用.

## 注意事项

### 文档类干了什么

文档类中引用了 `unicode-math` 包来提供数学符号并设置数学字体, 所以不要尝试引用一些别的与数学字体和符号有关的包. `unicode-math` 包会在 `\AtBeginDocument` 时做不少配置, 因此数学符号的设置可以放在那之后进行.

文档类在 `\AtEndPreamble` 时才引用了 `hyperref` 包. 要注意若采用 `ntheorem` 包进行定理的排版, 需要在引用 `hyperref` 包之后再使用 `\newtheorem` 命令定义定理环境.

文档类引用了 `biblatex` 包并采用了 `biblatex-gb7714-2015` 宏包内提供的 `gb7714-2015` 样式, 请参照该宏包的文档来引用文献, 通常来说直接 `\cite{<reference>}` 或者 `\cite[<page>]{<reference>}` 就可以了, 也可以用 `\footfullcite{<reference>}` 在脚注中引用文献, 如果一篇文献仅在脚注中被引用, 那么它将不会出现在参考文献表中. **注意 `.bib` 文件应该放在 `ref/refs.bib`**, 建议使用[Zotero](https://www.zotero.org/)一键导出的功能, 我们会尽力确保一键导出的 `.bib` 文件就能满足要求.

<!-- ### 字体

需要安装XITS, Computer Modern等字体.

若遇到xdvipdfmx报错"Invalid Font", 可以考虑修改"C:\Users\<username>\AppData\Roaming\MiKTeX\2.9\fontconfig\config\localfonts.conf"文件, 将有关T1字体的行都注释掉, 再重新编译. -->

## 待完成的工作

### 文档格式设置

- [x] 页面格式设置.
  - [x] 装订线.
  - [x] 页眉.
  - [x] 页脚, 注意摘要页和目录页的页脚不同于正文.
  - [x] 上下左右的边界.
- [ ] 文本格式设置.
  - [x] 中英文摘要及关键词.
  - [x] 目录页.
  - [ ] 章节标题.
    - [x] 格式定制.
    - [ ] 说明.
  - [ ] 正文字体, 行间距与段落间距.
    - [x] 格式定制.
    - [ ] 说明.
  - [x] 参考文献.
  - [x] 谢辞.

### 排版示例及环境配置

- [ ] 分项.
- [ ] 公式.
- [ ] 定理.
- [x] 插图.
  - [x] 单张图.
  - [x] 子图.
- [ ] 表格.
  - [ ] 单页表格.
  - [ ] 跨页表格.
  - [ ] pgfplotstable 宏包使用.
- [ ] 代码.
  - [x] minted 包.
    - [x] 单页代码块.
    - [x] 跨页代码块.
  - [ ] listing 包.
- [ ] 算法.
  - [x] algorithmicx 包.
  - [ ] algorithm2e 包.
  - [ ] algpseudocodex 包.
- [ ] 文献引用.

### 其它排版细节

- [ ] 脚注.
- [ ] autoref.
- [ ] breakurl 说明.

### 其它说明

- [ ] 字体.
- [ ] 概述.

### 接口调整

我们将在当前的三位使用者完成论文之后进行可能的接口调整.

- [ ] 关键词采取某种键值对的方式输入.
- [ ] 将文献著录相关的定制移出文档类, 给用户提供选择的自由.

### 编译环境设置

- [ ] latexmkrc文件.
- [ ] 编译脚本.

### 在线编辑器支持

- [ ] Overleaf.
- [ ] TeXPages.

### 杂项

- [ ] 关于页面设置尤其是页码格式可能有bug.
- [ ] 统一代码环境与算法环境的边框的排版.
- [ ] 表格代码后空一行可能空得不够多.

## 致谢

这个项目中的一些代码的用法和思路参考了 [tuna/tjuthesis](https://github.com/tuna/thuthesis) 和 [SXKDZ/tongjithesis](https://github.com/SXKDZ/tongjithesis), 特别感谢他们. 感谢这个项目的两位第一批的使用者. 感谢单海英老师的指导.
