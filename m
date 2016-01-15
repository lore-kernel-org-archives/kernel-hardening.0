Reply-To: kernel-hardening@lists.openwall.com
From: "Schaufler, Casey" <casey.schaufler@intel.com>
Date: Fri, 15 Jan 2016 01:43:59 +0000
Message-ID: <99FC4B6EFCEFD44486C35F4C281DC6731F1FBD13@ORSMSX107.amr.corp.intel.com>
Content-Type: multipart/alternative;
	boundary="_000_99FC4B6EFCEFD44486C35F4C281DC6731F1FBD13ORSMSX107amrcor_"
MIME-Version: 1.0
Subject: [kernel-hardening] Still working on PAX_USERCOPY
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

--_000_99FC4B6EFCEFD44486C35F4C281DC6731F1FBD13ORSMSX107amrcor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Just a brief status update on my work on PAX_USERCOPY. I've ditched my firs=
t two attempts at doing somewhat simple minded cut'n'patch and am going to =
have to take a more engineering (e.g. understanding what's really going on)=
 approach. The good news is that I've made enough mistakes to think there a=
ren't that many left for a project this size.


--_000_99FC4B6EFCEFD44486C35F4C281DC6731F1FBD13ORSMSX107amrcor_
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;}
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
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Just a brief status update on my work on PAX_USERCOP=
Y. I&#8217;ve ditched my first two attempts at doing somewhat simple minded=
 cut&#8217;n&#8217;patch and am going to have to take a more engineering (e=
.g. understanding what&#8217;s really going on) approach.
 The good news is that I&#8217;ve made enough mistakes to think there aren&=
#8217;t that many left for a project this size.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
</body>
</html>

--_000_99FC4B6EFCEFD44486C35F4C281DC6731F1FBD13ORSMSX107amrcor_--
