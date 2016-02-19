Reply-To: kernel-hardening@lists.openwall.com
From: "Schaufler, Casey" <casey.schaufler@intel.com>
Date: Fri, 19 Feb 2016 00:36:48 +0000
Message-ID: <99FC4B6EFCEFD44486C35F4C281DC6731F2182A2@ORSMSX107.amr.corp.intel.com>
Content-Type: multipart/alternative;
	boundary="_000_99FC4B6EFCEFD44486C35F4C281DC6731F2182A2ORSMSX107amrcor_"
MIME-Version: 1.0
Subject: [kernel-hardening] RE: Still working on PAX_USERCOPY
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

--_000_99FC4B6EFCEFD44486C35F4C281DC6731F2182A2ORSMSX107amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On 1/19/2016 3:59 PM, Kees Cook wrote:

> On Thu, Jan 14, 2016 at 5:43 PM, Schaufler, Casey

> <casey.schaufler@intel.com<mailto:casey.schaufler@intel.com>> wrote:

>> Just a brief status update on my work on PAX_USERCOPY. I've ditched my f=
irst

>> two attempts at doing somewhat simple minded cut'n'patch and am going to

>> have to take a more engineering (e.g. understanding what's really going =
on)

>> approach. The good news is that I've made enough mistakes to think there

>> aren't that many left for a project this size.

> Thanks for the report! Were you able to use or improve on the

> lib/test_user_copy.c tests during your experiments? (Or maybe we just

> need a separate lkdtm test?)



No, but hopefully before too long ...



> What kinds of dead-ends did you run into?



There are a few things that are "obvious", the GFP_USERCOPY

and CONFIG_PAX_USERCOPY (duh?) bits being the most so. And

yet, they turn out not to be so obvious. Much of what's under

ifdef isn't actually part of the feature, it's special cases

in other PAX features. PAX_USERCOPY appears to have come along

fairly late in the PAX feature set, and counts on a bunch of

previously implemented facilities. There are chunks of stack

management, for example, that (I think) have to be included.



It's not enough to understand PAX_USERCOPY. You really have

to understand all of the PAX and grsecurity memory management

changes to come up with something that works. That's what I'm

working on now, and while there's progress, it's a slog.



I'm embarking on what Intel calls a "mini-sabbatical", which

will take me away from my keyboard for 4 weeks. When I return

I plan to pick up where I left off. Hopefully with fresher and

better rested eyes.



> -Kees

>



--_000_99FC4B6EFCEFD44486C35F4C281DC6731F2182A2ORSMSX107amrcor_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
p.MsoPlainText, li.MsoPlainText, div.MsoPlainText
	{mso-style-priority:99;
	mso-style-link:"Plain Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
span.EmailStyle17
	{mso-style-type:personal;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.EmailStyle18
	{mso-style-type:personal-reply;
	font-family:"Calibri",sans-serif;
	color:#1F497D;}
span.PlainTextChar
	{mso-style-name:"Plain Text Char";
	mso-style-priority:99;
	mso-style-link:"Plain Text";
	font-family:"Calibri",sans-serif;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p class=3D"MsoPlainText">On 1/19/2016 3:59 PM, Kees Cook wrote:<o:p></o:p>=
</p>
<p class=3D"MsoPlainText">&gt; On Thu, Jan 14, 2016 at 5:43 PM, Schaufler, =
Casey<o:p></o:p></p>
<p class=3D"MsoPlainText">&gt; &lt;<a href=3D"mailto:casey.schaufler@intel.=
com">casey.schaufler@intel.com</a>&gt; wrote:<o:p></o:p></p>
<p class=3D"MsoPlainText">&gt;&gt; Just a brief status update on my work on=
 PAX_USERCOPY. I&#8217;ve ditched my first<o:p></o:p></p>
<p class=3D"MsoPlainText">&gt;&gt; two attempts at doing somewhat simple mi=
nded cut&#8217;n&#8217;patch and am going to<o:p></o:p></p>
<p class=3D"MsoPlainText">&gt;&gt; have to take a more engineering (e.g. un=
derstanding what&#8217;s really going on)<o:p></o:p></p>
<p class=3D"MsoPlainText">&gt;&gt; approach. The good news is that I&#8217;=
ve made enough mistakes to think there<o:p></o:p></p>
<p class=3D"MsoPlainText">&gt;&gt; aren&#8217;t that many left for a projec=
t this size.<o:p></o:p></p>
<p class=3D"MsoPlainText">&gt; Thanks for the report! Were you able to use =
or improve on the<o:p></o:p></p>
<p class=3D"MsoPlainText">&gt; lib/test_user_copy.c tests during your exper=
iments? (Or maybe we just<o:p></o:p></p>
<p class=3D"MsoPlainText">&gt; need a separate lkdtm test?)<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">No, but hopefully before too long ...<o:p></o:p><=
/p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">&gt; What kinds of dead-ends did you run into?<o:=
p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">There are a few things that are &quot;obvious&quo=
t;, the GFP_USERCOPY<o:p></o:p></p>
<p class=3D"MsoPlainText">and CONFIG_PAX_USERCOPY (duh?) bits being the mos=
t so. And<o:p></o:p></p>
<p class=3D"MsoPlainText">yet, they turn out not to be so obvious. Much of =
what's under<o:p></o:p></p>
<p class=3D"MsoPlainText">ifdef isn't actually part of the feature, it's sp=
ecial cases<o:p></o:p></p>
<p class=3D"MsoPlainText">in other PAX features. PAX_USERCOPY appears to ha=
ve come along<o:p></o:p></p>
<p class=3D"MsoPlainText">fairly late in the PAX feature set, and counts on=
 a bunch of<o:p></o:p></p>
<p class=3D"MsoPlainText">previously implemented facilities. There are chun=
ks of stack<o:p></o:p></p>
<p class=3D"MsoPlainText">management, for example, that (I think) have to b=
e included.<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">It's not enough to understand PAX_USERCOPY. You r=
eally have<o:p></o:p></p>
<p class=3D"MsoPlainText">to understand all of the PAX and grsecurity memor=
y management<o:p></o:p></p>
<p class=3D"MsoPlainText">changes to come up with something that works. Tha=
t's what I'm<o:p></o:p></p>
<p class=3D"MsoPlainText">working on now, and while there's progress, it's =
a slog.<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">I'm embarking on what Intel calls a &quot;mini-sa=
bbatical&quot;, which<o:p></o:p></p>
<p class=3D"MsoPlainText">will take me away from my keyboard for 4 weeks. W=
hen I return<o:p></o:p></p>
<p class=3D"MsoPlainText">I plan to pick up where I left off. Hopefully wit=
h fresher and<o:p></o:p></p>
<p class=3D"MsoPlainText">better rested eyes.<o:p></o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText">&gt; -Kees<o:p></o:p></p>
<p class=3D"MsoPlainText">&gt;<o:p>&nbsp;</o:p></p>
<p class=3D"MsoPlainText"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_99FC4B6EFCEFD44486C35F4C281DC6731F2182A2ORSMSX107amrcor_--
