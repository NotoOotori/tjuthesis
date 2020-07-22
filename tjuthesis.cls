% !Mode::"TeX:UTF-8"
% Options: chinese

% -------------------- Identification --------------------

\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\ProvidesClass{tjuthesis}[2020/06/19 0.0.0 Tongji University Thesis Template]

% -------------------- Preliminary Declarations --------------------


\newcommand\tju@error[1]{%
  \ClassError{tjuthesis}{#1}{}%
}
\newcommand\tju@warning[1]{%
  \ClassWarning{tjuthesis}{#1}%
}
\@ifl@t@r\fmtversion{2017/04/15}{}{
  \tju@error{%
    TeX Live 2017 or later version is required to compile this document%
  }
}


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
}
%% 文档信息
\tju@define@key{
  title = {
    default = {标题},
  },
  subtitle,
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
    default = {},
  },
}
%% 字体选项
\tju@define@key{
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
}


% -------------------- Handle Options --------------------

\newcommand{\tju@abstract@name}{摘~要}

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{\DocumentClass}}
\ProcessKeyvalOptions*

% -------------------- More Declarations --------------------

% 不显示Warning (Times字体没有MathScript Style)
\PassOptionsToPackage{quiet}{fontspec}


\LoadClass[a4paper, zihao=5, fontset=none]{ctexart}


% 引用必要宏包
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\RequirePackage{geometry}
\RequirePackage{fancyhdr}
\RequirePackage{titletoc}
\RequirePackage{notoccite}
\RequirePackage{amsmath}
% unicode-math should be loaded after any other packages that mess
%   with the math functionality.
\RequirePackage{unicode-math}
\RequirePackage{graphicx}
\RequirePackage[labelformat=simple]{subcaption}
\RequirePackage{pdfpages}
\includepdfset{fitpaper=true}
\RequirePackage[shortlabels]{enumitem}
\RequirePackage{environ}
\RequirePackage{xeCJKfntef}
\RequirePackage{array}
\RequirePackage{booktabs}
\RequirePackage{url}
\RequirePackage{filehook}
\newcommand\tju@package@conflict[2]{
  \AtBeginOfPackageFile*{#2}{
    \tju@error{The "#2" package is incompatible with required "#1"}
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


% 字号
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
\newif\if@mainmatter
\newcommand\frontmatter{%
  \cleardoublepage
  \@mainmatterfalse
  \pagenumbering{roman}}

\newcommand\mainmatter{%
  \cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}
}

\newcommand\backmatter{%
  \clearpage
  \@mainmatterfalse
}


% 英文字体
\setmainfont{Times New Roman}%

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
\unimathsetup{
  math-style = ISO,
  bold-style = ISO,
  nabla      = upright,
  partial    = upright,
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
    StylisticSet = 1,
    range = {cal, bfcal},
  ]
  \setmathfont{Times}[
    Extension = .ttf,
    range = \mathup/{num},
    Script = Arabic,
  ]
  \setmathfont{\tju@font@name@xits@math@rm}[
    Extension = .otf,
    range = \mathit/{greek,Greek,latin,Latin},
  ]
  \setmathfont{\tju@font@name@xits@math@rm}[
    Extension = .otf,
    range = \mathup/{greek,Greek,latin,Latin},
  ]
  \setmathfont{\tju@font@name@xits@math@rm}[
    Extension = .otf,
    range = {
      "2212,"002B,"003D,"0028,"0029,"005B,%
      "005D,"221A,"2211,"2248,"222B,"007C,"2026,"2202,"00D7,"0302,%
      "2261,"0025,"22C5,"00B1,"2194,"21D4%
    },
  ]
}
\newcommand\tju@load@math@font{%
  \@nameuse{tju@load@math@font@\tju@math@font}
}
\tju@load@math@font
\tju@option@hook{math-font}{\tju@load@math@font}

\newcommand\tju@load@cjk@font@windows{%
  \xeCJKsetup{EmboldenFactor=2}
  \setCJKmainfont{SimSun}[
    AutoFakeBold = true,
    ItalicFont   = KaiTi,
  ]%
  \setCJKsansfont{SimHei}[AutoFakeBold]%
  \setCJKmonofont{FangSong}%
  \newCJKfontfamily\zhsong{SimSun}[AutoFakeBold]%
  \newCJKfontfamily\zhhei{SimHei}[AutoFakeBold]%
  \newCJKfontfamily\zhkai{KaiTi}%
  \newCJKfontfamily\zhfs{FangSong}%
}
\newcommand\tju@load@cjk@font{%
  \@nameuse{tju@load@cjk@font@\tju@cjk@font}%
}
\tju@load@cjk@font
\tju@option@hook{cjk-font}{\tju@load@cjk@font}


% 页面尺寸
\geometry{
  top = 30mm,
  bottom = 60mm,
  left = 45mm,
  right = 30mm,
}


% 装订线
\RequirePackage{fancybox}
\XeTeXcharclass`┊=1
\fancyput(-0.75cm,-12cm){\parbox{1em}{\wuhao\baselineskip 12pt ┊┊┊┊┊┊┊┊┊┊┊┊┊装┊┊┊┊┊订┊┊┊┊┊线┊┊┊┊┊┊┊┊┊┊┊┊┊}}


% 页眉页脚
\pagestyle{fancy}
\fancypagestyle{plain}{%
  \fancyhf{}%
  \setlength{\headheight}{40pt}
  \fancyhead[L]{\quad\includegraphics[width=4.5cm]{tongji-name-bacholar.pdf}}
  \fancyhead[R]{\raisebox{2.5ex}{\zihao{4}{毕业设计（论文）}}}
  \renewcommand{\headrulewidth}{1pt}
  \setlength{\headsep}{30pt}
  \setlength{\footskip}{20pt}
  \renewcommand{\footrulewidth}{0pt}
  \fancyfoot[C]{\xiaosi\thepage}
}
\pagestyle{plain}


% 标题页
\renewcommand{\maketitle}{%
  \clearpage
  \tju@titlepage
  \clearpage
}
\newcommand\tju@titlepage{%
  \thispagestyle{empty}
  \vspace*{\fill}
  \begin{center}
    \includegraphics[height=2.25cm]{tongji-name-bacholar.pdf}
    \par
    {\xiaoer\MakeUppercase{\textbf{Tongji University}}}
    \vskip 30pt
    {\yihao{\textbf{毕业设计（论文）}}}
    \vskip 80pt
    \tju@titlepage@info
  \end{center}
  \vspace*{\fill}
}

%% 信息表
\newcommand\tju@titlepage@info{%
  \tju@titlepage@info@tabular{4em}{4em}{0.82cm}{18em}{%
    \tju@info@item{课题名称}{}{\tju@title}
    \tju@info@item{副标题}{}{\tju@subtitle}
    \tju@info@item{学院}{}{\tju@department}
    \tju@info@item{专业}{}{\tju@discipline}
    \tju@info@item{学生姓名}{}{\tju@author}
    \tju@info@item{学号}{}{\tju@id}
    \tju@info@item{指导教师}{\tju@name@title}{\tju@supervisor}
    \tju@info@item{日期}{}{\tju@date}
  }
}
\newcommand\tju@titlepage@info@tabular[5]{%
  \def\tju@info@item##1##2##3{%
    \ifx##3\@empty\else
      \tju@pad{#1}{\tju@fixed@box{#2}{##1}}%
      \tju@pad{#3}{}%
      \underline{\tju@par{#4}{##2{##3}}}\\
    \fi
  }%
  \begingroup
    \xiaosan
    \renewcommand{\arraystretch}{1.5}
    \begin{tabular}{l}%
      #5%
    \end{tabular}%
  \endgroup
}
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
  \tju@pad{4em}{\tju@par{4em}{#1}}%
  \tju@par{3em}{#2}%
}
\newcommand\tju@name@title[1]{%
  \setcounter{tju@csl@count}{0}%
  \gdef\tju@@name{}%
  \gdef\tju@@title{}%
  \expandafter\comma@parse\expandafter{#1}{\tju@name@title@process}%
  \tju@name@title@format{\tju@@name}{\tju@@title}%
}


% 摘要
\renewenvironment{abstract}{%
  \clearpage
  \vskip 6pt
  \begingroup
    \xiaoer\centering\zhhei\bf\tju@title\par
  \endgroup
  \vskip 18pt
  \begingroup
    \sihao\centering\zhhei\tju@abstract@name\par
  \endgroup
  \vskip 9pt
}{%
  \clearpage
}


% 文献著录
\usepackage[%
  backend=biber,style=gb7714-2015,gbalign=gb7714-2015,gbpub=false
  ]{biblatex} % 需要 biblatex-gb7714-2015 宏包
\bibliography{ref/refs}


\endinput
