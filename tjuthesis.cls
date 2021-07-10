% !Mode::"TeX:UTF-8"
%% tjuthesis.cls
%% Copyright 2021 Chen Xuyang
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work are Chen Xuyang.
%
% This work consists only of the file tjuthesis.cls

% -------------------- Identification --------------------

\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{tjuthesis}[2021/06/01 0.0.0 Tongji University Thesis Template]

% -------------------- Preliminary Declarations --------------------


\newif\iftju@load@time
\tju@load@timetrue

\newcommand\tju@error[1]{%
  \ClassError{tjuthesis}{#1}{}%
}
\newcommand\tju@warning[1]{%
  \ClassWarning{tjuthesis}{#1}%
}

\@ifl@t@r\fmtversion{2020/10/01}{}{
  \tju@error{%
    TeX Live 2021 or later version is required to compile this document%
  }
}
\RequirePackage{iftex}
\ifXeTeX\else
  \tju@error{XeLaTeX is required to compile this document}
\fi


\newcommand\version{0.0.0}
\newcommand\DocumentClass{article}


% keyword-value设置
\RequirePackage{kvdefinekeys}
\RequirePackage{kvsetkeys}
\RequirePackage{kvoptions}
\SetupKeyvalOptions{
  family=tju,
  prefix=tju@,
  setkeys=\kvsetkeys}
\newcommand\tjusetup[1]{%
  \kvsetkeys{tju}{#1}%
}
\newcommand\tju@define@key[1]{%
  \kvsetkeys{tju@key}{#1}%
}
\newcommand\tju@define@load@time@key[1]{%
  \tju@define@key{tju@key}{#1}%
  \tju@option@hook{#1}{\iftju@load@time\else\tju@error{Option "#1" must be used as tjuthesis is loaded.}\fi}
}

\kv@set@family@handler{tju@key}{%
  \@namedef{tju@#1@@name}{#1}%
  \def\tju@@default{}%
  \def\tju@@choices{}%
  \kv@define@key{tju@value}{name}{%
    \@namedef{tju@#1@@name}{##1}%
  }%
  \@namedef{tju@#1@@check}{}%
  \@namedef{tju@#1@@code}{}%
  \kv@define@key{tju@value}{choices}{%
    \def\tju@@choices{##1}%
    \@namedef{tju@#1@@reset}{}%
    \@namedef{tju@#1@@check}{%
      \@ifundefined{%
        iftju@\@nameuse{tju@#1@@name}@\@nameuse{tju@\@nameuse{tju@#1@@name}}%
      }{%
        \tju@error{Invalid value "#1 = \@nameuse{tju@\@nameuse{tju@#1@@name}}"}%
      }%
      \@nameuse{tju@#1@@reset}%
      \@nameuse{tju@\@nameuse{tju@#1@@name}@\@nameuse{tju@\@nameuse{tju@#1@@name}}true}%
    }%
  }%
  \kv@define@key{tju@value}{default}{%
    \def\tju@@default{##1}%
  }%
  \kvsetkeys{tju@value}{#2}%
  \@namedef{tju@\@nameuse{tju@#1@@name}}{}%
  \kv@set@family@handler{tju@choice}{%
    \ifx\tju@@default\@empty
      \def\tju@@default{##1}%
    \fi
    \expandafter\newif\csname iftju@\@nameuse{tju@#1@@name}@##1\endcsname
    \expandafter\g@addto@macro\csname tju@#1@@reset\endcsname{%
      \@nameuse{tju@\@nameuse{tju@#1@@name}@##1false}%
    }%
  }%
  \kvsetkeys@expandafter{tju@choice}{\tju@@choices}%
  \expandafter\let\csname tju@\@nameuse{tju@#1@@name}\endcsname\tju@@default
  \expandafter\ifx\csname tju@\@nameuse{tju@#1@@name}\endcsname\@empty\else
    \@nameuse{tju@#1@@check}%
  \fi
  \kv@define@key{tju}{#1}{%
    \@namedef{tju@\@nameuse{tju@#1@@name}}{##1}%
    \@nameuse{tju@#1@@check}%
    \@nameuse{tju@#1@@code}%
  }%
}
\newcommand\tju@option@hook[2]{%
  \expandafter\g@addto@macro\csname tju@#1@@code\endcsname{#2}%
}
% 文档类选项
\tju@define@key{
  degree = {
    choices = {
      bachelor,
    },
    default = bachelor,
  },
  tju-style = {
    choices = {
      standard,
      math,
    },
    default = standard,
    name = style,
  },
}
%% 文档信息
\tju@define@key{
  title = {
    default = {标题},
  },
  subtitle,
  title* = {
    default = {Title},
    name = title@en,
  },
  subtitle* = {
    name = subtitle@en,
  },
  department = {
    default = {学院},
  },
  discipline = {
    default = {专业},
  },
  author = {
    default = {姓名},
  },
  id = {
    default = {学号},
  },
  supervisor = {
    default = {导师姓名},
  },
  date = {
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
}
%% 排版选项
\tju@define@key{
  font = {
    choices = {
      times,
      cmu,
    },
    default = times,
  },
  math-font = {
    name = math@font,
    choices = {
      xits,
    },
    default = xits,
  },
  cjk-font = {
    name = cjk@font,
    choices = {
      windows,
    },
    default = windows,
  },
  output = {
    choices = {
      electronic,
      print,
      draft,
    },
    default = electronic,
  },
  cover = {
    choices = {
      true,
      false,
    },
    default = false,
    name = cover,
  },
}


% -------------------- Handle Options --------------------

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ctexart}}
\ProcessKeyvalOptions*
\tju@load@timefalse

% -------------------- More Declarations --------------------

% 不显示Warning (Times字体没有MathScript Style)
\PassOptionsToPackage{quiet}{fontspec}


\LoadClass[a4paper, zihao=5, fontset=none]{ctexart}

\if@twoside
  \iftju@style@math
    \tju@warning{The option "twoside" is not supported for style=math.}
  \fi
\fi

% 引用必要宏包
\RequirePackage{etoolbox}
\RequirePackage{xpatch}
\RequirePackage{xparse}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage[titles]{tocloft}
% \RequirePackage{titletoc}
\RequirePackage{notoccite}
\RequirePackage{amsmath}
% unicode-math should be loaded after any other packages that mess
%   with the math functionality.
\RequirePackage{unicode-math}
\RequirePackage{graphicx}
\RequirePackage{subcaption}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{newfloat}
\RequirePackage{pdfpages}
\includepdfset{fitpaper=true}
\RequirePackage{enumitem}
\RequirePackage{environ}
\RequirePackage{xeCJKfntef}
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{url}
\RequirePackage{filehook}
\newcommand\tju@package@conflict[2]{
  \AtBeginOfPackageFile*{#2}{
    \tju@error{The "#2" package is incompatible with required "#1".}
  }
}
\tju@package@conflict{unicode-math}{amscd}
\tju@package@conflict{unicode-math}{amsfonts}
\tju@package@conflict{unicode-math}{amssymb}
\tju@package@conflict{unicode-math}{bbm}
\tju@package@conflict{unicode-math}{bm}
\tju@package@conflict{unicode-math}{eucal}
\tju@package@conflict{unicode-math}{eufrak}
\tju@package@conflict{unicode-math}{mathrsfs}


% 正文字体大小
\newlength\tju@font@size@standard@normal
\setlength\tju@font@size@standard@normal{9bp}
\newlength\tju@font@size@normal
\setlength\tju@font@size@normal{9bp}
\newlength\tju@line@height@normal
\setlength\tju@line@height@normal{1.2\tju@font@size@normal}
\newcommand\tju@set@font@size@math{
  \renewcommand\normalsize{%
    \@setfontsize\normalsize{10.5bp}{12.6bp}%
    \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
    \abovedisplayshortskip \z@ \@plus3\p@
    \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
    \belowdisplayskip \abovedisplayskip
  }
}
\newcommand\tju@set@font@size@standard{%
  \renewcommand\normalsize{%
    \@setfontsize\normalsize{10.5bp}{18bp}%
    \abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@
    \abovedisplayshortskip \z@ \@plus3\p@
    \belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@
    \belowdisplayskip \abovedisplayskip
  }
  \normalsize
  \ifx\MakeRobust\@undefined \else
      \MakeRobust\normalsize
  \fi
  % TODO: 故意设置得奇怪一点观察有没有地方用到
  \DeclareRobustCommand\small{%
    \@setfontsize\small{12bp}{20bp}%
    \abovedisplayskip 6bp%
    \abovedisplayshortskip 6bp%
    \belowdisplayshortskip 6bp%
    \def\@listi{\leftmargin\leftmargini
                \topsep \z@skip
                \parsep \z@skip
                \itemsep \z@skip}%
    \belowdisplayskip \abovedisplayskip
  }
}
\newcommand\tju@set@font@size{\@nameuse{tju@set@font@size@\tju@style}}
\tju@set@font@size


% 设置常用字号
\def\tju@def@fontsize#1#2{%
  \expandafter\newcommand\csname #1\endcsname[1][1.3]{%
    \fontsize{#2}{##1\dimexpr #2}\selectfont}}
\tju@def@fontsize{chuhao}{42bp}
\tju@def@fontsize{xiaochu}{36bp}
\tju@def@fontsize{yihao}{26bp}
\tju@def@fontsize{xiaoyi}{24bp}
\tju@def@fontsize{erhao}{22bp}
\tju@def@fontsize{xiaoer}{18bp}
\tju@def@fontsize{sanhao}{16bp}
\tju@def@fontsize{xiaosan}{15bp}
\tju@def@fontsize{sihao}{14bp}
\tju@def@fontsize{banxiaosi}{13bp}
\tju@def@fontsize{xiaosi}{12bp}
\tju@def@fontsize{dawu}{11bp}
\tju@def@fontsize{wuhao}{10.5bp}
\tju@def@fontsize{xiaowu}{9bp}
\tju@def@fontsize{liuhao}{7.5bp}
\tju@def@fontsize{xiaoliu}{6.5bp}
\tju@def@fontsize{qihao}{5.5bp}
\tju@def@fontsize{bahao}{5bp}


% 论文基本结构
\newif\iftju@mainmatter
\tju@mainmatterfalse
\newcommand\frontmatter{%
  \cleardoublepage
  \tju@mainmatterfalse
  \pagestyle{front}
  \tju@set@page@numbering@front}

\newcommand\mainmatter{%
  \cleardoublepage
  \tju@mainmattertrue
  \pagestyle{main}
  \tju@set@page@numbering@main
}

\newcommand\backmatter{%
  \cleardoublepage
  \tju@mainmatterfalse
}


% 字体
\let\tju@font@extension@cmu\@empty
\newcommand\tju@set@cmu@names{%
  \ifx\tju@font@extension@cmu\@empty
    \gdef\tju@font@extension@cmu{.otf}%
    \gdef\tju@font@name@cmu@rm{cmunrm}%
    \gdef\tju@font@name@cmu@bf{cmunbx}%
    \gdef\tju@font@name@cmu@it{cmunti}%
    \gdef\tju@font@name@cmu@bfit{cmunbi}%
  \fi
}
\let\tju@font@extension@times\@empty
\newcommand\tju@set@times@names{%
  \ifx\tju@font@extension@times\@empty
    \IfFontExistsTF{times.ttf}{%
      \gdef\tju@font@extension@times{.ttf}%
      \gdef\tju@font@name@times@rm{times}%
      \gdef\tju@font@name@times@bf{timesbd}%
      \gdef\tju@font@name@times@it{timesi}%
      \gdef\tju@font@name@times@bfit{timesbi}%
    }{%
      \gdef\tju@font@extension@times{.otf}%
      \gdef\tju@font@name@times@rm{texgyretermes-regular}%
      \gdef\tju@font@name@times@bf{texgyretermes-bold}%
      \gdef\tju@font@name@times@it{texgyretermes-italic}%
      \gdef\tju@font@name@times@bfit{texgyretermes-bolditalic}%
    }%
  \fi
}
% TODO: refactor to match times and cmu
\let\tju@font@family@xits\@empty
\newcommand\tju@set@xits@names{%
  \ifx\tju@font@family@xits\@empty
    \IfFontExistsTF{XITSMath-Regular.otf}{%
      \gdef\tju@font@family@xits{XITS}%
      \gdef\tju@font@style@xits@rm{Regular}%
      \gdef\tju@font@style@xits@bf{Bold}%
      \gdef\tju@font@style@xits@it{Italic}%
      \gdef\tju@font@style@xits@bfit{BoldItalic}%
      \gdef\tju@font@name@xits@math@rm{XITSMath-Regular}%
      \gdef\tju@font@name@xits@math@bf{XITSMath-Bold}%
    }{%
      \gdef\tju@font@family@xits{xits}%
      \gdef\tju@font@style@xits@rm{regular}%
      \gdef\tju@font@style@xits@bf{bold}%
      \gdef\tju@font@style@xits@it{italic}%
      \gdef\tju@font@style@xits@bfit{bolditalic}%
      \gdef\tju@font@name@xits@math@rm{xits-math}%
      \gdef\tju@font@name@xits@math@bf{xits-mathbold}%
    }%
  \fi
}
\newcommand\tju@set@font@names{%
  \def\tju@font@extension{\@nameuse{tju@font@extension@\tju@font}}%
  \def\tju@font@name@rm{\@nameuse{tju@font@name@\tju@font @rm}}%
  \def\tju@font@name@bf{\@nameuse{tju@font@name@\tju@font @bf}}%
  \def\tju@font@name@it{\@nameuse{tju@font@name@\tju@font @it}}%
  \def\tju@font@name@bfit{\@nameuse{tju@font@name@\tju@font @bfit}}%
}


% 英文字体 % TODO: Load fonts explicitly
\newif\iftju@math@font@loaded
\tju@math@font@loadedfalse
\newcommand\tju@load@font{%
  \@nameuse{tju@set@\tju@font @names}%
  \tju@set@font@names%
  \setmainfont{\tju@font@name@rm}[%
    Ligatures = TeX,
    Extension = \tju@font@extension,
    BoldFont = \tju@font@name@bf,
    ItalicFont = \tju@font@name@it,
    BoldItalicFont = \tju@font@name@bfit,
  ]
  \setsansfont{Arial}%
  \setmonofont{Courier New}[Scale = MatchLowercase]%
}
\tju@load@font
\tju@option@hook{font}{%
  \tju@load@font%
  \iftju@math@font@loaded
    \tju@load@math@num@font%
  \fi
}


% 数学字体
\unimathsetup{%
  math-style = ISO,
  bold-style = ISO,
  nabla = upright,
  partial = upright,
}
\newcommand\tju@load@math@num@font{%
  \setmathfont{\tju@font@name@rm}[
    Extension = \tju@font@extension,
    range = up/{num},
    BoldFont = \tju@font@name@bf,
  ]
  \setmathfont{\tju@font@name@bf}[
    Extension = \tju@font@extension,
    range = bfup/{num},
    BoldFont = \tju@font@name@bf,
  ]
}
\newcommand\tju@load@math@font@xits{%
  \tju@set@xits@names
  \setmathfont{\tju@font@name@xits@math@rm}[
    Extension = .otf,
    BoldFont = \tju@font@name@xits@math@bf,
    StylisticSet = 8,
  ]
  \setmathfont{\tju@font@name@xits@math@rm}[
    Extension = .otf,
    BoldFont = \tju@font@name@xits@math@bf,
    StylisticSet = 1,
    range = {cal, bfcal},
  ]
  \setmathfont{\tju@font@name@xits@math@rm}[
    Extension = .otf,
    BoldFont = \tju@font@name@xits@math@bf,
    range = it/{greek,Greek,latin,Latin},
  ]
  \setmathfont{\tju@font@name@xits@math@rm}[
    Extension = .otf,
    BoldFont = \tju@font@name@xits@math@bf,
    range = up/{greek,Greek,latin,Latin},
  ]
  \setmathfont{\tju@font@name@xits@math@rm}[
    Extension = .otf,
    BoldFont = \tju@font@name@xits@math@bf,
    range = {
      "2212,"002B,"003D,"0028,"0029,"005B,%
      "005D,"221A,"2211,"2248,"222B,"007C,"2026,"2202,"00D7,"0302,%
      "2261,"0025,"22C5,"00B1,"2194,"21D4%
    },
  ]
}
\newcommand\tju@load@math@font{%
  \@nameuse{tju@load@math@font@\tju@math@font}%
  \tju@load@math@num@font%
  \tju@math@font@loadedtrue%
}
\tju@load@math@font
\tju@option@hook{math-font}{\tju@load@math@font}


% 中文字体
\newcommand\tju@cjk@embolden@factor{4}
\newcommand\tju@load@cjk@font@windows{%
  \xeCJKsetup{EmboldenFactor = \tju@cjk@embolden@factor}
  \setCJKmainfont{SimSun}[
    BoldFont = SimHei,
    ItalicFont   = KaiTi,
    % ItalicFeatures = { AutoFakeBold = true },
    BoldItalicFont   = KaiTi,
    BoldItalicFeatures = { FakeBold = \tju@cjk@embolden@factor },
  ]%
  \setCJKsansfont{SimHei}[AutoFakeBold]%
  \setCJKmonofont{FangSong}[
    AutoFakeBold = true,
    ItalicFont = KaiTi,
  ]%
  \newCJKfontfamily\zhsong{SimSun}[
    AutoFakeBold = true,
    ItalicFont   = KaiTi,
    % ItalicFeatures = { AutoFakeBold = true },
    BoldItalicFont   = KaiTi,
    BoldItalicFeatures = { FakeBold = \tju@cjk@embolden@factor },
  ]%
  \newfontfamily\songti{SimSun}[
    AutoFakeBold = true,
    ItalicFont   = SimSun,
  ]
  \newCJKfontfamily\zhhei{SimHei}[
    BoldFont = SimHei,
    BoldFeatures = { FakeBold = \tju@cjk@embolden@factor },
  ]%
  \newCJKfontfamily\zhkai{KaiTi}[AutoFakeBold]%
  \newCJKfontfamily\zhfs{FangSong}[
    AutoFakeBold = true,
    ItalicFont = KaiTi,
  ]%
}
\newcommand\tju@load@cjk@font{%
  \@nameuse{tju@load@cjk@font@\tju@cjk@font}%
}
\tju@load@cjk@font
\tju@option@hook{cjk-font}{\tju@load@cjk@font}


% 双页
\NewDocumentCommand\tju@emptypage{s}{%
  \hbox{}%
  \IfBooleanTF{#1}{\thispagestyle{empty}\tju@this@gutter@off}{}
  \newpage%
}%
\let\cleardoublepage\relax%
\NewDocumentCommand\cleardoublepage{s}{%
  \clearpage%
  \if@twoside%
    \ifodd\c@page%
        % do nothing
    \else%
      \IfBooleanTF{#1}{\tju@emptypage*}{\tju@emptypage}%
    \fi%
  \fi%
}%


% 页面尺寸
\newcommand\tju@set@geometry@standard{
  \geometry{
    top = 1.67in,
    bottom = 1.05in,
    left = 1.38in,
    right = 0.76in,
    headheight = 45pt,
  }
}
\newcommand\tju@set@geometry@math{
  \geometry{
    top = \dimexpr32mm+42.82419pt-4.5mm\relax,
    bottom = \dimexpr38mm-42.82419pt+4.4mm\relax,
    left = 33mm,
    right = 18mm,
    % headsep = \dimexpr32mm-42.82419pt\relax,
    headheight = 42.82419pt,
    % showframe,
  }
}
\newcommand\tju@set@geometry{\@nameuse{tju@set@geometry@\tju@style}}
\tju@set@geometry


% 装订线
\newcommand{\tju@put@gutter@math}{%
  \RequirePackage{fancybox}
  \fancyput*(-0.8cm,-4.3cm){$|$}%
  \fancyput*(-0.8cm,-4.9cm){$|$}%
  \fancyput*(-0.8cm,-5.5cm){$|$}%
  \fancyput*(-0.8cm,-6.1cm){$|$}%
  \fancyput*(-0.8cm,-6.7cm){$|$}%
  \fancyput*(-0.8cm,-7.3cm){$|$}%
  \fancyput*(-0.8cm,-7.9cm){$|$}%
  \fancyput*(-0.8cm,-8.5cm){$|$}%
  \fancyput*(-0.8cm,-9.1cm){$|$}%
  \fancyput*(-0.8cm,-9.7cm){$|$}%
  \fancyput*(-1.0cm,-10.3cm){装}%
  \fancyput*(-0.8cm,-10.9cm){$|$}%
  \fancyput*(-0.8cm,-11.5cm){$|$}%
  \fancyput*(-0.8cm,-12.1cm){$|$}%
  \fancyput*(-0.8cm,-12.7cm){$|$}%
  \fancyput*(-0.8cm,-13.3cm){$|$}%
  \fancyput*(-1.0cm,-13.9cm){订}%
  \fancyput*(-0.8cm,-14.5cm){$|$}%
  \fancyput*(-0.8cm,-15.1cm){$|$}%
  \fancyput*(-0.8cm,-15.7cm){$|$}%
  \fancyput*(-0.8cm,-16.3cm){$|$}%
  \fancyput*(-0.8cm,-16.9cm){$|$}%
  \fancyput*(-1.0cm,-17.5cm){线}%
  \fancyput*(-0.8cm,-18.1cm){$|$}%
  \fancyput*(-0.8cm,-18.7cm){$|$}%
  \fancyput*(-0.8cm,-19.3cm){$|$}%
  \fancyput*(-0.8cm,-19.9cm){$|$}%
  \fancyput*(-0.8cm,-20.5cm){$|$}%
  \fancyput*(-0.8cm,-21.1cm){$|$}%
  \fancyput*(-0.8cm,-21.7cm){$|$}%
  \fancyput*(-0.8cm,-22.3cm){$|$}%
  \fancyput*(-0.8cm,-22.9cm){$|$}%
  \fancyput*(-0.8cm,-23.5cm){$|$}%
}
\newcommand\tju@this@gutter@off@math{\thisfancyput{}}
\newcommand{\tju@put@gutter@standard}{%
  \XeTeXcharclass`┊=1
  \newlength\tju@gutter@right@x
  \newlength\tju@gutter@right@y
  \newlength\tju@gutter@left@x
  \newlength\tju@gutter@left@y
  \newlength\tju@gutter@x
  \newlength\tju@gutter@y
  \setlength\tju@gutter@right@x{1.69cm}
  \setlength\tju@gutter@right@y{-15.20cm}
  \setlength\tju@gutter@left@x{19.12cm}
  \setlength\tju@gutter@left@y{-15.20cm}
  \setlength\tju@gutter@x{\tju@gutter@right@x}
  \setlength\tju@gutter@y{\tju@gutter@right@y}
  \newif\iftju@gutter@this@page
  \tju@gutter@this@pagetrue
  \AddToHook{shipout/background}{%
    \iftju@gutter@this@page
      \if@twoside
        \ifodd\ReadonlyShipoutCounter
          \setlength\tju@gutter@x{\tju@gutter@right@x}
          \setlength\tju@gutter@y{\tju@gutter@right@y}
        \else
          \setlength\tju@gutter@x{\tju@gutter@left@x}
          \setlength\tju@gutter@y{\tju@gutter@left@y}
        \fi
      \fi
      \put(\tju@gutter@x,\tju@gutter@y){\wuhao[0.48cm]\parbox{1\ccwd}{┊┊┊┊┊┊┊┊┊┊┊┊┊装┊┊┊┊┊订┊┊┊┊┊线┊┊┊┊┊┊┊┊┊┊┊┊┊}}%
    \fi
    \setlength\tju@gutter@x{\tju@gutter@right@x}
    \setlength\tju@gutter@y{\tju@gutter@right@y}
  }
  % \fancyput(-0.86cm,-12.745cm){\wuhao[0.48cm]\parbox{1\ccwd}{┊┊┊┊┊┊┊┊┊┊┊┊┊装┊┊┊┊┊订┊┊┊┊┊线┊┊┊┊┊┊┊┊┊┊┊┊┊}}% -0.66cm
}
\newcommand\tju@this@gutter@off@standard{%
  \AddToHookNext{shipout/before}{\tju@gutter@this@pagefalse}%
  \AddToHookNext{shipout/background}{\tju@gutter@this@pagetrue}%
}
\newcommand\tju@this@gutter@off{\@nameuse{tju@this@gutter@off@\tju@style}}
\newcommand{\tju@put@gutter}{\@nameuse{tju@put@gutter@\tju@style}}
\tju@put@gutter



% 页眉页脚
\newcommand\tju@new@page@style@standard@head{%
  \if@twoside
    \fancyhead[LO,RE]{\qquad \includegraphics{tongji-name-bacholar.jpg}}%
    \fancyhead[RO,LE]{\xiaosi \raisebox{0.15in}{毕业设计（论文）}}%
  \else
    \fancyhead[L]{\qquad \includegraphics{tongji-name-bacholar.jpg}}%
    \fancyhead[R]{\xiaosi \raisebox{0.15in}{毕业设计（论文）}}%
  \fi
  \renewcommand{\headrulewidth}{1.5pt}%
  \fancyhfoffset{0.02in}
}
\newcommand\tju@new@page@style@standard@front@foot{%
  \renewcommand{\footrulewidth}{0pt}%
  \fancyfoot[C]{\xiaosi \raisebox{-0.02in}{\thepage}}%
}
\newcommand\tju@new@page@style@standard@main@foot{%
  \renewcommand{\footrulewidth}{1.5pt}%
  \if@twoside
    \fancyfoot[RO,LE]{\leavevmode\smash{\xiaosi\zhsong 共\hspace*{1\ccwd}\pageref{LastPage}\hspace*{1\ccwd}页\hspace*{1.5\ccwd}第\hspace*{1\ccwd}\thepage\hspace*{1\ccwd}页}}%
  \else
    \fancyfoot[R]{\leavevmode\smash{\xiaosi\zhsong 共\hspace*{1\ccwd}\pageref{LastPage}\hspace*{1\ccwd}页\hspace*{1.5\ccwd}第\hspace*{1\ccwd}\thepage\hspace*{1\ccwd}页}}%
  \fi
}
\newcommand\tju@new@page@style@standard@front{%
  \fancypagestyle{front}{%
    \fancyhf{}%
    \tju@new@page@style@standard@head%
    \tju@new@page@style@standard@front@foot%
  }
}
\newcommand\tju@set@page@numbering@standard@front{%
  \pagenumbering{Roman}
}
\newcommand\tju@new@page@style@standard@main{%
  \fancypagestyle{main}{%
    \fancyhf{}%
    \tju@new@page@style@standard@head%
    \tju@new@page@style@standard@main@foot%
  }
}
\newcommand\tju@set@page@numbering@standard@main{%
  \pagenumbering{arabic}
}
\newcommand\tju@new@page@style@math@front{%
  \fancypagestyle{front}{%
    \fancyhf{}%
    \fancyhead[L]{\qquad \includegraphics[height=1.34cm]{tongji-name-bacholar.jpg}}%
    \fancyhead[R]{\xiaosi 毕业设计（论文）~\\}%
    \renewcommand{\headrulewidth}{1.5pt}%
    \renewcommand{\footrulewidth}{1.5pt}%
    \fancyfoot[R]{\leavevmode\smash{\xiaosi 共\quad \pageref{LastPage}\quad 页\quad 第\quad \thepage \quad 页}}% LE,RO if twoside
  }
}
\newcommand\tju@set@page@numbering@math@front{%
  \pagenumbering{arabic}
}
\newcommand\tju@new@page@style@math@main{%
  \fancypagestyle{main}{%
    \fancyhf{}%
    \fancyhead[L]{\qquad \includegraphics[height=1.34cm]{tongji-name-bacholar.jpg}}%
    \fancyhead[R]{\xiaosi 毕业设计（论文）~\\}%
    \renewcommand{\headrulewidth}{1.5pt}%
    \renewcommand{\footrulewidth}{1.5pt}%
    \fancyfoot[R]{\leavevmode\smash{\xiaosi 共\quad \pageref{LastPage}\quad 页\quad 第\quad \thepage \quad 页}}% LE,RO if twoside
  }
}
\newcommand\tju@set@page@numbering@math@main{}
\newcommand\tju@new@page@style@front{%
  \@nameuse{tju@new@page@style@\tju@style @front}
}
\newcommand\tju@new@page@style@main{%
  \@nameuse{tju@new@page@style@\tju@style @main}
}
\newcommand\tju@new@page@style{%
  \tju@new@page@style@front
  \tju@new@page@style@main
  \pagestyle{main}
}
\newcommand\tju@set@page@numbering@front{%
  \@nameuse{tju@set@page@numbering@\tju@style @front}
}
\newcommand\tju@set@page@numbering@main{%
  \@nameuse{tju@set@page@numbering@\tju@style @main}
}
\tju@new@page@style



% hyperref 宏包在最后调用
\AtEndPreamble{
  \RequirePackage{hyperref}
  \RequirePackage{bookmark}

  \pdfstringdefDisableCommands{% to add definitions for commands that make no sense in bookmarks https://tex.stackexchange.com/a/142276
    \let\enspace\empty% this causes the warning for \kern
    \let\noindent\empty% this causes the warning for \indent
    \let\quad\space% this causes the warning for \quad
  }

  \hypersetup{linktoc=all}% TOC中章节名称和页码都是超链接
  % \hypersetup{% 超链接样式
  %   colorlinks  =   true,
  %   linkcolor   =   cyan,
  %   anchorcolor =   black,
  %   citecolor   =   green,
  %   filecolor   =   cyan,
  %   menucolor   =   red,
  %   runcolor    =   filecolor,
  %   urlcolor    =   magenta,
  % }
  \hypersetup{% 书签
    bookmarksopen = true,
    bookmarksopenlevel = 2,
    bookmarksnumbered = true,% 将章节编号放入书签中
  }
  \newcommand\tju@pdf@page@layout{%
    \if@twoside
      TwoPageRight%
    \else
      SinglePage%
    \fi
  }
  \hypersetup{% PDF默认打开视图
    pdfpagemode = UseNone,
    pdfstartview = Fit,
    pdfpagelayout = \tju@pdf@page@layout,
  }
  \hypersetup{pdftitle={\tju@title}}
  \hypersetup{pdfauthor={\tju@author}}
  % PDF信息
  % \newcommand\tju@set@pdf@meta[2]{% https://tex.stackexchange.com/a/495206
  %   \protected@write\@auxout{}{%
  %     \string\ifx\string\@onlypreamble\string\@notprerr
  %     \string\else
  %       \string\AtBeginDocument{\string\def\string\@pdf#1{#2}}%
  %     \string\fi
  %   }%
  % }
  % \AddToHook{enddocument/afterlastpage}{
  %   % \hypersetup{pdftitle={\tju@title}}
  %   % \hypersetup{pdfauthor={\tju@author}}
  %   % \hypersetup{pdfkeywords={\tju@keywords}}
  %   \tju@set@pdf@meta{title}{\tju@title}
  %   \tju@set@pdf@meta{author}{\tju@author}
  %   \tju@set@pdf@meta{keywords}{\tju@keywords}
  % }
}


% 行间距
\newcommand\tju@set@line@spread@standard{\linespread{1.0}}
\newcommand\tju@set@line@spread@math{\linespread{1.3}}
\newcommand\tju@set@line@spread{\@nameuse{tju@set@line@spread@\tju@style}}
\tju@set@line@spread


% 标题页
\newcommand{\tjuputcover}{%
  \clearpage%
  \renewcommand\thepage{C\arabic{page}}%
  \tju@put@cover%
  \cleardoublepage%
  \pagenumbering{Roman}
}
\newcommand\tju@put@cover{%
  \iftju@cover@true
    \newgeometry{
      hmargin = 3.18cm,
      vmargin = 2.54cm,
    }
    \thispagestyle{empty}%
    \tju@this@gutter@off%
    \linespread{1.0}
    \vspace*{\dimexpr-\baselineskip+1.5\tju@line@height@normal\relax}%
    \begingroup
      \centering\includegraphics{tongji-name-bacholar-cover.pdf}%
      \vskip 0.50cm%
    \endgroup
    \begingroup
      \centering\xiaoer\MakeUppercase{\textbf{Tongji University}}%
      \vskip 1.00cm%
    \endgroup
    \begingroup
      \centering\xiaochu\zhhei 毕业设计（论文）%
      \vskip 2.96cm%
    \endgroup
    {\centering\tju@put@cover@info}%
    \cleardoublepage*%
    \restoregeometry
    \tju@set@line@spread
  \fi
}
\newcommand\tju@put@cover@info{%
  \tju@put@cover@info@tabular{4\ccwd}{4\ccwd}{0.64cm}{10.80cm}{%
    \tju@info@item{课题名称}{}{\tju@title}
    \tju@info@item{副标题}{}{\tju@subtitle}
    \tju@info@item{学院}{}{\tju@department}
    \tju@info@item{专业}{}{\tju@discipline}
    \tju@info@item{学生姓名}{}{\tju@author}
    \tju@info@item{学号}{}{\tju@id}
    \tju@info@item{指导教师}{\tju@name@title}{\tju@supervisor}
    \tju@info@item{日期}{}{\tju@format@date\tju@date@zh@digit{\tju@date}}
  }
}
\newcommand\tju@put@cover@info@tabular[5]{%
  \def\tju@info@item##1##2##3{%
    % \ifx##3\@empty\else
      \tju@pad{#1}{\tju@fixed@box{#2}{##1}}%
      \tju@pad{#3}{}%
      \tju@CJKunderline[#4]{\tju@par{#4}{##2{##3}}}\\
    % \fi
  }%
  \xiaoer[40bp]\zhhei
  \begin{tabular}{l}%
    #5%
  \end{tabular}%
}
\newcommand\tju@format@date[2]{%
  \edef\tju@@date{#2}%
  \def\tju@@process@date##1-##2-##3\@nil{%
    #1{##1}{##2}{##3}%
  }%
  \expandafter\tju@@process@date\tju@@date\@nil
}
\newcommand\tju@date@zh@digit[3]{#1 年 \number#2 月 \number#3 日}
\newcommand\tju@date@zh@digit@short[3]{#1 年 \number#2 月}
\newcommand\tju@date@zh@short[3]{\zhdigits{#1}年\zhnumber{#2}月}
\newcommand\tju@date@month[1]{%
  \ifcase\number#1\or
    January\or February\or March\or April\or May\or June\or
    July\or August\or September\or October\or November\or December%
  \fi
}
\newcommand\tju@date@en@short[3]{\tju@date@month{#2}, #1}
\newcommand\tju@underline[2][6em]{\hskip1pt\underline{\hb@xt@ #1{\hss#2\hss}}\hskip3pt}
\newcommand\tju@CJKunderline[2][6em]{\CJKunderline*{\hb@xt@ #1{\hss#2\hss}}}
\newbox\tju@stretch@box
\newcommand\tju@stretch[2]{%
  \sbox\tju@stretch@box{#2}%
  \ifdim \wd\tju@stretch@box < #1\relax
    \begingroup
      \def\CJKglue{\hskip 0pt plus 2filll}%
      \makebox[#1][l]{#2}%
    \endgroup
  \else
    \box\tju@stretch@box
  \fi
}
% 如果内容小于给定宽度, 则在右侧填充空白至该宽度, 否则取自然宽度.
\newbox\tju@pad@box
\newcommand\tju@pad[2]{%
  \sbox\tju@pad@box{#2}%
  \ifdim \wd\tju@pad@box < #1\relax
    \makebox[#1][l]{\box\tju@pad@box}%
  \else
    \box\tju@pad@box
  \fi
}
\newbox\tju@par@box
\newcommand\tju@par[2]{%
  \sbox\tju@par@box{#2}%
  \ifdim \wd\tju@par@box < #1\relax
    \makebox[#1][c]{\box\tju@par@box}%
  \else
    \box\tju@par@box
  \fi
}
% 将文本分散排在固定长度的box里
\newcommand\tju@fixed@box[2]{%
  \begingroup
    \def\CJKglue{\hskip 0pt plus 2filll minus 1filll}%
    \makebox[#1][l]{#2}%
  \endgroup
}
% 导师职称排版
\newcounter{tju@csl@count}
\newcommand\tju@name@title@process[1]{%
  \ifcase\c@tju@csl@count  % == 0
    \gdef\tju@@name{#1}%
  \or  % == 1
    \gdef\tju@@title{#1}%
  \fi
  \stepcounter{tju@csl@count}%
}
\newcommand\tju@name@title@format[2]{%
  \tju@stretch{3em}{#1}%
  \ifx#2\@empty\else
    \tju@pad{0.5em}{}
    \tju@stretch{3em}{#2}%
  \fi
}
\newcommand\tju@name@title[1]{%
  \setcounter{tju@csl@count}{0}%
  \gdef\tju@@name{}%
  \gdef\tju@@title{}%
  \expandafter\comma@parse\expandafter{#1}{\tju@name@title@process}%
  \tju@name@title@format{\tju@@name}{\tju@@title}%
}


% 摘要
\tju@define@key{
  keywords,
  keywords* = {
    name = keywords@en,
  },
}
\newcommand\tju@clist@use[2]{%
  \def\tju@@tmp{}%
  \def\tju@clist@processor##1{%
    \ifx\tju@@tmp\@empty
      \def\tju@@tmp{#2}%
    \else
      #2%
    \fi
    ##1%
  }%
  \expandafter\comma@parse\expandafter{#1}{\tju@clist@processor}%
}
\newcommand{\tju@abstract@name@standard}{摘\hspace*{0.5\ccwd}要}
\newcommand{\tju@abstract@name@math}{摘\quad 要}
\newcommand{\tju@abstract@name}{\@nameuse{tju@abstract@name@\tju@style}}
\newcommand{\tju@keywords@name}{关键词}
\newcommand{\tju@abstract@name@en}{ABSTRACT}
\newcommand{\tju@keywords@name@en}{Key words}
\let\abstract\relax
\let\endabstract\relax
\newcommand{\tju@newenv@abstract@standard}{%
  \newenvironment{abstract}[1]{%
    \tjusetup{
      keywords = {##1}
    }
    \cleardoublepage*%
    \vspace*{\dimexpr-\baselineskip+1.5\tju@line@height@normal\relax}%
    \begingroup
      \centering\bf\xiaoer\zhhei\tju@title%
      \vskip 0.5\tju@line@height@normal%
    \endgroup
    \ifx\tju@subtitle\@empty
      \vskip 1.0\tju@line@height@normal%
    \else
    \begingroup
      \vskip 0.5\tju@line@height@normal%
      \centering\sanhao\zhhei\tju@subtitle%
      \vskip 1.5\tju@line@height@normal%
    \endgroup
    \fi
    \begingroup
      \vskip \dimexpr0.5\tju@line@height@normal+9bp\relax% 这里的9bp应是 \baselineskip-\tju@font@size@normal
      \centering\sihao[18bp]\zhhei\tju@abstract@name%
      \vskip 0.5\tju@line@height@normal%
    \endgroup
    \par%
    \begingroup
      \wuhao[18bp]\zhsong
  }{%
    \endgroup
    \vskip \dimexpr1.0\tju@line@height@normal+9bp\relax%
    \begingroup
      \noindent%
      \bf\wuhao\zhsong\tju@keywords@name：%
    \endgroup%
    \begingroup%
      \wuhao\zhsong\tju@clist@use{\tju@keywords}{，}%
    \endgroup
    \cleardoublepage
  }
  \newenvironment{abstract*}[1]{
    \tjusetup{
      keywords* = {##1},
    }
    \cleardoublepage
    \vspace*{\dimexpr-\baselineskip+1.5\tju@line@height@normal\relax}%
    \begingroup
      \centering\bf\xiaoer\tju@title@en%
      \vskip 0.5\tju@line@height@normal%
    \endgroup
    \ifx\tju@subtitle@en\@empty
      \vskip 1.0\tju@line@height@normal%
    \else
    \begingroup
      \vskip 0.5\tju@line@height@normal%
      \centering\sanhao\tju@subtitle@en%
      \vskip 1.5\tju@line@height@normal%
    \endgroup
    \fi
    \begingroup
      \vskip \dimexpr0.5\tju@line@height@normal+9bp\relax% 这里的9bp应是 \baselineskip-\tju@font@size@normal
      \centering\sihao[18bp]\tju@abstract@name@en%
      \vskip 0.5\tju@line@height@normal%
    \endgroup
    \par%
    \begingroup
      \wuhao[18bp]
  }{%
    \endgroup
    \vskip \dimexpr1.0\tju@line@height@normal+9bp\relax%
    \begingroup
      \noindent%
      \bf\wuhao\tju@keywords@name@en: %
    \endgroup%
    \begingroup%
      \wuhao\tju@clist@use{\tju@keywords@en}{, }%
    \endgroup
    \cleardoublepage
  }
}
\newcommand{\tju@newenv@abstract@math}{%
  \newenvironment{abstract}[1]{%
    \tjusetup{
      keywords = {##1}
    }
    \clearpage
    \pagenumbering{arabic}
    \newgeometry{
      top = \dimexpr32mm+42.82419pt+21.41209pt-0.5mm\relax,
      bottom = \dimexpr38mm-42.82419pt+4.4mm\relax,
      left = 33mm,
      right = 18mm,
      headheight = 42.82419pt,
    }
    \null\vskip -1\ccwd
    \begingroup
      \erhao\centering\zhhei\tju@title\par%
    \endgroup
    \ifx\tju@subtitle\@empty
      \relax
    \else
      \begin{center}
        \xiaoer\zhhei\tju@subtitle\par%
      \end{center}
    \fi
    \begin{center}
      \sihao\zhhei\tju@abstract@name%
    \end{center}
    \par%
    \begingroup
      \xiaowu\zhsong
  }{%
    \endgroup
    \vskip 5mm
    \begingroup
      \noindent
      \wuhao\zhhei\tju@keywords@name:%
    \endgroup
    \begingroup
      \quad\xiaowu\tju@clist@use{\tju@keywords}{, \quad}%
    \endgroup
    \clearpage
    \aftergroup\restoregeometry
  }
  \newenvironment{abstract*}[1]{
    \tjusetup{
      keywords* = {##1},
    }
    \clearpage
    \begin{center}
      \linespread{1}
      \erhao\bf\tju@title@en%
    \end{center}
    \ifx\tju@subtitle@en\@empty
      \relax
    \else
      \begin{center}
        \xiaoer\zhhei\tju@subtitle@en\par%
      \end{center}
    \fi
    \begin{center}
      \sihao\bf\tju@abstract@name@en%
    \end{center}
    \par%
    \begingroup
      \xiaowu[1.4]\zhsong
  }{%
    \endgroup
    \vskip 5mm
    \begingroup
      \noindent
      \wuhao\bf\tju@keywords@name@en:%
    \endgroup
    \begingroup
      \quad\xiaowu\tju@clist@use{\tju@keywords@en}{, \quad}
    \endgroup
    \clearpage
  }
}
\newcommand{\tju@newenv@abstract}{\@nameuse{tju@newenv@abstract@\tju@style}}
\tju@newenv@abstract


% 目录
\newcommand\tju@contents@name@standard{目\hspace*{0.5\ccwd}录}
\newcommand\tju@contents@name@math{目\quad 录}
\newcommand\tju@contents@name{\@nameuse{tju@contents@name@\tju@style}}
\newcommand\tju@format@contents@standard{%
  \renewcommand{\contentsname}{\tju@contents@name}
  \renewcommand{\cftdot}{.}
  \renewcommand{\cftdotsep}{0}
  \renewcommand{\cftsecdotsep}{\cftdotsep}
  \renewcommand{\cftsubsecdotsep}{\cftdotsep}
  \renewcommand{\cftsubsubsecdotsep}{\cftdotsep}
  \setlength{\cftbeforesecskip}{0pt}
  \setlength{\cftbeforesubsecskip}{0pt}
  \setlength{\cftbeforesubsubsecskip}{0pt}
  \renewcommand{\cftsecfont}{\wuhao[1]\zhsong}
  \renewcommand{\cftsubsecfont}{\wuhao[1]\zhsong}
  \renewcommand{\cftsubsubsecfont}{\wuhao[1]\zhsong}
  \renewcommand{\cftsecindent}{0pt}
  \renewcommand{\cftsubsecindent}{1.25\ccwd}
  \renewcommand{\cftsubsubsecindent}{4.5\ccwd}
  \renewcommand{\cftsecnumwidth}{1.25\ccwd}
  \renewcommand{\cftsubsecnumwidth}{2\ccwd}
  \renewcommand{\cftsubsubsecnumwidth}{2.75\ccwd}
  \renewcommand{\cftsecleader}{\hspace*{0.125\ccwd}\cftdotfill{\cftsecdotsep}}
  \renewcommand{\cftsubsecleader}{\hspace*{0.125\ccwd}\cftdotfill{\cftsubsecdotsep}}
  \renewcommand{\cftsubsubsecleader}{\hspace*{0.125\ccwd}\cftdotfill{\cftsubsubsecdotsep}}
  \renewcommand{\cftsecpagefont}{\wuhao[1]\zhsong}
  \renewcommand{\cftsubsecpagefont}{\wuhao[1]\zhsong}
  \renewcommand{\cftsubsubsecpagefont}{\wuhao[1]\zhsong}
  \cftsetpnumwidth{0.5\ccwd}
  \cftsetrmarg{0.75\ccwd}
  \renewcommand{\cftpnumalign}{l}
  \renewcommand{\numberline}[1]{% default
    \hb@xt@\@tempdima{\@cftbsnum ##1\@cftasnum\hfil}\@cftasnumb}
}
\newcommand\tju@format@contents@math{%
  \renewcommand{\contentsname}{\zhhei\tju@contents@name}
  \renewcommand{\cftdot}{$\cdot$}
  \renewcommand{\cftdotsep}{1}
  \renewcommand{\cftsecdotsep}{\cftdotsep}
  \renewcommand{\cftsubsecdotsep}{\cftdotsep}
  \renewcommand{\cftsubsubsecdotsep}{\cftdotsep}
  \setlength{\cftbeforesecskip}{10pt}
  \setlength{\cftbeforesubsecskip}{3pt}
  \setlength{\cftbeforesubsubsecskip}{0pt}
  \renewcommand{\cftsecfont}{\wuhao\zhhei}
  \renewcommand{\cftsubsecfont}{\wuhao\zhhei}
  \renewcommand{\cftsubsubsecfont}{\wuhao\zhhei}
  \renewcommand{\cftsecindent}{0pt}
  \renewcommand{\cftsubsecindent}{1.5em}
  \renewcommand{\cftsubsubsecindent}{3.8em}
  \renewcommand{\cftsecnumwidth}{1.5em}
  \renewcommand{\cftsubsecnumwidth}{2.3em}
  \renewcommand{\cftsubsubsecnumwidth}{3.2em}
  \renewcommand{\cftsecleader}{\cftdotfill{\cftsecdotsep}}
  \renewcommand{\cftsecpagefont}{\wuhao}
  \renewcommand{\cftsubsecpagefont}{\wuhao}
  \renewcommand{\cftsubsubsecpagefont}{\wuhao}
  \cftsetpnumwidth{1.55em}
  \cftsetrmarg{2.55em}
  \renewcommand{\cftpnumalign}{r}
  \renewcommand{\numberline}[1]{%
    \settowidth\@tempdimb{##1\hspace{0.5em}}%
    \ifdim\@tempdima<\@tempdimb%
      \@tempdima=\@tempdimb%
    \fi%
    \hb@xt@\@tempdima{\@cftbsnum ##1\@cftasnum\hfil}\@cftasnumb%
  }
}
\newcommand\tju@format@contents{\@nameuse{tju@format@contents@\tju@style}}
\tju@format@contents
\newcommand\tju@at@pre@toc@standard{%
  \begingroup%
  \ctexset{
    section/afterskip = \dimexpr1.5\tju@line@height@normal+9bp\relax
  }
}
\newcommand\tju@at@post@toc@standard{%
  \endgroup%
}
\newcommand\tju@at@pre@toc@math{}
\newcommand\tju@at@post@toc@math{}
\newcommand\tju@at@pre@toc{\@nameuse{tju@at@pre@toc@\tju@style}}
\newcommand\tju@at@post@toc{\@nameuse{tju@at@post@toc@\tju@style}}
\preto\tableofcontents{\tju@at@pre@toc@standard}
\appto\tableofcontents{\tju@at@post@toc@standard}


% 章节
\newcommand\tju@set@section@format@standard{
  \ctexset{%
    section/format = {\centering\sihao[18bp]\zhhei},
    subsection/format = {\wuhao[18bp]\zhhei},
    subsubsection/format = {\wuhao[18bp]\zhhei},
    subsubsection/nameformat = {\hspace{2\ccwd}},
  }
  %% 设置标题上下间距
  \ctexset{%
    section/beforeskip = 0pt,
    subsection/beforeskip = 0.5\tju@line@height@normal,
    subsubsection/beforeskip = 0.5\tju@line@height@normal,
    section/afterskip = 0.5\tju@line@height@normal,
    subsection/afterskip = 0.5\tju@line@height@normal,
    subsubsection/afterskip = 0.5\tju@line@height@normal,
  }
  \ctexset{%
    section/aftertitle = {},
    subsection/aftertitle = {},
    subsubsection/aftertitle = {},
  }
  \ctexset{%
    section/aftername = \hspace*{1\ccwd},
    subsection/aftername = \hspace*{0.5\ccwd},
    subsubsection/aftername = \hspace*{0.5\ccwd},
  }
}
\newcommand\tju@set@section@format@math{
  \ctexset{%
    section/format = {\Large\bfseries\centering },
    subsection/format = {\bfseries\wuhao},
    subsubsection/format = {\normalsize\bfseries},
    subsubsection/nameformat = {\hspace{2\ccwd}},
  }
  %% 设置标题上下间距
  \ctexset{%
    section/beforeskip = 3.5ex plus 1ex minus .2ex,
    subsection/beforeskip = 3.25ex plus 1ex minus .2ex,
    subsubsection/beforeskip = 3.25ex plus 1ex minus .2ex,
    section/afterskip = 2.3ex plus .2ex,
    subsection/afterskip = 1.5ex plus .2ex,
    subsubsection/afterskip = 1.5ex plus .2ex,
  }
  \ctexset{%
    section/aftertitle = \@@par,
    subsection/aftertitle = \@@par,
    subsubsection/aftertitle = \@@par,
  }
  \ctexset{%
    section/aftername = \quad,
    subsection/aftername = \quad,
    subsubsection/aftername = \quad,
  }
}
\newcommand\tju@set@section@format{\@nameuse{tju@set@section@format@\tju@style}}
\tju@set@section@format
\newcommand\tju@at@pre@section@standard{%
  \cleardoublepage% 每一个section都会从新的一页开始
  \vspace*{\dimexpr-\baselineskip+1.5\tju@line@height@normal\relax}%
}
\newcommand\tju@at@pre@section@math{%
  \cleardoublepage% 每一个section都会从新的一页开始
}
\newcommand\tju@at@pre@section{\@nameuse{tju@at@pre@section@\tju@style}}
\preto\section{\tju@at@pre@section}


% 分项
\setlist*{nosep}
\setlist*[enumerate,1]{label = (\arabic*)}
\setlist*[enumerate,2]{label = \arabic*)}


% 脚注
%% 脚注跨页怎么办 https://tex.stackexchange.com/a/32210
% \RequirePackage[splitrule]{footmisc} % 如果跨页的话在第二页的脚注前加一条长线作为提示 但是我们下面对脚注的格式定制就无了
% \interfootnotelinepenalty=\@M % 拒绝跨页, 但是会在第二页的开头留下奇怪的空白
%% 设置编号为圆圈内数字
\RequirePackage{tikz}
\newcommand*\circled[1]{\tikz[baseline=(char.base)]{
  \node[shape=circle,draw,inner sep=0pt] (char) {#1};}}
\def\@makefnmark@circled@nosuper{\hbox{\normalfont\circled{\@thefnmark}\space}}
\def\@makefnmark@circled@super{\hbox{\@textsuperscript{\normalfont\circled{\@thefnmark}}}}
\AtBeginDocument{% should be done after loading hyperref
  \patchcmd\@footnotemark{\@makefnmark}{\@makefnmark@circled@super}{}{}
  \patchcmd\@makefntext{\@makefnmark}{\@makefnmark@circled@nosuper}{}{}% 需要etoolbox宏包来给局部打补丁
}
% 如果想要每页重置脚注编号, 可以参考https://tex.stackexchange.com/questions/1656/footnote-counter-would-like-to-restart-from-1-each-page


% 图表代码算法之类的环境
\RequirePackage{caption}% 来配置caption格式
% \xapptocmd{\caption}{\nopagebreak}{}{} % \nopagebreak failed! FXXK!!!!
\newcommand\tju@caption@font{\xiaowu[18bp]\selectfont}% 小五 18磅行距
\DeclareCaptionFont{tju}{\tju@caption@font}
\DeclareCaptionLabelSeparator{tju}{\hspace*{0.5\ccwd}}
\captionsetup{%
  font = tju,%
  labelsep = tju,%
  skip = 0pt,%
}
\captionsetup[sub]{%
  font = tju,%
  labelsep = tju,%
  skip = 0pt,%
}
\RequirePackage{chngcntr}% 设置counter within

%% 插图
\captionsetup[figure]{%
  position = below,%
}
\counterwithin{figure}{section}

%% 表格
\captionsetup[table]{%
  position = above,%
}
\counterwithin{table}{section}
\AtBeginEnvironment{tabular*}{\xiaowu[18bp]}
\AtBeginEnvironment{tabularx}{\xiaowu[18bp]}
\AtEndOfPackageFile*{pgfplots}{%
  \pgfplotsset{compat=1.18}
}
\AtEndOfPackageFile*{pgfplotstable}{%
  \pgfplotstableset{
    empty header/.style={
      every head row/.style={output empty row},
    }
  }
  \newcommand\typesetlongtable[4][]{%
    \def\tju@lowlevel@colname{\@gobble}
    \pgfplotstableread[col sep = comma]{#4}{\tju@loaded@table}
    \pgfplotstablegetcolsof{\tju@loaded@table}
    \let\tju@table@cols\pgfplotsretval
    % https://tex.stackexchange.com/a/357580
    \pgfplotstableforeachcolumn\tju@loaded@table\as\tju@col@temp{%
      \expandafter\g@addto@macro\expandafter\tju@lowlevel@colname\expandafter{\expandafter&\tju@col@temp}
    }
    \g@addto@macro\tju@lowlevel@colname{\\}
    % https://tex.stackexchange.com/a/246001
    \setlength\LTleft{0pt plus \textwidth}
    \setlength\LTright{0pt plus \textwidth}
    % https://tex.stackexchange.com/a/309823
    \pgfplotstabletypeset[
      begin table = \begin{longtable},
      begin table/.add = {\xiaowu[18bp]}{},
      every head row/.append style = {%
        before row = {%
          \caption{#2}\label{#3}\\%
          \toprule%
          %
        },
        after row = {%
          \midrule%
          \endfirsthead%
          % https://tex.stackexchange.com/a/276468
          \multicolumn{\tju@table@cols}{r}{{续表 \thetable}}\\% 当心太长了把列宽拉长
          \toprule
          \tju@lowlevel@colname%
          \midrule
          \endhead
          \bottomrule
          \endfoot
        },
      },
      column type = c,
      every first column/.style = {%
        column type/.add = {}{@{\extracolsep{\fill}}}
      },
      % every last column/.style = {%
      %   column type/.add = {}{}
      % },
      end table = \end{longtable},
      #1%
    ]{\tju@loaded@table}
  }
}

%% 代码
% https://tex.stackexchange.com/a/53540
\RequirePackage{tcolorbox}
\tcbuselibrary{breakable}
\tcbset{%
  before skip balanced = 0pt,%
  after skip balanced = \tju@line@height@normal,%
  height fixed for = first and middle,
  colback = white,%
  arc = 0mm,%
  boxsep = 0mm,%
  toprule = 0.4pt,%
  bottomrule = 0.4pt,%
  leftrule = 0.4pt,%
  rightrule = 0.4pt,%
  top = \fboxsep,%
  bottom = \fboxsep,%
  % left = \dimexpr12pt\relax,% set lineno position
  left = 0pt,%
}
\PassOptionsToPackage{newfloat}{minted}
\AtEndOfPackageFile*{minted}{%
  \tcbuselibrary{minted}
  \captionsetup[listing]{%
    name = {代码},%
    position = above,%
  }
  \counterwithin{listing}{section}
  \newtcbinputlisting{tcbinputminted}[3][]{%
    breakable,%
    listing only,%
    listing file = {#3},%
    minted language = #2,%
    minted options = {%
      breaklines = true,%
      breakanywhere = true,%
      fontsize = \xiaowu,%
      frame = none,%
      xleftmargin = 0em,%
      xrightmargin = 0em,%
      python3 = true,%
      #1%
    }
  }
  \newtcblisting{tcbminted}[2][]{%
    breakable,%
    listing only,%
    minted language = #2,%
    minted options = {%
      breaklines = true,%
      breakanywhere = true,%
      fontsize = \xiaowu,%
      frame = none,%
      xleftmargin = 0em,%
      xrightmargin = 0em,%
      python3 = true,%
      #1%
    }
}
  \renewenvironment{listing}{%
    \vskip \dimexpr\tju@line@height@normal+9bp\relax
    \captionsetup{type=listing}%
  }{}
  \newenvironment{longlisting}{%
    \begin{listing}
  }{\end{listing}}
}

%% 算法
\AtBeginOfPackageFile*{algorithm}{
  \tju@error{Please don't load package "algorithm" since we are creating the float on our own.}
}
\DeclareFloatingEnvironment{algorithm}{}
\captionsetup[algorithm]{%
  name = {算法},%
  position = above,%
}
\counterwithin{algorithm}{section}
\AtEndOfPackageFile*{algorithmicx}{%
  \BeforeBeginEnvironment{algorithmic}{\begin{tcolorbox}[after skip balanced = 0pt]\xiaowu[18bp]}
  \AfterEndEnvironment{algorithmic}{\end{tcolorbox}}
}

% 附录
\appto\appendix{\clearpage}
\newif\iftju@appendix
\tju@appendixfalse
\appto\appendix{\tju@appendixtrue}
\appto\backmatter{\tju@appendixfalse}


% 文献著录
% TODO: 将来应该弄到bbx和cbx文件中
% \newcommand\tju@pass@option@biblatex@math{%
%   \PassOptionsToPackage{gbnamefmt=lowercase}{biblatex}
% }
% \newcommand\tju@pass@option@biblatex@standard{%
%   \PassOptionsToPackage{gbnamefmt=uppercase}{biblatex}
% }
% \newcommand{\tju@pass@option@biblatex}{%
%   \@nameuse{tju@pass@option@biblatex@\tju@style}
% }
% \tju@pass@option@biblatex
\usepackage[%
  backend=biber,%
  style=gb7714-2015,gbpub=false,gbnamefmt=lowercase,%
  sortcites=true,doi=false,%
  defernumbers=true,%
  ]{biblatex} % 需要 biblatex-gb7714-2015
\bibliography{ref/refs}
\AtEveryBibitem{\clearfield{pagetotal}}

%% 引用
\let\upcite\relax
\DeclareCiteCommand{\upcite}[\mkbibsuperscript]%利用mkbibsuperbracket添加方括号 \textsuperscript
  {[\usebibmacro{cite:init}%]
   \usebibmacro{prenote}}
  {\usebibmacro{citeindex}%
   \usebibmacro{cite:comp}}
  {}
  {%[
  \usebibmacro{cite:dump}]%
   \printfield{postnote}}%\kern\p@ \kern\z@
\let\cite\parencite

%% 参考文献表
\newcommand\tju@bibliography{%
  \begingroup%
  \tju@set@line@spread%
  \sloppy\hbadness 10000\relax%
  \printbibliography[heading=bibintoc, category=inbib]%
  \fussy%
  \endgroup%
}
\newcommand\tjubibliography{\tju@bibliography}

% \xpretocmd\printbibliography{\begingroup\linespread{1.3}\sloppy}{}{}
% \xapptocmd\printbibliography{\fussy\endgroup}{}{}
\newcommand\tju@def@bibenv@standard{%
  \ExecuteBibliographyOptions{gbalign=left}
  \renewcommand{\bibfont}{\wuhao[18bp]}
  \setlength{\bibitemsep}{0pt} % 1.3*1.2-1.2
  % \setlength{\bibitemsep}{\baselineskip}
  % \addtolength{\bibitemsep}{-\ht\strutbox}
  \setlength{\bibitemindent}{0em} % bibitemindent表示一条文献中第一行相对后面各行的缩进
  \setlength{\bibhang}{0pt} % 著者-出版年制中bibhang 表示的各行起始位置到页边的距离
  \setlength{\biblabelsep}{0.25\ccwd} % 调整顺序标签与文献内容的间距
  % 调整各条文献的缩进：
  %-1-----gbalign=left、right、center时，重定义bibenvironment
  \defbibenvironment{bibliography}%修改对齐环境-调整缩进
  {%
    \list{%
      \printtext[labelnumberwidth]{%
      \printfield{labelprefix}%
      \printfield{labelnumber}}}
    {%
      %这里是所做的调整，通过设置\bibitemindent，\bibhang调整缩进
      \addtolength{\bibitemindent}{\labelnumberwidth}%
      \addtolength{\bibitemindent}{\biblabelsep}%
      \addtolength{\bibhang}{-\labelnumberwidth}%
      \addtolength{\bibhang}{-\biblabelsep}%
      %
      %以下是默认的设置
      \setlength{\labelwidth}{\labelnumberwidth}%
      \setlength{\labelsep}{\biblabelsep}%
      \setlength{\leftmargin}{\bibhang}%
      \addtolength{\leftmargin}{\labelnumberwidth}%
      \setlength{\itemindent}{\bibitemindent}%
      \setlength{\itemsep}{\bibitemsep}%
      \setlength{\parsep}{\bibparsep}}%
      \renewcommand*{\makelabel}[1]{\hss####1}}{%
    \endlist}{%
    \item%
  }
}
\newcommand\tju@def@bibenv@math{%
  \ExecuteBibliographyOptions{gbalign=right}
  \renewcommand{\bibfont}{\xiaowu}
  \setlength{\bibitemsep}{0.36ex} % 1.3*1.2-1.2
  % \setlength{\bibitemsep}{\baselineskip}
  % \addtolength{\bibitemsep}{-\ht\strutbox}
  \setlength{\bibitemindent}{0em} % bibitemindent表示一条文献中第一行相对后面各行的缩进
  \setlength{\bibhang}{3\ccwd} % 著者-出版年制中bibhang 表示的各行起始位置到页边的距离
  \setlength{\biblabelsep}{2mm} % 调整顺序标签与文献内容的间距% 调整各条文献的缩进：
  %-1-----gbalign=left、right、center时，重定义bibenvironment
  \defbibenvironment{bibliography}%修改对齐环境-调整缩进
  {%
    \list{%
      \printtext[labelnumberwidth]{%
      \printfield{labelprefix}%
      \printfield{labelnumber}}}
    {%
      %这里是所做的调整，通过设置\bibitemindent，\bibhang调整缩进
      % \addtolength{\bibitemindent}{\labelnumberwidth}%
      % \addtolength{\bibitemindent}{\biblabelsep}%
      \addtolength{\bibhang}{-\labelnumberwidth}%
      \addtolength{\bibhang}{-\biblabelsep}%
      %
      %以下是默认的设置
      \setlength{\labelwidth}{\labelnumberwidth}%
      \setlength{\labelsep}{\biblabelsep}%
      \setlength{\leftmargin}{\bibhang}%
      \addtolength{\leftmargin}{\labelnumberwidth}%
      \setlength{\itemindent}{\bibitemindent}%
      \setlength{\itemsep}{\bibitemsep}%
      \setlength{\parsep}{\bibparsep}}%
      \renewcommand*{\makelabel}[1]{\hss####1}}{%
    \endlist}{%
    \item%
  }
}
\newcommand\tju@def@bibenv{\@nameuse{tju@def@bibenv@\tju@style}}
\tju@def@bibenv
\tju@option@hook{style}{\tju@def@bibenv}

%% 只被footfullcite的文献不配进参考文献表
%% https://tex.stackexchange.com/a/420605
\DeclareBibliographyCategory{inbib}
\AtEveryCitekey{%
  \ifcsstring{blx@delimcontext}{footfullcite}
    {}{\addtocategory{inbib}{\thefield{entrykey}}}%
    % {%
    %   \ifcsstring{blx@delimcontext}{footfullcite}
    %     {}{\addtocategory{inbib}{\thefield{entrykey}}}
    % }
}

%% 设置 incollection 和 collection 的文献类型标识
%%% 在驱动别名处理, 再处理文献类型标识.
\DeclareBibliographyAlias{inreference}{incollection}
\DeclareBibliographyAlias{reference}{collection}
\DeclareSourcemap{
  \maps[datatype=bibtex]{%
    \map{
      \pertype{inreference}
      \step[fieldset=usera, fieldvalue={G}]
      \step[fieldsource=institution]%有时会把publisher和institution混淆，处理后使用publisher
      \step[fieldset=publisher, origfieldval]
    }
    \map{
      \pertype{reference}
      \step[fieldset=usera, fieldvalue={G}]
      \step[fieldsource=institution]%有时会把publisher和institution混淆，处理后使用publisher
      \step[fieldset=publisher, origfieldval]
    }
  }
}
\DeclareFieldFormat[inreference]{title}{#1}%\nopunct\unspace%将期刊等文献的标题中原来带的引号去掉

%% GB/T 7714-2015 风格, 全部大写 这段代码修复只有姓或者名的人名字不全大写的bug
\renewbibmacro*{name:gbuppercase}[4]{\bibauthorfont%
\renewrobustcmd*{\bibinitperiod}{}%将名字简写后的点去掉
\renewcommand*{\revsdnamepunct}{}%
  \ifuseprefix%
    {\usebibmacro{name:delim}{#3#1}%
     \usebibmacro{name:hook}{#3#1}%
     \ifdefvoid{#3}{}{%
       \ifcapital%
         {\mkbibnameprefix{\MakeCapital{#3}}\isdot}%
         {\mkbibnameprefix{#3}\isdot}%
       \ifprefchar{}{\bibnamedelimc}}%
     \ifdefvoid{#2}{\mkbibnamefamily{\MakeUppercase{#1}}}{\mkbibnamefamily{\MakeUppercase{#1}}}\isdot%
     \ifdefvoid{#2}{}{\revsdnamepunct\bibnamedelimd\mkbibnamegiven{\MakeUppercase{#2}}\isdot}%\MakeCapital
     \ifdefvoid{#4}{}{\addcomma\bibnamedelimd\mkbibnamesuffix{#4}\isdot}}%后缀前加逗号
    {\usebibmacro{name:delim}{#1}%
     \usebibmacro{name:hook}{#1}%
     \ifdefvoid{#2}{\mkbibnamefamily{\MakeUppercase{#1}}}{\mkbibnamefamily{\MakeUppercase{#1}}}\isdot%
     \ifboolexpe{%
       test {\ifdefvoid{#2}}
       and
       test {\ifdefvoid{#3}}}
       {}{\revsdnamepunct}%
     \ifdefvoid{#2}{}{\bibnamedelimd\mkbibnamegiven{\MakeUppercase{#2}}\isdot}%\MakeCapital
     \ifdefvoid{#3}{}{\bibnamedelimd\mkbibnameprefix{#3}\isdot}%
     \ifdefvoid{#4}{}{\addcomma\bibnamedelimd\mkbibnamesuffix{#4}\isdot}}%%后缀前加逗号
}

%% 如果是旧版biblatex-gb7714-2015 那么添上处理翻译为外文文献的处理代码
\def\tju@parse@gbt@date#1 #2{#1}
\def\dateofgbtstyle{\expandafter\tju@parse@gbt@date\versionofgbtstyle}
\ifnum\pdfstrcmp{\dateofgbtstyle}{2021/04/03}<0%
  \DefineBibliographyStrings{english}{
      bytranslator= {Trans. by},
      }

  \renewbibmacro*{name:andothers}{\bibauthorfont%
    \ifboolexpr{
      test {\ifnumequal{\value{listcount}}{\value{liststop}}}
      and
      test \ifmorenames
    }{\ifnumgreater{\value{liststop}}{1}%
        {\finalandcomma}%
        {}%
  \printdelim{andothersdelim}\printdelim{strandothersdelim}%
  }{%当是译者的时候需要特殊处理：从7.2节看等，译前面加逗号，但从示例看等和译同时出现时，译前的逗号没有，比如：
  %袁训来, 陈哲, 肖书海, 等.
  %胡泳, 范海燕, 译.
  %潘惠霞, 魏婧, 杨艳, 等译.
  \ifcurrentname{translator}{\iffieldequalstr{usere}{chinese}{\addcomma\addthinspace}{}}{}%为了实现上述第二个示例情况做的处理
  }}

  \renewbibmacro*{bytranslator+others}{\bibauthorfont%
    \ifnameundef{translator}
      {}
      {\iffieldequalstr{usere}{chinese}{}{\usebibmacro{bytranslator+othersstrg}}
      %\setunit{\addspace}%
      \printnames[bytranslator]{translator}%
      \clearname{translator}%
      %从macro*{bytranslator+othersstrg}%中可以看到当地化字符串格式的引用前的代码处理
      %比如生成cotranslator等用于调用cotranslator所代表的当地化字符串
      \iffieldequalstr{usere}{chinese}{\usebibmacro{bytranslator+othersstrg}}{}%“译”的位置换到下面来，即放到译者后面。
      %\setunit{\addspace}%
      \newunit}%
    \usebibmacro{withothers}}


  \renewbibmacro*{bytranslator+othersstrg}{%
    \def\abx@tempa{bytranslator}%
    \ifnamesequal{translator}{commentator}
      {\appto\abx@tempa{co}%
      \clearname{commentator}}
      {\ifnamesequal{translator}{annotator}
        {\appto\abx@tempa{an}%
          \clearname{annotator}}
        {}}%
    \ifnamesequal{translator}{introduction}
      {\appto\abx@tempa{in}%
      \clearname{introduction}}
      {\ifnamesequal{translator}{foreword}
        {\appto\abx@tempa{fo}%
          \clearname{foreword}}
        {\ifnamesequal{translator}{afterword}
            {\appto\abx@tempa{af}%
            \clearname{afterword}}
            {}}}%
  \iffieldequalstr{usere}{chinese}{\printtext{译}}
    {\bibstring{\abx@tempa}}}
\fi


% 谢辞
\newcommand\tju@acknowledgements@name@standard{谢\hspace*{0.5\ccwd}辞}
\newcommand\tju@acknowledgements@name@math{谢\quad 辞}
\newcommand\tju@acknowledgements@name{\@nameuse{tju@acknowledgements@name@\tju@style}}
\newenvironment{acknowledgements}{%
  \section*{\tju@acknowledgements@name}
  \addcontentsline{toc}{section}{\tju@acknowledgements@name}
}{}


\endinput
