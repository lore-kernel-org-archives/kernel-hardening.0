Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Mon, 18 Jan 2016 09:22:33 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41A51095@IRSMSX102.ger.corp.intel.com>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=SHA1; boundary="----=_NextPart_000_002F_01D151E2.8610ED10"
MIME-Version: 1.0
Subject: [kernel-hardening] Understanding the JIT Hardening feature
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, "Schaufler, Casey" <casey.schaufler@intel.com>, "Leibowitz, Michael" <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

------=_NextPart_000_002F_01D151E2.8610ED10
Content-Type: multipart/alternative;
	boundary="----=_NextPart_001_0030_01D151E2.8610ED10"


------=_NextPart_001_0030_01D151E2.8610ED10
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

 

I got to spend some time reading the 3.15 grsecurity patch with regards to
JIT hardening feature and wanted to share my thoughts on what the patch was
attempting to do.

 

It seems that the bulk of changes was done in bpf_jit_compile() function
(corresponds to the do_jit() 4.4 function). 

The way how it was done was to generate a random value (randkey =
prandom_u32();) and then use that value to dilute (by xor with this value)
the the four cases of operations:

 

case BPF_S_ALU_MUL_K: /* A *= K */

case BPF_S_ALU_MOD_K: /* A %= K; */

case BPF_S_ALU_DIV_K: /* A /= K */

case BPF_S_ALU_AND_X:

 

 

Another part of the patch was making changes to the bpf_alloc_binary()
function. That part I don't really understand since it didn't seem to make
any security improvements, but merely setting the header length to be 128 ad
changing the bpf_binary_header pointer structure. If this change is to be
moved to the latest kernel, modifications to the
<http://lxr.free-electrons.com/ident?i=bpf_jit_binary_alloc>
bpf_jit_binary_alloc() function (kernel/bpf/core.c) are needed as well as
changes in  <http://lxr.free-electrons.com/ident?i=bpf_binary_header>
bpf_binary_header pointer structure (include/linux/filter.h). But again, I
do not understand what security improvements these changes make and why they
were done at the first place. 

 

The last change from the patch was done in EMIT_COND_JMP() function (which
in later kernels is included into emit_cond_jmp switch statement), which was
adding a conditional jz into the flow based on the randkey value. It was
affecting the following cases:

 

case BPF_S_ALU_DIV_X: /* A /= X; */
case BPF_S_ALU_MOD_X: /* A %= X; */
case BPF_S_ANC_IFINDEX:
 

as well as conditional branch. 

 

The above doesn't seem to go very much in line with what Daniel suggested
earlier:

 

"We agreed that the way to go would be to try mitigating it on a BPF
bytecode level iff feasible. For example, by expanding/rewriting things like
loading constants into a i) load where the constant is xored with a (each
time newly generated) prandom_u32()/.. value followed by ii) xor on the same
reg with that prandom value itself."

 

It is also very likely that I didn't understand what you mean Daniel. So
some clarification questions: 

 

-          would you agree with the places where the original grsecurity
patch attempts to add randomization or do you think places should be
different?

-          for the actual randomization, are you proposing to enhance it by
not only xor to a prandom_u32() but also xor with the same reg? Could you
explain what do you mean by this part? 

 

I was also trying to find more info about how JIT code itself works, but
wasn't able to find anything reasonable, so have to make all my statements
from just reading the code, which turned out isn't the most easiest thing to
understand for smbd not familiar with topic.  So, any pointers to the
reading material, if exist, are very much appreciated. 

 

Best Regards,
Elena. 

 

 


------=_NextPart_001_0030_01D151E2.8610ED10
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40"><head><META =
HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii"><meta name=3DGenerator content=3D"Microsoft Word 15 =
(filtered medium)"><style><!--
/* Font Definitions */
@font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
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
	font-family:"Calibri",sans-serif;
	mso-fareast-language:EN-US;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
pre
	{mso-style-priority:99;
	mso-style-link:"HTML Preformatted Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:10.0pt;
	font-family:"Courier New";}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{mso-style-priority:34;
	margin-top:0in;
	margin-right:0in;
	margin-bottom:0in;
	margin-left:.5in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;
	mso-fareast-language:EN-US;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
span.HTMLPreformattedChar
	{mso-style-name:"HTML Preformatted Char";
	mso-style-priority:99;
	mso-style-link:"HTML Preformatted";
	font-family:"Courier New";
	mso-fareast-language:FI;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri",sans-serif;
	mso-fareast-language:EN-US;}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
/* List Definitions */
@list l0
	{mso-list-id:305286661;
	mso-list-type:hybrid;
	mso-list-template-ids:1479189556 1962698266 67829763 67829765 67829761 =
67829763 67829765 67829761 67829763 67829765;}
@list l0:level1
	{mso-level-start-at:9;
	mso-level-number-format:bullet;
	mso-level-text:-;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Calibri",sans-serif;
	mso-fareast-font-family:Calibri;
	mso-bidi-font-family:"Times New Roman";}
@list l0:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l0:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l0:level5
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l0:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l0:level8
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l0:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l1
	{mso-list-id:1433865963;
	mso-list-type:hybrid;
	mso-list-template-ids:-696761436 -1362334740 67829763 67829765 67829761 =
67829763 67829765 67829761 67829763 67829765;}
@list l1:level1
	{mso-level-start-at:9;
	mso-level-number-format:bullet;
	mso-level-text:-;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";
	mso-fareast-font-family:"Times New Roman";}
@list l1:level2
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l1:level3
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l1:level4
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l1:level5
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l1:level6
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
@list l1:level7
	{mso-level-number-format:bullet;
	mso-level-text:\F0B7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Symbol;}
@list l1:level8
	{mso-level-number-format:bullet;
	mso-level-text:o;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:"Courier New";}
@list l1:level9
	{mso-level-number-format:bullet;
	mso-level-text:\F0A7;
	mso-level-tab-stop:none;
	mso-level-number-position:left;
	text-indent:-.25in;
	font-family:Wingdings;}
ol
	{margin-bottom:0in;}
ul
	{margin-bottom:0in;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]--></head><body lang=3DFI =
link=3D"#0563C1" vlink=3D"#954F72"><div class=3DWordSection1><p =
class=3DMsoNormal><span lang=3DEN-GB>Hi,<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB>I got to spend some time reading =
the 3.15 grsecurity patch with regards to JIT hardening feature and =
wanted to share my thoughts on what the patch was attempting to =
do.<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB>It seems that the bulk of changes was done in =
bpf_jit_compile() function (corresponds to the do_jit() 4.4 function). =
<o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-GB>The way =
how it was done was to generate a random value (randkey =3D =
prandom_u32();) and then use that value to dilute (by xor with this =
value) the the four cases of operations:<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB>case BPF_S_ALU_MUL_K: /* A *=3D K =
*/<o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-GB>case =
BPF_S_ALU_MOD_K: /* A %=3D K; */<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB>case BPF_S_ALU_DIV_K: /* A /=3D K =
*/<o:p></o:p></span></p><p class=3DMsoNormal><span lang=3DEN-GB>case =
BPF_S_ALU_AND_X:<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB>Another part of the patch was making changes to the =
bpf_alloc_binary() function. That part I don&#8217;t really understand =
since it didn&#8217;t seem to make any security improvements, but merely =
setting the header length to be 128 ad changing the bpf_binary_header =
pointer structure. If this change is to be moved to the latest kernel, =
modifications to the <a =
href=3D"http://lxr.free-electrons.com/ident?i=3Dbpf_jit_binary_alloc"><sp=
an =
style=3D'color:windowtext;text-decoration:none'>bpf_jit_binary_alloc</spa=
n></a>() function (kernel/bpf/core.c) are needed as well as changes in =
<a =
href=3D"http://lxr.free-electrons.com/ident?i=3Dbpf_binary_header"><span =
style=3D'color:windowtext;text-decoration:none'>bpf_binary_header</span><=
/a> pointer structure (include/linux/filter.h). But again, I do not =
understand what security improvements these changes make and why they =
were done at the first place. <o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB>The last change from the patch was =
done in EMIT_COND_JMP() function (which in later kernels is included =
into emit_cond_jmp switch statement), which was adding a conditional jz =
into the flow based on the randkey value. It was affecting the following =
cases:<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><pre><span lang=3DEN-GB>case =
BPF_S_ALU_DIV_X: <b><i>/* A /=3D X; =
*/</i></b><o:p></o:p></span></pre><pre><span lang=3DEN-GB>case =
BPF_S_ALU_MOD_X: <b><i>/* A %=3D X; =
*/<o:p></o:p></i></b></span></pre><pre><span lang=3DEN-GB>case =
BPF_S_ANC_IFINDEX:<o:p></o:p></span></pre><pre><span =
lang=3DEN-GB><o:p>&nbsp;</o:p></span></pre><p class=3DMsoNormal><span =
lang=3DEN-GB> as well as conditional branch. <o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB>The above doesn&#8217;t seem to go =
very much in line with what Daniel suggested =
earlier:<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB>&#8220;We agreed that the way to go would be to try =
mitigating it on a BPF bytecode level iff feasible. For example, by =
expanding/rewriting things like loading constants into a i) load where =
the constant is xored with a (each time newly generated) =
prandom_u32()/.. value followed by ii) xor on the same reg with that =
prandom value itself.&#8221;<o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB>It is also very likely that I =
didn&#8217;t understand what you mean Daniel. So some clarification =
questions: <o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p class=3DMsoListParagraph =
style=3D'text-indent:-.25in;mso-list:l0 level1 lfo2'><![if =
!supportLists]><span lang=3DEN-GB><span style=3D'mso-list:Ignore'>-<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span></span><![endif]><span lang=3DEN-GB>would you agree with =
the places where the original grsecurity patch attempts to add =
randomization or do you think places should be =
different?<o:p></o:p></span></p><p class=3DMsoListParagraph =
style=3D'text-indent:-.25in;mso-list:l0 level1 lfo2'><![if =
!supportLists]><span lang=3DEN-GB><span style=3D'mso-list:Ignore'>-<span =
style=3D'font:7.0pt "Times New =
Roman"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
</span></span></span><![endif]><span lang=3DEN-GB>for the actual =
randomization, are you proposing to enhance it by not only xor to a =
prandom_u32() but also xor with the same reg? Could you explain what do =
you mean by this part? <o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB>I was also trying to find more info about how JIT code =
itself works, but wasn&#8217;t able to find anything reasonable, so have =
to make all my statements from just reading the code, which turned out =
isn&#8217;t the most easiest thing to understand for smbd not familiar =
with topic.&nbsp; So, any pointers to the reading material, if exist, =
are very much appreciated. <o:p></o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p =
class=3DMsoNormal><span lang=3DEN-GB>Best Regards,<br>Elena. =
<o:p></o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB><o:p>&nbsp;</o:p></span></p><p class=3DMsoNormal><span =
lang=3DEN-GB><o:p>&nbsp;</o:p></span></p></div></body></html>
------=_NextPart_001_0030_01D151E2.8610ED10--

------=_NextPart_000_002F_01D151E2.8610ED10
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

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
VMv3yxHO8jex40LgMIIFgjCCBGqgAwIBAgITMwAAD3rg031j5++L1QAAAAAPejANBgkqhkiG9w0B
AQUFADB5MQswCQYDVQQGEwJVUzELMAkGA1UECBMCQ0ExFDASBgNVBAcTC1NhbnRhIENsYXJhMRow
GAYDVQQKExFJbnRlbCBDb3Jwb3JhdGlvbjErMCkGA1UEAxMiSW50ZWwgRXh0ZXJuYWwgQmFzaWMg
SXNzdWluZyBDQSA0QjAeFw0xNTAyMTIyMzMzMTJaFw0xODAxMjcyMzMzMTJaMEUxGTAXBgNVBAMT
EFJlc2hldG92YSwgRWxlbmExKDAmBgkqhkiG9w0BCQEWGWVsZW5hLnJlc2hldG92YUBpbnRlbC5j
b20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC8zCTf8cWZZUKtxwMUvSAnw+W43aFU
UojRptAkTEnxL7PPHdqDP9F4q/6oIcHWhlxca0/lopd2l7h1bzb8bRdTWJwQ9Hf67xLNnhRW5Xtu
A6RW88jOU4ALNkktravhIfru5oQ9SatQOJlkRpZWid5ByI4qUe/G3PmCMdOAHFfUQDZ+CpwexUYJ
FUvDcCVAcqRTx4g/jbhAMfmJQ1RnFXj5Wxq3H0PrH7Tsb9bqXSWGxE6Vr5VQI776dWxwWSbu82CF
uUY2j6Qq902bui4Wg0pRUlG66wFbQ9YujkrrhPSScCWOkycSVUy1tguk5L1WHtj2DelrG5We/Z7T
z3IaYQsTAgMBAAGjggI1MIICMTALBgNVHQ8EBAMCB4AwPAYJKwYBBAGCNxUHBC8wLQYlKwYBBAGC
NxUIhsOMdYSZ5VGD/YEohY6fU4KRwAlngd69OZXwQwIBZAIBCDAdBgNVHQ4EFgQUojQGvJU2345o
mYdTt1O7CESK1YYwHwYDVR0jBBgwFoAU2kEjnFqPca9Xgz4g0+Nl2wzLC9swZQYDVR0fBF4wXDBa
oFigVoZUaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRlcm5h
bCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEIuY3JsMIGfBggrBgEFBQcBAQSBkjCBjzAiBggr
BgEFBQcwAYYWaHR0cDovL29jc3AuaW50ZWwuY29tLzBpBggrBgEFBQcwAoZdaHR0cDovL3d3dy5p
bnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMvSW50ZWwlMjBFeHRlcm5hbCUyMEJhc2lj
JTIwSXNzdWluZyUyMENBJTIwNEIuY3J0MB8GA1UdJQQYMBYGCCsGAQUFBwMEBgorBgEEAYI3CgMM
MCkGCSsGAQQBgjcVCgQcMBowCgYIKwYBBQUHAwQwDAYKKwYBBAGCNwoDDDBPBgNVHREESDBGoCkG
CisGAQQBgjcUAgOgGwwZZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbYEZZWxlbmEucmVzaGV0b3Zh
QGludGVsLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEAod197fPvlvz23dBvvgrjTi/LUl8J8o1fmbNG
YjdquDdvPNDJ4FL8t9MpeqRc+63IgyitnmvmiD+lzTibTwDSt2MY9Mck8VJDF60h7dnFFhr3k1B6
yt6cwxvdadOVB0UVwORYw+9LWvnNyhqsMz7YZtEksDkFqtTE7+vZhVDBAjhTTjtMeDz+l9JOWnkx
bJcp/RbxD3m16kRaXq5xHQQ4TfjSRw0GjZq2FafF8yrv+vcVlXYLaKT0DXKT/mCksU7aN4BE5tUx
H55A48baN+GMUI75Gk3rzh/kdNmYtJhYs63kZ8+2u/hkxEc1/wKM5h714s2+dcCznTAuLF6mXVUp
6jCCBckwggSxoAMCAQICEzMAAGceyeUJ4F3k0k4AAAAAZx4wDQYJKoZIhvcNAQEFBQAweTELMAkG
A1UEBhMCVVMxCzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFyYTEaMBgGA1UEChMRSW50
ZWwgQ29ycG9yYXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0Eg
NEEwHhcNMTUwMjEyMjMzMjMzWhcNMTgwMTI3MjMzMjMzWjBFMRkwFwYDVQQDExBSZXNoZXRvdmEs
IEVsZW5hMSgwJgYJKoZIhvcNAQkBFhllbGVuYS5yZXNoZXRvdmFAaW50ZWwuY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAri/J5YL4ajWEtrCcoBdZhjVXDBMbhSL9Sa+oL2KXVmCc
gNNGSkyw9GS6QnkkJq0i7DQooSuI0ymSvWu4dhotg8SytCXuxMH0Q3WRapVw9K73ZDKz3cbFFeps
FiSAjOZ3qflZt5ZiweR/XJq8PNwgTnvajNdC+jXeEPzJV4vEsaHpBmf1xhx2SqkQhJAlb6sa2dgR
bGMLdMKR9SE+3LVNBVDyx39lSY92S+8W4iRLfLpQiN1k2hL10ubFrOchsKz2tQZt9dc7ekZLgmmy
/rxBFY70hsqjiwA5KVestkdZmUkj5bRwOL0sjOqVJaAoNkrNZGVdzpsuVz7ybt/G9ulDWwIDAQAB
o4ICfDCCAngwCwYDVR0PBAQDAgQwMD0GCSsGAQQBgjcVBwQwMC4GJisGAQQBgjcVCIbDjHWEmeVR
g/2BKIWOn1OCkcAJZ4S52UGHhP9OAgFkAgENMEQGCSqGSIb3DQEJDwQ3MDUwDgYIKoZIhvcNAwIC
AgCAMA4GCCqGSIb3DQMEAgIAgDAHBgUrDgMCBzAKBggqhkiG9w0DBzAdBgNVHQ4EFgQUXy7oFxt5
z1FFlAs9UeyFV0CwbF4wHwYDVR0jBBgwFoAUHmkqtNwo/kcYTiELP7ysES/wmPUwZQYDVR0fBF4w
XDBaoFigVoZUaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9DUkwvSW50ZWwlMjBFeHRl
cm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3JsMIGfBggrBgEFBQcBAQSBkjCBjzBp
BggrBgEFBQcwAoZdaHR0cDovL3d3dy5pbnRlbC5jb20vcmVwb3NpdG9yeS9jZXJ0aWZpY2F0ZXMv
SW50ZWwlMjBFeHRlcm5hbCUyMEJhc2ljJTIwSXNzdWluZyUyMENBJTIwNEEuY3J0MCIGCCsGAQUF
BzABhhZodHRwOi8vb2NzcC5pbnRlbC5jb20vMB8GA1UdJQQYMBYGCCsGAQUFBwMEBgorBgEEAYI3
CgMEMCkGCSsGAQQBgjcVCgQcMBowCgYIKwYBBQUHAwQwDAYKKwYBBAGCNwoDBDBPBgNVHREESDBG
oCkGCisGAQQBgjcUAgOgGwwZZWxlbmEucmVzaGV0b3ZhQGludGVsLmNvbYEZZWxlbmEucmVzaGV0
b3ZhQGludGVsLmNvbTANBgkqhkiG9w0BAQUFAAOCAQEAoQFBFD/YZhrNEYTXYuZkKHYE+KJ5cF4m
bYlT8LAVpVtdWYj3uDWMVX0aJASNa01fZNNp8FVacHQkH6RqMAO9zu8q71Y/fTZLq/wTA5mXyiER
9x+U3BvF/WPfnfzxZ1DlamT6EhkPNpR2zkWxHuI5Wz5H0TGYCcmkTJ+z7ERTBV5RvTMcBRFY4F6I
rLlcj+S616J74ohWv6QK8gZ894Jl/D0XyKYRxEhu5VGwfmRC8fXfCDL9v5zLWEcdjwwhkTGWWNB2
WOJYZCer+SGEGCYldn7YSPDOmlxpd8XlO3M1m1gAfsmnU/AjacOYnKyp/THuGC97/7NcWHfkR9vD
z1fq9jGCA/kwggP1AgEBMIGQMHkxCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEUMBIGA1UEBxML
U2FudGEgQ2xhcmExGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9uMSswKQYDVQQDEyJJbnRlbCBF
eHRlcm5hbCBCYXNpYyBJc3N1aW5nIENBIDRCAhMzAAAPeuDTfWPn74vVAAAAAA96MAkGBSsOAwIa
BQCgggI9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTE2MDExODA5
MjIzMlowIwYJKoZIhvcNAQkEMRYEFMThkRuw5kjAKl1vS4gIBn26AILWMIGTBgkqhkiG9w0BCQ8x
gYUwgYIwCwYJYIZIAWUDBAEqMAsGCWCGSAFlAwQBFjAKBggqhkiG9w0DBzALBglghkgBZQMEAQIw
DgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsOAwIaMAsGCWCGSAFlAwQCAzALBglg
hkgBZQMEAgIwCwYJYIZIAWUDBAIBMIGhBgkrBgEEAYI3EAQxgZMwgZAweTELMAkGA1UEBhMCVVMx
CzAJBgNVBAgTAkNBMRQwEgYDVQQHEwtTYW50YSBDbGFyYTEaMBgGA1UEChMRSW50ZWwgQ29ycG9y
YXRpb24xKzApBgNVBAMTIkludGVsIEV4dGVybmFsIEJhc2ljIElzc3VpbmcgQ0EgNEECEzMAAGce
yeUJ4F3k0k4AAAAAZx4wgaMGCyqGSIb3DQEJEAILMYGToIGQMHkxCzAJBgNVBAYTAlVTMQswCQYD
VQQIEwJDQTEUMBIGA1UEBxMLU2FudGEgQ2xhcmExGjAYBgNVBAoTEUludGVsIENvcnBvcmF0aW9u
MSswKQYDVQQDEyJJbnRlbCBFeHRlcm5hbCBCYXNpYyBJc3N1aW5nIENBIDRBAhMzAABnHsnlCeBd
5NJOAAAAAGceMA0GCSqGSIb3DQEBAQUABIIBABZgFKPp+8DiSitsX3N5YWv41mI4elCMvtOavVL6
3XPyKOdulq0XYhYcfJ9XAfLunnd6UflNTXw3XAYqA9vOjKkMoNpGOk5WQ/Z20yCh6+nlbQIxnM62
tG11SgBxHr0ShP7Wl9cuHfxUKUf2TUHwmtjBYCcMgi46aEZo5AzV1Yo5MJEakgOznxdnnk5YpsWP
rd+yNA1QyrAW9k5V9fs5ya2qR+pHGrqjDjWsB37U42Tw1MaqcC+HWcN6r5N8tNb9HnQQv4fG5PsL
sbYJhk71b0PlGBtwikn4/6AjCL+/twSIDwLhHs7ZI7ZjoDgBKOWcoURwaCTWta0q0m6UD6zlXZwA
AAAAAAA=

------=_NextPart_000_002F_01D151E2.8610ED10--
