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
  title* = {
    default = {Title},
    name = title@en,
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

\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{\DocumentClass}}
\ProcessKeyvalOptions*

% -------------------- More Declarations --------------------

% 不显示Warning (Times字体没有MathScript Style)
\PassOptionsToPackage{quiet}{fontspec}


\LoadClass[a4paper, zihao=5, fontset=none]{ctexart}


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
\RequirePackage[labelformat=simple]{subcaption}
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
  \pagenumbering{arabic}}

\newcommand\mainmatter{%
  \cleardoublepage
  \@mainmattertrue
}

\newcommand\backmatter{%
  \clearpage
  \@mainmatterfalse
}


% 英文字体 % TODO: Load fonts explicitly
\setmainfont{cmunrm.ttf}[%
  BoldFont = cmunbx.ttf,
  ItalicFont = cmunti.ttf,
]


\mathchardef\ordinarycolon\mathcode`\:
\mathcode`\:=\string"8000
\begingroup \catcode`\:=\active
  \gdef:{\mathrel{\mathop\ordinarycolon}}
\endgroup
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
    BoldFont = \tju@font@name@xits@math@bf,
    StylisticSet = 1,
    range = {cal, bfcal},
  ]
  \setmathfont{cmunrm.ttf}[
    range = up/{num},
    BoldFont = cmunbx.ttf,
  ]
  \setmathfont{cmunbx.ttf}[
    range = bfup/{num},
    BoldFont = cmunbx.ttf,
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
  \setCJKmonofont{FangSong}[AutoFakeBold]%
  \newCJKfontfamily\zhsong{SimSun}[AutoFakeBold]%
  \newCJKfontfamily\zhhei{SimHei}[AutoFakeBold]%
  \newCJKfontfamily\zhkai{KaiTi}[AutoFakeBold]%
  \newCJKfontfamily\zhfs{FangSong}[AutoFakeBold]%
}
\newcommand\tju@load@cjk@font{%
  \@nameuse{tju@load@cjk@font@\tju@cjk@font}%
}
\tju@load@cjk@font
\tju@option@hook{cjk-font}{\tju@load@cjk@font}


% 页面尺寸
\geometry{
  top = 32mm,
  bottom = 38mm,
  left = 33mm,
  right = 18mm,
}


% 装订线
\RequirePackage{fancybox}
% \XeTeXcharclass`┊=1
% \fancyput(-0.75cm,-12cm){\parbox{1em}{\wuhao\baselineskip 12pt ┊┊┊┊┊┊┊┊┊┊┊┊┊装┊┊┊┊┊订┊┊┊┊┊线┊┊┊┊┊┊┊┊┊┊┊┊┊}}
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


% 行距
\linespread{1.5}


% 页眉页脚
\pagestyle{fancy}
\fancypagestyle{plain}{%
  \fancyhf{}%
  \setlength{\headheight}{42.82419pt}% TODO: check this
  \fancyhead[L]{\qquad \includegraphics[height=1.34cm]{tongji-name-bacholar.jpg}}
  \fancyhead[R]{\xiaosi 毕业设计（论文）~\\}
  \renewcommand{\headrulewidth}{1.5pt}
  \renewcommand{\footrulewidth}{1.5pt}
  \fancyfoot[RO]{\xiaosi 共\quad \pageref{LastPage}\quad 页\quad 第\quad \thepage \quad 页} % LE,RO if twoside
}
\pagestyle{plain}


% 章节标题
\ctexset{
  subsubsection/nameformat = {\hspace{2em}},
}


% hyperref 宏包在最后调用
\AtEndPreamble{
  \RequirePackage{hyperref}
  \RequirePackage{bookmark}

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
    bookmarksopen=true,
    bookmarksopenlevel=2,
    bookmarksnumbered=true,% 将章节编号放入书签中
  }
  \hypersetup{% PDF默认打开视图
    pdfstartview=FitH,
    pdfpagelayout=OneColumn,
  }
}
\AtEndDocument{
  \hypersetup{% PDF信息
    pdftitle={\tjutitle},
    pdfauthor={\tjuauthor},
  }
}

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
\def\nosuper@makefnmark{\hbox{\normalfont\circled{\@thefnmark}\space}}
\patchcmd\@makefntext{\@makefnmark}{\nosuper@makefnmark}{}{}% 需要etoolbox宏包来给局部打补丁
% 如果想要每页重置脚注编号, 可以参考https://tex.stackexchange.com/questions/1656/footnote-counter-would-like-to-restart-from-1-each-page


% 标题页
\newcommand{\tjutitle}{\tju@title}
\newcommand{\tjuauthor}{\tju@author}
\newcommand{\tjutitlepage}{%
  \clearpage
  \tju@titlepage
  \clearpage
}
\newcommand\tju@titlepage{%
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
\newcommand{\tju@abstract@name}{摘\quad 要}
\newcommand{\tju@keywords@name}{关键词}
\newcommand{\tju@abstract@name@en}{ABSTRACT}
\newcommand{\tju@keywords@name@en}{Key words}
\renewenvironment{abstract}[1]{%
  \tjusetup{
    keywords = {#1}
  }
  \clearpage
  \null\vskip -1em
  \begingroup
    \erhao\centering\zhhei\tju@title\par%
  \endgroup
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
}
\newenvironment{abstract*}[1]{
  \tjusetup{
    keywords* = {#1},
  }
  \clearpage
  \begin{center}
    \erhao\bf\tju@title@en%
  \end{center}
  \begin{center}
    \sihao\bf\tju@abstract@name@en%
  \end{center}
  \par%
  \begingroup
    \xiaowu\zhsong
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


% 目录
\newcommand{\tju@contents@name}{目\quad 录}
\renewcommand{\contentsname}{\tju@contents@name}
\renewcommand{\cftdot}{$\cdot$}
\renewcommand{\cftdotsep}{1}
\setlength{\cftbeforesecskip}{10pt}
\setlength{\cftbeforesubsecskip}{3pt}
\setlength{\cftbeforesubsubsecskip}{0pt}
\renewcommand{\cftsecfont}{\wuhao\zhhei}
\renewcommand{\cftsubsecfont}{\wuhao\zhhei}
\renewcommand{\cftsubsubsecfont}{\wuhao\zhhei}
\renewcommand{\cftsecleader}{\cftdotfill{\cftsecdotsep}}
\renewcommand{\cftsecdotsep}{\cftdotsep}
\renewcommand{\cftsecpagefont}{\wuhao}
\renewcommand{\cftsubsecpagefont}{\wuhao}
\renewcommand{\cftsubsubsecpagefont}{\wuhao}
\renewcommand{\numberline}[1]{%
  \settowidth\@tempdimb{#1\hspace{0.5em}}%
  \ifdim\@tempdima<\@tempdimb%
    \@tempdima=\@tempdimb%
  \fi%
  \hb@xt@\@tempdima{\@cftbsnum #1\@cftasnum\hfil}\@cftasnumb%
}


% 附录

\appto\appendix{\clearpage}


% 文献著录
\usepackage[%
  backend=biber,style=gb7714-2015,gbalign=right,gbpub=false,sortcites=true,doi=false,%
  defernumbers=true,%
  ]{biblatex} % 需要 biblatex-gb7714-2015 宏包
\bibliography{ref/refs}
\newcommand\tjubibliography{\tju@bibliography}
\newcommand\tju@bibliography{%
  \begingroup%
  \linespread{1.3}%
  \sloppy\hbadness 10000\relax%
  \printbibliography[heading=bibintoc, category=inbib]%
  \fussy%
  \endgroup%
}
\AtEveryBibitem{\clearfield{pagetotal}}

% https://tex.stackexchange.com/a/420605
\DeclareBibliographyCategory{inbib}
\AtEveryCitekey{%
  \ifcsstring{blx@delimcontext}{footfullcite}
    {}{\addtocategory{inbib}{\thefield{entrykey}}}%
    % {%
    %   \ifcsstring{blx@delimcontext}{footfullcite}
    %     {}{\addtocategory{inbib}{\thefield{entrykey}}}
    % }
}

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

%GB/T 7714-2015 风格，全部大写
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

% 如果是旧版biblatex-gb7714-2015 那么添上处理翻译为外文文献的处理代码
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


  \newbibmacro*{bytranslator+othersstrg}{%
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

%% 参考文献表
% \xpretocmd\printbibliography{\begingroup\linespread{1.3}\sloppy}{}{}
% \xapptocmd\printbibliography{\fussy\endgroup}{}{}
\renewcommand{\bibfont}{\xiaowu}
\setlength{\bibitemsep}{0.36ex} % 1.3*1.2-1.2
% \setlength{\bibitemsep}{\baselineskip}
% \addtolength{\bibitemsep}{-\ht\strutbox}
\setlength{\bibitemindent}{0em} % bibitemindent表示一条文献中第一行相对后面各行的缩进
\setlength{\bibhang}{3em} % 著者-出版年制中bibhang 表示的各行起始位置到页边的距离
\setlength{\biblabelsep}{2mm} % 调整顺序标签与文献内容的间距
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
    \renewcommand*{\makelabel}[1]{\hss##1}}{%
  \endlist}{%
  \item%
}


\endinput
