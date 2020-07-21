% !Mode::"TeX:UTF-8"
% Options: chinese

% -------------------- Identification --------------------

\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\ProvidesClass{tjuthesis}[2020/06/19 0.0.0 Tongji University Thesis Template]

% -------------------- Preliminary Declarations --------------------

\newcommand{\version}{0.0.0}
\newcommand{\DocumentClass}{article}

% -------------------- Handle Options --------------------

\newcommand{\tju@abstract@name}{摘要}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\DocumentClass}}

\ProcessOptions\relax

% -------------------- More Declarations --------------------

\RequirePackage{kvdefinekeys}
\RequirePackage{kvsetkeys}
\RequirePackage{kvoptions}

\LoadClass[a4paper, 12pt]{ctexart}

\RequirePackage{etoolbox}

% Modify the sizes of the document

\RequirePackage{geometry}
\geometry{left=2.5cm, right=2.5cm, top=2.5cm, bottom=2.5cm}

% Change page style

\RequirePackage{fancyhdr}
\RequirePackage{lastpage}

\pagestyle{fancy}
\pagenumbering{arabic}

% \newcommand{\PageHead}[2]{\ifchinese@option{第#1页\ 共\ #2\ 页}\else{Page #1\ of #2}\fi}

% \renewcommand{\headrulewidth}{0.4pt}
% \renewcommand{\footrulewidth}{0.4pt}
\setlength{\headheight}{15pt}
% \fancyhead[L]{\footnotesize{\ifx\@course\undefined{}\else{\CourseStyle\@course{ -- }\fi}\TitleStyle\@title}}
% \fancyhead[C]{}
% \fancyhead[R]{\footnotesize{\PageHead{\thepage}{\pageref{LastPage}}}}
% \fancyfoot[L, C]{}
% \fancyfoot[C]{}
% \fancyfoot[R]{\footnotesize\AuthorStyle\@author}


% 论文基本结构
\newcommand\frontmatter{%
    \cleardoublepage
    % \@mainmatterfalse
    \pagenumbering{roman}}

\newcommand\mainmatter{%
    \cleardoublepage
    % \@mainmattertrue
    \pagenumbering{arabic}
}

\newcommand\backmatter{%
    \clearpage
}


% 文献著录
\usepackage[%
    backend=biber,style=gb7714-2015,gbalign=gb7714-2015,gbpub=false
    ]{biblatex} % 需要 biblatex-gb7714-2015 宏包
\bibliography{ref/refs}


% 摘要
\renewenvironment{abstract}{\section*{\tju@abstract@name}}{}

\endinput
