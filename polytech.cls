\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\def\polytechfileversion{1.0}
\def\polytechfiledate{2016/04/13}
\ProvidesClass{polytech/polytech}[\polytechfiledate\space Polytech document class by Sebastien Aupetit <aupetit@univ-tours.fr>, V\polytechfileversion]

%###
 
% -----------------------------------------------------------------------------
% Include generic packages to extend LaTeX memory and add common utility commands
% -----------------------------------------------------------------------------
\RequirePackage{etex}
\RequirePackage{atveryend}
\RequirePackage{etoolbox}
\RequirePackage{calc}
\RequirePackage{xstring}
\RequirePackage{xparse}

% Add an early hook at the beginning of the document allowing to do some tests of parameters
\AtBeginDocument{\csuse{polytech@check@preamble}}

\newcommand{\polytecherror}[1]{%
  \begingroup
  \set@display@protect%
  \errmessage{Polytech: #1}
  \endgroup
}

% Display an error message and stop compilation as soone as possible
\newcommand{\polytechfatalerror}[1]{%
  \begingroup
  \set@display@protect%
  \errmessage{Polytech: #1}
  \endgroup
  \stop%
}

\AtBeginDocument{\booltrue{polytech@allownewpagestartenddoc}}
\AtEndDocument{\booltrue{polytech@allownewpagestartenddoc}}


% -----------------------------------------------------------------------------
% Declare documentclass options
% -----------------------------------------------------------------------------

% Prepare document in english
\newbool{polytech@english}
\def\polytech@lang{fr}
\DeclareOption{english}{
	\setbool{polytech@english}{true}
	\gdef\polytech@lang{en}
}

% Make document final disabling useless things
\newbool{polytech@final}
\DeclareOption{final}{\booltrue{polytech@final}}

% Force black and white colors
\newbool{polytech@blackandwhite}
\DeclareOption{blackandwhite}{\booltrue{polytech@blackandwhite}}

\newbool{polytech@hideweeklyreports}
\DeclareOption{hideweeklyreports}{\booltrue{polytech@hideweeklyreports}}

\newbool{polytech@nodate}
\DeclareOption{nodate}{\booltrue{polytech@nodate}}

\newbool{polytech@nobibannotations}
\DeclareOption{nobibannotations}{\booltrue{polytech@nobibannotations}}

\newbool{polytech@roundtofour}
\DeclareOption{roundtofour}{\booltrue{polytech@roundtofour}}

\newbool{polytech@twoside}
\DeclareOption{twoside}{\booltrue{polytech@twoside}}

\newbool{polytech@firstlastonly}
\DeclareOption{firstlastonly}{\booltrue{polytech@firstlastonly}}

\newbool{polytech@noposter}
\DeclareOption{noposter}{\booltrue{polytech@noposter}}

\newbool{polytech@poster}
\DeclareOption{poster}{\booltrue{polytech@poster}}

\newbool{polytech@onlyposter}
\DeclareOption{onlyposter}{\booltrue{polytech@onlyposter}\booltrue{polytech@poster}}

\DeclareOption*{\PackageWarning{polytech}{Unknown option `\CurrentOption'}}

\ProcessOptions\relax

%------------- global lrbox (use \begin{lrbox*} instead of \begin{lrbox} to save the box globally instead of locally ----------------
\cslet{lrbox*}\lrbox
\expandafter\patchcmd\csname lrbox*\endcsname{\setbox}{\global\setbox}{}{}
%\expandafter\show\csname lrbox*\endcsname % uncomment to see if it has worked
\cslet{endlrbox*}\endlrbox



%-------------- Configuration ----------------

% upgrade PDF version of the document
\pdfoptionpdfminorversion=6

% allow url to break on multiple lines
\PassOptionsToPackage{hyphens}{url}

% Enable colors
\PassOptionsToPackage{svgnames,table,override}{xcolor}

% babel
\ifbool{polytech@english}{
    \PassOptionsToPackage{french,main=english}{babel} % english document
    \RequirePackage{babel}
    \PassOptionsToPackage{english}{algorithm2e}
}{
    \PassOptionsToPackage{english,main=french}{babel}  % french document
    \RequirePackage{babel}
    \frenchbsetup{StandardEnumerateEnv=true}
    \frenchspacing
    \PassOptionsToPackage{frenchstyle}{kpfonts}
    \PassOptionsToPackage{french}{algorithm2e}
}

\ifbool{polytech@twoside}{
	\PassOptionsToClass{twoside}{book}
}{}

\PassOptionsToClass{11pt}{book}
\LoadClass{book}

\setlength\paperheight{29.7cm}%
\setlength\paperwidth{21cm}%

\RequirePackage[
        papersize={\paperwidth,\paperheight},
        twoside,
        bindingoffset=0cm,
        heightrounded,
        includeall,
        nomarginpar,
        headheight=14pt,
        headsep=12pt,
        footskip=30pt,
        vmargin=1.5cm,
        hmargin=2.5cm]{geometry}

\csdef{polytech@output@setupfirstlastpagegeometry}{%
	\newgeometry{%
    twoside,
    bindingoffset=0cm,
    heightrounded,
    includeall,
    nomarginpar,
    headheight=0pt,
    headsep=0pt,
    footskip=0pt,
    vmargin=1.5cm,
    hmargin=2.5cm
  }%
}

% enable overbox display as black box. must be after class loading
\notbool{polytech@final}{
  \setlength{\overfullrule}{5pt}    
}{
  \PassOptionsToClass{final}{book}
}

\RequirePackage[T1]{fontenc}    % OT1 font encoding (must be before inputenc)
\RequirePackage[utf8]{inputenc} % encoding is set to utf8
\RequirePackage[full]{textcomp}
\DeclareUnicodeCharacter{B0}{\textdegree}

\RequirePackage{csquotes}
\RequirePackage[%
	backend=biber,
	style=numeric-comp,
	sorting=nyt,
	sortcase=false,
	sortcites=true,
	maxnames=10,
	minnames=10,
	autocite=plain,
	defernumbers,
	bibencoding=utf8,
	]{biblatex}


% options are processed then we do some update
\ifbool{polytech@blackandwhite}{
	\PassOptionsToPackage{light}{kpfonts}	% better printing in light
}{}

% switch to richer and more scallable fonts
\RequirePackage[nofligatures,nointlimits,sumlimits]{kpfonts} 
% improve typography
\RequirePackage[final,babel]{microtype} 

% allow to customize sectionning
\RequirePackage[rigidchapters,explicit,toctitles,clearempty]{titlesec}


%%% newpage disabled flags
\newbool{polytech@allownewpagesection}
\newbool{polytech@allownewpagestartenddoc}

\let\polytech@oldnewpage\newpage

\renewcommand{\newpage}{%
  \ifbool{polytech@allownewpagestartenddoc}{
    \polytech@oldnewpage%
  }{%
    \ifbool{polytech@allownewpagesection}{%
      \polytech@oldnewpage%
    }{%
      \polytech@oldnewpage%
      \polytecherror{You are not allowed to use \string\newpage, \string\clearpage\space or \string\cleardoublepage.}%
    }%
  }%
}


% patch standard sectionning command before loading package changing them 

% force long title in TOC but keep short title for headings
\patchcmd{\@chapter}%
{\addcontentsline {toc}{chapter}{\protect\numberline {\thechapter }#1}}
{\addcontentsline {toc}{chapter}{\protect\numberline {\thechapter }#2}%
}
{}{
  \polytechfatalerror{Cannot patch \string\@chapter.}
}
\patchcmd{\@chapter}%
{\addcontentsline {toc}{chapter}{#1}}
{\addcontentsline {toc}{chapter}{#2}%
}
{}{
  \polytechfatalerror{Cannot patch \string\@chapter.}
}
\patchcmd{\@chapter}%
{\addcontentsline {toc}{chapter}{#1}}
{\addcontentsline {toc}{chapter}{#2}%
}
{}{
  \polytechfatalerror{Cannot patch \string\@chapter.}
}
 
% remove calls to \@chapter and \@schapter from the original \chapter command
\patchcmd{\chapter}
{\secdef\@chapter\@schapter}
{}
{}
{
  \polytechfatalerror{Cannot patch \string\chapter.}
}
       
% save current definition     
\let\polytech@chapter\chapter

% allow to differentiate chapter/part of sections
\newbool{polytech@ref@section} 

% allow to detect if we are in a chapter
\newbool{polytech@ref@inchapter}

% allow proper handling of unnumbered chapters in \ref
\newbool{polytech@ref@unnumberedchapter}

\newcounter{polytech@chapter@counter}[part]

% \appendix called ?
\newbool{polytech@ref@appendix}

% replace \chapter definition to automatically register unnumbered chapter in toc and set heading marks
% need to be before hyperref
\RenewDocumentCommand{\chapter}{som}{%  
  \booltrue{polytech@allownewpagesection}%
  \boolfalse{polytech@ref@section}%
  \booltrue{polytech@ref@inchapter}%
  \polytech@chapter%
  \IfBooleanTF{#1}{% starred
    % if unnumbered appendix => error
    \ifbool{polytech@ref@appendix}{%
      \polytechfatalerror{Appendix chapter must be numbered. \string\chapter* is forbidden here.}%
    }{}%
    \global\booltrue{polytech@ref@unnumberedchapter}%
    \@schapter{#3}%
    \addcontentsline {toc}{chapter}{#3}{}%
    \IfValueTF{#2}{%
      \markboth{#2}{}%
    }{%
      \markboth{#3}{}%
    }%
  }{%
    \global\boolfalse{polytech@ref@unnumberedchapter}%
    \IfValueTF{#2}{%
      \@chapter[#2]{#3}%
    }{%
      \@chapter[#3]{#3}%
    }%
  }%
  \stepcounter{polytech@chapter@counter}%
  \boolfalse{polytech@allownewpagesection}%
}


\preto{\appendix}{%
  \booltrue{polytech@allownewpagesection}%
  \booltrue{polytech@ref@appendix}%
  \boolfalse{polytech@ref@inchapter}%
}
\appto{\appendix}{%
  \part*{\csuse{polytech@ref@name@appendices@\csuse{polytech@lang}}}%
  \boolfalse{polytech@allownewpagesection}%
}


\preto{\section}{%
  \booltrue{polytech@ref@section}%
}

\preto{\subsection}{%
  \booltrue{polytech@ref@section}%
}

\preto{\subsubsection}{%
  \booltrue{polytech@ref@section}%
}

\preto{\paragraph}{%
  \booltrue{polytech@ref@section}%
}

\preto{\subparagraph}{%
  \booltrue{polytech@ref@section}%
}




%-------------- lot of packages -------------

\RequirePackage{nameref}
\RequirePackage{fancyhdr}
\RequirePackage{makeidx}
\RequirePackage{amsmath}
\RequirePackage{amsfonts}
\RequirePackage{marvosym}
\RequirePackage{stmaryrd}
\RequirePackage[final]{listings}[2015/06/04]
\RequirePackage{fancybox}
\RequirePackage{longtable}
\RequirePackage{tabu}
\RequirePackage{lscape}
\RequirePackage{comment}
\RequirePackage{pgf}
\RequirePackage{tikz}
\RequirePackage{url}
\RequirePackage{framed}
\RequirePackage{fancyvrb}
\RequirePackage{makerobust}
\RequirePackage[lined,boxed]{algorithm2e}
\RequirePackage[figure,table,lstlisting]{totalcount}
\RequirePackage{pdfpages}
\RequirePackage{eurosym} % symbol euro
\RequirePackage[user]{zref} % allow for better \ref and  \label
\RequirePackage{environ} % used by Figure and Table
\RequirePackage[calc]{adjustbox} % box sizing utilities

\RequirePackage{enumitem} % to typeset enums

\usetikzlibrary{decorations.pathmorphing,calc,patterns,positioning,fit}

\ifbool{polytech@blackandwhite}{
	% disable hyperlinks
	\PassOptionsToPackage{draft,linkcolor=black,citecolor=black,filecolor=black,urlcolor=black}{hyperref}
}
{
	\PassOptionsToPackage{final,linkcolor=red,citecolor=green,filecolor=cyan,urlcolor=magenta}{hyperref}
}

\RequirePackage[plainpages=false,
                pdfpagelabels=true,
                verbose=false,
                breaklinks=true,
                colorlinks=true,
                bookmarksopen=true,
                pdfborder={0 0 0},
                unicode=true,
                bookmarksnumbered,
                pdfnewwindow=true,
                pdfstartview={FitH},
                pdftoolbar=true,
                pdfmenubar=true,
                linktocpage=true,
                bookmarks=true]{hyperref}

\RequirePackage{bookmark}
\RequirePackage{pageslts} % to have total page count of the document. Must be at the end for proper functionning
\RequirePackage{refcount}

\RequirePackage[planb=false]{newfloat}
\RequirePackage{caption}

% colors
\definecolor{polytechdarkblue}{RGB}{0,74,117}
\definecolor{polytechlightblue}{RGB}{0,156,221}
\definecolor{polytechorange}{RGB}{221,56,0}

\newlength{\polytechfitimageheight}
\newlength{\polytechfitimagewidth}

% height, filepath
\newcommand{\fitimagetoheight}[2]{%
  % compute length to allow expression
  \setlength{\polytechfitimageheight}{#1}%
  \maxsizebox{!}{\polytechfitimageheight}{%
    \adjincludegraphics[min height=\polytechfitimageheight]{#2}%
  }%
}

% width, filepath
\newcommand{\fitimagetowidth}[2]{%
  % compute length to allow expression
  \setlength{\polytechfitimagewidth}{#1}%
  \maxsizebox{\polytechfitimagewidth}{!}{%
    \adjincludegraphics[min width=\polytechfitimagewidth]{#2}%
  }%
}

% width, height, filepath
\newcommand{\fitimagetobox}[3]{%
  % compute length to allow expression
  \setlength{\polytechfitimagewidth}{#1}%
  \setlength{\polytechfitimageheight}{#2}%
  \maxsizebox{\polytechfitimagewidth}{\polytechfitimageheight}{%
      \adjincludegraphics[min height=\polytechfitimagewidth, min width=\polytechfitimageheight]{#3}%
  }%
}


% sub packages
\RequirePackage{polytech/constants}
\RequirePackage{polytech/citingdoc}
\RequirePackage{polytech/firstlastpage}
\RequirePackage{polytech/warning}
\RequirePackage{polytech/headings}
\RequirePackage{polytech/sectionning}
\RequirePackage{polytech/floats}
\RequirePackage{polytech/weeklyreports}
\RequirePackage{polytech/listings}
\RequirePackage{polytech/references}
\RequirePackage{polytech/poster}

\setlength{\parskip}{1ex plus 0.2ex minus 0.2ex}
\setlength{\topsep}{1pt plus 1pt minus 1pt}
\setlength{\parsep}{\parskip}
\setlength{\itemsep}{1pt plus 1pt minus 1pt}
\setlength{\partopsep}{1pt plus 1pt minus 1pt}
\setlength{\parindent}{0in}

\setlist{noitemsep,nosep,topsep=0pt,parsep=0pt,partopsep=0pt}

\widowpenalty=300
\clubpenalty=300


\setcounter{tocdepth}{3}
\renewcommand{\@dotsep}{0.1}
\setcounter{secnumdepth}{3}

\renewcommand{\baselinestretch}{1}

\ifbool{polytech@blackandwhite}{
	\arrayrulecolor{black}
}{
	\arrayrulecolor{polytechdarkblue}
}

\renewcommand{\arraystretch}{1.2}
\extrarowsep=1mm
\tabulinesep=1mm

\newbool{polytech@contentsline@lof@written}
\newbool{polytech@contentsline@lot@written}

\let\polytech@contentsline@oldaddcontentsline\addcontentsline


\renewcommand{\addcontentsline}[3]{
	\ifcsdef{polytech@contentsline@add@#1@#2}{
		\csuse{polytech@contentsline@add@#1@#2}{#1}{#2}{#3}
	}{}
	\polytech@contentsline@oldaddcontentsline{#1}{#2}{#3}
}


\newcommand{\polytech@contentsline@add@toc@chapter}[3]{%
	\boolfalse{polytech@contentsline@lot@written}%
	\boolfalse{polytech@contentsline@lof@written}%
	\global\csdef{polytech@contentsline@current@content}{#3}
	%\csxdef{polytech@contentsline@current@page}{\thepage}
	\csxdef{polytech@contentsline@current@href}{\@currentHref}%
}

\newcommand{\polytech@contentsline@add@lof@figure}[3]{
	\ifbool{polytech@contentsline@lof@written}{%
	}%
	{%
		\addtocontents{lof}{\protect \contentsline {chapter}{\csuse{polytech@contentsline@current@content}}{\csuse{polytech@contentsline@current@page}}{\csuse{polytech@contentsline@current@href}}}%
		\global\booltrue{polytech@contentsline@lof@written}%
	}%
}
\newcommand{\polytech@contentsline@add@lot@table}[3]{%
	\ifbool{polytech@contentsline@lot@written}{%
	}%
	{%
		\addtocontents{lot}{\protect \contentsline {chapter}{\csuse{polytech@contentsline@current@content}}{\csuse{polytech@contentsline@current@page}}{\csuse{polytech@contentsline@current@href}}}%
		\global\booltrue{polytech@contentsline@lot@written}%
	}%
}


\preto{\landscape}{\booltrue{polytech@allownewpagesection}}
\appto{\endlandscape}{\boolfalse{polytech@allownewpagesection}}

% allow newpage for pdfpages
\let\polytech@oldincludepdf\includepdf
\gdef\includepdf[#1]#2{%
  \booltrue{polytech@allownewpagesection}%
  \polytech@oldincludepdf[#1]{#2}%
  \boolfalse{polytech@allownewpagesection}%
}
\let\polytech@oldincludepdfmerge\includepdfmerge
\gdef\includepdfmerge[#1]#2{%
  \booltrue{polytech@allownewpagesection}%
  \polytech@oldincludepdfmerge[#1]{#2}%
  \boolfalse{polytech@allownewpagesection}%
}


% replace \cleardoublepage by \clearpage on oneside printing
\ifbool{polytech@twoside}{}{\renewcommand{\cleardoublepage}{\clearpage}}



  % \nocite is fordibben
  \csundef{nocite}


%###
