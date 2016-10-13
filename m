Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+PLo0AHDWiG9pWhzS9fFgsJYNvbn96G=2tQq==9GPpaw@mail.gmail.com>
References: <1476016472.2329.38.camel@cvidal.org> <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
 <1476115319.2329.108.camel@cvidal.org> <CAGXu5jLvBMWHw_Y8ntmKB3GFqWfmT_E1neUiVQLJAsErLxFLWw@mail.gmail.com>
 <CAAseMr6oLtJEakAH-0ZC7dNrxqq4F56roNR-j2OuNN-+Jq1kuQ@mail.gmail.com> <CAGXu5j+PLo0AHDWiG9pWhzS9fFgsJYNvbn96G=2tQq==9GPpaw@mail.gmail.com>
From: Gengjia Chen <chengjia4574@gmail.com>
Date: Thu, 13 Oct 2016 19:14:55 +0800
Message-ID: <CAAseMr4zGyww6vgjkuqHB-kK7qQFBvDU8ZJkXqugoLEOxP0svw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a113fa8483499f4053ebd38e2
Subject: Re: [kernel-hardening] self introduction
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a113fa8483499f4053ebd38e2
Content-Type: text/plain; charset=UTF-8

> In your research have you seen a common kind of bug that results in
> the vulnerabilities you find?

No,
Most of those issues are caused by the lack of checking of  user input
length
in copy_xx_user functions or afterwards in memcpy functions,
however, looking into the details,
they vary among different functions in different files.

> Is there anything that would have
> significantly made exploitation more difficult in the things you
> worked on?

Yes!

I mostly exploit buffer overflow vulns by overwrite function pointers (such
as
pointers in file_operations) of a global object or a heap object
to redirect execution (and if PXN is enable, we simply use rop gadgets).
Therefore mitigation solutions of Function_pointer_overwrite
<https://kernsec.org/wiki/index.php/Exploit_Methods/Function_pointer_overwrite>
would
make such kind of exploitation much more diffcult.
But I don't know if you have let all the pointers "const".

Becsides, ret2dir is a common way to exploit  UAF vulns
so  I think solutions like XPFO is a way  to make
those kind of exploitation more diffcult.

Right now KALSR is still disable in most android devices,
so it is easy to get kernel symbol address,
however if KALSR is enable, it may make exploitation more diffcult.

> Are you interested mostly in ARM-specific things?

I am famillar with ARM-specific things mostly, but I can also accept
x86/x64 tasks.

> Are you interested in kernel-assisted userspace defenses too?

What dose that mean ?  something like seccomp ?

2016-10-13 6:31 GMT+08:00 Kees Cook <keescook@chromium.org>:

> On Tue, Oct 11, 2016 at 8:19 PM, Gengjia Chen <chengjia4574@gmail.com>
> wrote:
> > Hi all,
>
> Hi, welcome!
>
> > My name is Jiayy (@chengjia4574). I am currently a security researcher in
> > android and linux kernel. My researches  consist on hunting
> vulnerabilities
> > in kernel code (most of them within drivers) and doing exploits using
> those
> > vulns.
> > I had found more than 40 vulnerabilities which were confirmed by Android
> > Security Team
> > in the past year. I also figured out some way to attack mitigation
> solutions
> > of kernel
> > (such as Bypass PXN).
>
> In your research have you seen a common kind of bug that results in
> the vulnerabilities you find? Is there anything that would have
> significantly made exploitation more difficult in the things you
> worked on?
>
> > Those works help me get familiar with the kernel(device tree, memory
> > management,
> > network , some features especially those associated with security such as
> > pxn, selinux, seccomp) and ARM instruction. However, it is not enough to
> get
> > involved in real security development in kernel. Therefore, I am looking
> for
> > task
> > I can accomplish to be involved into real kernel development!  Recently I
> > found
> > this project (kernel self protection) and I thought it is so interesting.
> >
> > I don't know whether I can involve and  where I can begin, I am looking
> > forward to
> > your response.
>
> Are you interested mostly in ARM-specific things? Are you interested
> in kernel-assisted userspace defenses too?
>
> -Kees
>
> --
> Kees Cook
> Nexus Security
>

--001a113fa8483499f4053ebd38e2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div id=3D"gmail-magicdomid1667" class=3D"gmail-ace-line g=
mail-gutter-author-1155855 gmail-locate gmail-lineguid-p3kjYWsGvJNgWc3h" st=
yle=3D"margin:0px;padding:0px 100px;border-left-width:3px;border-left-style=
:solid;border-left-color:transparent;word-wrap:break-word;outline:none;colo=
r:rgb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&#39;pingfang =
sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsoft ya=
hei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,hei=
ti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-height:24.9333px"=
><span class=3D"gmail-author-1155855 gmail-font-size-3" style=3D"font-size:=
11pt">&gt; In your research have you seen a common kind of bug that results=
 in</span></div><div id=3D"gmail-magicdomid1668" class=3D"gmail-ace-line gm=
ail-gutter-author-1155855 gmail-locate gmail-lineguid-rzMzlGcI88kOpzxn" sty=
le=3D"margin:0px;padding:0px 100px;border-left-width:3px;border-left-style:=
solid;border-left-color:transparent;word-wrap:break-word;outline:none;color=
:rgb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&#39;pingfang s=
c&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsoft yah=
ei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heit=
i,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-height:24.9333px">=
<span class=3D"gmail-author-1155855 gmail-font-size-3" style=3D"font-size:1=
1pt">&gt; the vulnerabilities you find?=C2=A0</span></div><div id=3D"gmail-=
magicdomid282" class=3D"gmail-ace-line gmail-gutter-author-1155855" style=
=3D"margin:0px;padding:0px 100px;border-left-width:3px;border-left-style:so=
lid;border-left-color:transparent;word-wrap:break-word;outline:none;color:r=
gb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&#39;pingfang sc&=
#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsoft yahei=
&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=
=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-height:24.9333px"><s=
pan style=3D"display:block"><br></span><span style=3D"display:block">No,</s=
pan><span style=3D"display:block"><br></span></div><div id=3D"gmail-magicdo=
mid1839" class=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-locate g=
mail-lineguid-KBc1vNIFRXuaFCrN" style=3D"margin:0px;padding:0px 100px;borde=
r-left-width:3px;border-left-style:solid;border-left-color:transparent;word=
-wrap:break-word;outline:none;color:rgb(51,51,51);font-family:-apple-system=
,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hirag=
ino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=
=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-s=
ize:14.6667px;line-height:24.9333px"><span class=3D"gmail-author-1155855 gm=
ail-font-size-3" style=3D"font-size:11pt">Most of those issues are caused b=
y the lack of checking of=C2=A0 user input length</span></div><div id=3D"gm=
ail-magicdomid1841" class=3D"gmail-ace-line gmail-gutter-author-1155855 gma=
il-locate gmail-lineguid-EbCRTHxnRbzwjL7l" style=3D"margin:0px;padding:0px =
100px;border-left-width:3px;border-left-style:solid;border-left-color:trans=
parent;word-wrap:break-word;outline:none;color:rgb(51,51,51);font-family:-a=
pple-system,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial=
,&#39;hiragino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=
=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-ser=
if;font-size:14.6667px;line-height:24.9333px"><span class=3D"gmail-author-1=
155855 gmail-font-size-3" style=3D"font-size:11pt">in copy_xx_user function=
s or=C2=A0</span><span class=3D"gmail-author-1155855">afterwards in memcpy =
functions</span><span class=3D"gmail-author-1155855 gmail-font-size-3" styl=
e=3D"font-size:11pt">,=C2=A0</span></div><div id=3D"gmail-magicdomid1679" c=
lass=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-locate gmail-lineg=
uid-Kt8rTo8ESK2f5OMq" style=3D"margin:0px;padding:0px 100px;border-left-wid=
th:3px;border-left-style:solid;border-left-color:transparent;word-wrap:brea=
k-word;outline:none;color:rgb(51,51,51);font-family:-apple-system,blinkmacs=
ystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans g=
b&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsu=
n,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667p=
x;line-height:24.9333px"><span class=3D"gmail-author-1155855 gmail-font-siz=
e-3" style=3D"font-size:11pt">however, looking into the details,=C2=A0</spa=
n></div><div id=3D"gmail-magicdomid1680" class=3D"gmail-ace-line gmail-gutt=
er-author-1155855 gmail-locate gmail-lineguid-d8Kf1lo6w7YvTQmA" style=3D"ma=
rgin:0px;padding:0px 100px;border-left-width:3px;border-left-style:solid;bo=
rder-left-color:transparent;word-wrap:break-word;outline:none;color:rgb(51,=
51,51);font-family:-apple-system,blinkmacsystemfont,&#39;pingfang sc&#39;,h=
elvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsoft yahei&#39;,=
=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=
=91=E4=BD=93,sans-serif;font-size:14.6667px;line-height:24.9333px"><span cl=
ass=3D"gmail-author-1155855 gmail-font-size-3" style=3D"font-size:11pt">the=
y v</span><span class=3D"gmail-author-1155855">ary among different function=
s in different files.</span></div><div id=3D"gmail-magicdomid511" class=3D"=
gmail-ace-line" style=3D"margin:0px;padding:0px 100px;border-left-width:3px=
;border-left-style:solid;border-left-color:transparent;word-wrap:break-word=
;outline:none;color:rgb(51,51,51);font-family:-apple-system,blinkmacsystemf=
ont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;=
,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=
=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;lin=
e-height:24.9333px"><br style=3D"margin-top:0px"></div><div id=3D"gmail-mag=
icdomid1670" class=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-loca=
te gmail-lineguid-hpcvAtwbql1bRQBn" style=3D"margin:0px;padding:0px 100px;b=
order-left-width:3px;border-left-style:solid;border-left-color:transparent;=
word-wrap:break-word;outline:none;color:rgb(51,51,51);font-family:-apple-sy=
stem,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;h=
iragino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=
=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;fon=
t-size:14.6667px;line-height:24.9333px"><span class=3D"gmail-author-1155855=
 gmail-font-size-3" style=3D"font-size:11pt">&gt; Is there anything that wo=
uld have</span></div><div id=3D"gmail-magicdomid1672" class=3D"gmail-ace-li=
ne gmail-gutter-author-1155855 gmail-locate gmail-lineguid-JSAKDSxjFJ2HPWBi=
" style=3D"margin:0px;padding:0px 100px;border-left-width:3px;border-left-s=
tyle:solid;border-left-color:transparent;word-wrap:break-word;outline:none;=
color:rgb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&#39;pingf=
ang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsof=
t yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93=
,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-height:24.933=
3px"><span class=3D"gmail-author-1155855 gmail-font-size-3" style=3D"font-s=
ize:11pt">&gt; significantly made exploitation more difficult in the things=
 you</span></div><div id=3D"gmail-magicdomid1674" class=3D"gmail-ace-line g=
mail-gutter-author-1155855 gmail-locate gmail-lineguid-mB3LgW7FnB3BmDSw" st=
yle=3D"margin:0px;padding:0px 100px;border-left-width:3px;border-left-style=
:solid;border-left-color:transparent;word-wrap:break-word;outline:none;colo=
r:rgb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&#39;pingfang =
sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsoft ya=
hei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,hei=
ti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-height:24.9333px"=
><span class=3D"gmail-author-1155855 gmail-font-size-3" style=3D"font-size:=
11pt">&gt; worked on?</span></div><div id=3D"gmail-magicdomid1682" class=3D=
"gmail-ace-line" style=3D"margin:0px;padding:0px 100px;border-left-width:3p=
x;border-left-style:solid;border-left-color:transparent;word-wrap:break-wor=
d;outline:none;color:rgb(51,51,51);font-family:-apple-system,blinkmacsystem=
font,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39=
;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=
=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;lin=
e-height:24.9333px"><br style=3D"margin-top:0px"></div><div id=3D"gmail-mag=
icdomid1895" class=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-loca=
te gmail-lineguid-DBfJJg6hkMnNkI2w" style=3D"margin:0px;padding:0px 100px;b=
order-left-width:3px;border-left-style:solid;border-left-color:transparent;=
word-wrap:break-word;outline:none;color:rgb(51,51,51);font-family:-apple-sy=
stem,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;h=
iragino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=
=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;fon=
t-size:14.6667px;line-height:24.9333px"><span class=3D"gmail-author-1155855=
 gmail-font-size-3" style=3D"font-size:11pt">Yes!=C2=A0=C2=A0</span></div><=
div id=3D"gmail-magicdomid1896" class=3D"gmail-ace-line" style=3D"margin:0p=
x;padding:0px 100px;border-left-width:3px;border-left-style:solid;border-le=
ft-color:transparent;word-wrap:break-word;outline:none;color:rgb(51,51,51);=
font-family:-apple-system,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetic=
a,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=
=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=
=BD=93,sans-serif;font-size:14.6667px;line-height:24.9333px"><br style=3D"m=
argin-top:0px"></div><div id=3D"gmail-magicdomid1940" class=3D"gmail-ace-li=
ne gmail-gutter-author-1155855 gmail-locate gmail-lineguid-KgVMfHsUFG7eoJot=
 gmail-lineguid-7Kkg41ZXaFnCfeR4 gmail-lineguid-xCPEpJPzShia3Bzt" style=3D"=
margin:0px;padding:0px 100px;border-left-width:3px;border-left-style:solid;=
border-left-color:transparent;word-wrap:break-word;outline:none;color:rgb(5=
1,51,51);font-family:-apple-system,blinkmacsystemfont,&#39;pingfang sc&#39;=
,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsoft yahei&#39=
;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=
=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-height:24.9333px"><span=
 class=3D"gmail-author-1155855 gmail-font-size-3" style=3D"font-size:11pt">=
I mostly exploit buffer overflow vulns by overwrite function pointers (such=
 as=C2=A0=C2=A0</span></div><div id=3D"gmail-magicdomid1941" class=3D"gmail=
-ace-line gmail-gutter-author-1155855 gmail-locate gmail-lineguid-YFcs8qFtH=
D5P1Gm4" style=3D"margin:0px;padding:0px 100px;border-left-width:3px;border=
-left-style:solid;border-left-color:transparent;word-wrap:break-word;outlin=
e:none;color:rgb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&#3=
9;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;m=
icrosoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=
=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-heig=
ht:24.9333px"><span class=3D"gmail-author-1155855 gmail-font-size-3" style=
=3D"font-size:11pt">pointers in file_operations) of a global object or a he=
ap object=C2=A0</span></div><div id=3D"gmail-magicdomid1852" class=3D"gmail=
-ace-line gmail-gutter-author-1155855 gmail-locate gmail-lineguid-MlLvWwKmr=
3MvJEVR" style=3D"margin:0px;padding:0px 100px;border-left-width:3px;border=
-left-style:solid;border-left-color:transparent;word-wrap:break-word;outlin=
e:none;color:rgb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&#3=
9;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;m=
icrosoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=
=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-heig=
ht:24.9333px"><span class=3D"gmail-author-1155855 gmail-font-size-3" style=
=3D"font-size:11pt">to redirect execution (and if PXN is enable, we simply =
use rop gadgets).=C2=A0</span></div><div id=3D"gmail-magicdomid1855" class=
=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-locate gmail-lineguid-=
prqXgFqawk95rKOC" style=3D"margin:0px;padding:0px 100px;border-left-width:3=
px;border-left-style:solid;border-left-color:transparent;word-wrap:break-wo=
rd;outline:none;color:rgb(51,51,51);font-family:-apple-system,blinkmacsyste=
mfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#3=
9;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=
=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;=
line-height:24.9333px"><span class=3D"gmail-author-1155855 gmail-font-size-=
3" style=3D"font-size:11pt">Therefore mitigation solutions of=C2=A0</span><=
span class=3D"gmail-author-1155855 gmail-font-color-13 gmail-font-size-2 gm=
ail-link-block gmail-url-K8zplcF4gUcsRpqI gmail-url" style=3D"color:rgb(255=
,255,255);font-size:10pt"><font color=3D"#ffffff"><font style=3D"font-size:=
10pt"><a href=3D"https://kernsec.org/wiki/index.php/Exploit_Methods/Functio=
n_pointer_overwrite" style=3D"outline:none;text-decoration:none;color:rgb(1=
12,177,231);background-image:initial;background-color:transparent;backgroun=
d-size:initial;background-origin:initial;background-clip:initial;background=
-position:initial;background-repeat:initial">Function_pointer_overwrite</a>=
</font></font></span><span class=3D"gmail-author-1155855 gmail-font-size-3"=
 style=3D"font-size:11pt">=C2=A0 would=C2=A0</span></div><div id=3D"gmail-m=
agicdomid1952" class=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-lo=
cate gmail-lineguid-aZtYlZbRzSJYpeIO" style=3D"margin:0px;padding:0px 100px=
;border-left-width:3px;border-left-style:solid;border-left-color:transparen=
t;word-wrap:break-word;outline:none;color:rgb(51,51,51);font-family:-apple-=
system,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39=
;hiragino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=
=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;=
font-size:14.6667px;line-height:24.9333px"><span class=3D"gmail-author-1155=
855 gmail-font-size-3" style=3D"font-size:11pt">make such kind of exploitat=
ion much more diffcult.=C2=A0=C2=A0</span></div><div id=3D"gmail-magicdomid=
1956" class=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-locate gmai=
l-lineguid-gqlkd5o05IGngxa1" style=3D"margin:0px;padding:0px 100px;border-l=
eft-width:3px;border-left-style:solid;border-left-color:transparent;word-wr=
ap:break-word;outline:none;color:rgb(51,51,51);font-family:-apple-system,bl=
inkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino=
 sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=
=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size=
:14.6667px;line-height:24.9333px"><span class=3D"gmail-author-1155855 gmail=
-font-size-3" style=3D"font-size:11pt">But I don&#39;t know if you have let=
 all the pointers &quot;const&quot;.</span></div><div id=3D"gmail-magicdomi=
d1957" class=3D"gmail-ace-line" style=3D"margin:0px;padding:0px 100px;borde=
r-left-width:3px;border-left-style:solid;border-left-color:transparent;word=
-wrap:break-word;outline:none;color:rgb(51,51,51);font-family:-apple-system=
,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hirag=
ino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=
=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-s=
ize:14.6667px;line-height:24.9333px"><br style=3D"margin-top:0px"></div><di=
v id=3D"gmail-magicdomid1872" class=3D"gmail-ace-line gmail-gutter-author-1=
155855 gmail-locate gmail-lineguid-a3EbEf8VdlHMTM4Q" style=3D"margin:0px;pa=
dding:0px 100px;border-left-width:3px;border-left-style:solid;border-left-c=
olor:transparent;word-wrap:break-word;outline:none;color:rgb(51,51,51);font=
-family:-apple-system,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica,ta=
homa,arial,&#39;hiragino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=
=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=
=93,sans-serif;font-size:14.6667px;line-height:24.9333px"><span class=3D"gm=
ail-author-1155855 gmail-font-size-3" style=3D"font-size:11pt">Becsides, re=
t2dir is a common way to exploit=C2=A0 UAF vulns=C2=A0</span></div><div id=
=3D"gmail-magicdomid1892" class=3D"gmail-ace-line gmail-gutter-author-11558=
55 gmail-locate gmail-lineguid-qTQBIZQUDHLOu7P6" style=3D"margin:0px;paddin=
g:0px 100px;border-left-width:3px;border-left-style:solid;border-left-color=
:transparent;word-wrap:break-word;outline:none;color:rgb(51,51,51);font-fam=
ily:-apple-system,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma=
,arial,&#39;hiragino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=
=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sa=
ns-serif;font-size:14.6667px;line-height:24.9333px"><span class=3D"gmail-au=
thor-1155855 gmail-font-size-3" style=3D"font-size:11pt">so=C2=A0 I think s=
olutions like XPFO is a way=C2=A0 to make=C2=A0</span></div><div id=3D"gmai=
l-magicdomid1958" class=3D"gmail-ace-line gmail-gutter-author-1155855 gmail=
-locate gmail-lineguid-GUmeactMDrubhIP6" style=3D"margin:0px;padding:0px 10=
0px;border-left-width:3px;border-left-style:solid;border-left-color:transpa=
rent;word-wrap:break-word;outline:none;color:rgb(51,51,51);font-family:-app=
le-system,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&=
#39;hiragino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=
=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-ser=
if;font-size:14.6667px;line-height:24.9333px"><span class=3D"gmail-author-1=
155855 gmail-font-size-3" style=3D"font-size:11pt">those kind of exploitati=
on more diffcult.</span></div><div id=3D"gmail-magicdomid1960" class=3D"gma=
il-ace-line" style=3D"margin:0px;padding:0px 100px;border-left-width:3px;bo=
rder-left-style:solid;border-left-color:transparent;word-wrap:break-word;ou=
tline:none;color:rgb(51,51,51);font-family:-apple-system,blinkmacsystemfont=
,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#=
39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=
=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-h=
eight:24.9333px"><br style=3D"margin-top:0px"></div><div id=3D"gmail-magicd=
omid1961" class=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-locate =
gmail-lineguid-Bu3DXRWX9snoureB" style=3D"margin:0px;padding:0px 100px;bord=
er-left-width:3px;border-left-style:solid;border-left-color:transparent;wor=
d-wrap:break-word;outline:none;color:rgb(51,51,51);font-family:-apple-syste=
m,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hira=
gino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=
=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-s=
ize:14.6667px;line-height:24.9333px"><span class=3D"gmail-author-1155855 gm=
ail-font-size-3" style=3D"font-size:11pt">Right now KALSR is still disable =
in most android devices,=C2=A0</span></div><div id=3D"gmail-magicdomid1962"=
 class=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-locate gmail-lin=
eguid-hmSlEbQ19ZGjqiat" style=3D"margin:0px;padding:0px 100px;border-left-w=
idth:3px;border-left-style:solid;border-left-color:transparent;word-wrap:br=
eak-word;outline:none;color:rgb(51,51,51);font-family:-apple-system,blinkma=
csystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans=
 gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,sim=
sun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.666=
7px;line-height:24.9333px"><span class=3D"gmail-author-1155855 gmail-font-s=
ize-3" style=3D"font-size:11pt">so it is easy to get kernel symbol address,=
</span></div><div id=3D"gmail-magicdomid1963" class=3D"gmail-ace-line gmail=
-gutter-author-1155855 gmail-locate gmail-lineguid-5m6wppoWhijfPJIg" style=
=3D"margin:0px;padding:0px 100px;border-left-width:3px;border-left-style:so=
lid;border-left-color:transparent;word-wrap:break-word;outline:none;color:r=
gb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&#39;pingfang sc&=
#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsoft yahei=
&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=
=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-height:24.9333px"><s=
pan class=3D"gmail-author-1155855 gmail-font-size-3" style=3D"font-size:11p=
t">however if KALSR is enable, it may make exploitation more diffcult.=C2=
=A0</span></div><div id=3D"gmail-magicdomid1648" class=3D"gmail-ace-line gm=
ail-font-color-13 gmail-font-size-2 gmail-gutter-author-1155855" style=3D"m=
argin:0px;padding:0px 100px;border-left-width:3px;border-left-style:solid;b=
order-left-color:transparent;word-wrap:break-word;outline:none;color:rgb(25=
5,255,255);font-size:10pt;font-family:-apple-system,blinkmacsystemfont,&#39=
;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;mi=
crosoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=
=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif"><span style=3D"display:block"><=
br style=3D"margin-top:0px"></span></div><div id=3D"gmail-magicdomid1772" c=
lass=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-locate gmail-lineg=
uid-gaiBYCLat6ZycXBD" style=3D"margin:0px;padding:0px 100px;border-left-wid=
th:3px;border-left-style:solid;border-left-color:transparent;word-wrap:brea=
k-word;outline:none;color:rgb(51,51,51);font-family:-apple-system,blinkmacs=
ystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans g=
b&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsu=
n,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667p=
x;line-height:24.9333px"><span class=3D"gmail-author-1155855 gmail-font-siz=
e-3" style=3D"font-size:11pt">&gt; Are you interested mostly in ARM-specifi=
c things?=C2=A0</span></div><div id=3D"gmail-magicdomid1212" class=3D"gmail=
-ace-line" style=3D"margin:0px;padding:0px 100px;border-left-width:3px;bord=
er-left-style:solid;border-left-color:transparent;word-wrap:break-word;outl=
ine:none;color:rgb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&=
#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39=
;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=
=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-heig=
ht:24.9333px"><br style=3D"margin-top:0px"></div><div id=3D"gmail-magicdomi=
d1353" class=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-locate gma=
il-lineguid-FbwDjSxvOj8ie258" style=3D"margin:0px;padding:0px 100px;border-=
left-width:3px;border-left-style:solid;border-left-color:transparent;word-w=
rap:break-word;outline:none;color:rgb(51,51,51);font-family:-apple-system,b=
linkmacsystemfont,&#39;pingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragin=
o sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=
=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size=
:14.6667px;line-height:24.9333px"><span class=3D"gmail-author-1155855">I am=
 famillar with ARM-specific things mostly, but I can also accept x86/x64 ta=
sks.=C2=A0</span></div><div id=3D"gmail-magicdomid1300" class=3D"gmail-ace-=
line" style=3D"margin:0px;padding:0px 100px;border-left-width:3px;border-le=
ft-style:solid;border-left-color:transparent;word-wrap:break-word;outline:n=
one;color:rgb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&#39;p=
ingfang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;micr=
osoft yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=
=BD=93,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-height:=
24.9333px"><br style=3D"margin-top:0px"></div><div id=3D"gmail-magicdomid17=
74" class=3D"gmail-ace-line gmail-gutter-author-1155855 gmail-locate gmail-=
lineguid-eRZd1gIUevkd49Fi gmail-lineguid-LJCpPdRXiGUShfCo" style=3D"margin:=
0px;padding:0px 100px;border-left-width:3px;border-left-style:solid;border-=
left-color:transparent;word-wrap:break-word;outline:none;color:rgb(51,51,51=
);font-family:-apple-system,blinkmacsystemfont,&#39;pingfang sc&#39;,helvet=
ica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=
=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=
=E4=BD=93,sans-serif;font-size:14.6667px;line-height:24.9333px"><span class=
=3D"gmail-author-1155855 gmail-font-size-3" style=3D"font-size:11pt">&gt; A=
re you interested in kernel-assisted userspace defenses too?</span></div><d=
iv id=3D"gmail-magicdomid1309" class=3D"gmail-ace-line" style=3D"margin:0px=
;padding:0px 100px;border-left-width:3px;border-left-style:solid;border-lef=
t-color:transparent;word-wrap:break-word;outline:none;color:rgb(51,51,51);f=
ont-family:-apple-system,blinkmacsystemfont,&#39;pingfang sc&#39;,helvetica=
,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsoft yahei&#39;,=E5=BE=
=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93,heiti,=E9=BB=91=E4=
=BD=93,sans-serif;font-size:14.6667px;line-height:24.9333px"><br style=3D"m=
argin-top:0px"></div><div id=3D"gmail-magicdomid1349" class=3D"gmail-ace-li=
ne gmail-gutter-author-1155855 gmail-locate gmail-lineguid-yGzkhi5o010z0zmJ=
" style=3D"margin:0px;padding:0px 100px;border-left-width:3px;border-left-s=
tyle:solid;border-left-color:transparent;word-wrap:break-word;outline:none;=
color:rgb(51,51,51);font-family:-apple-system,blinkmacsystemfont,&#39;pingf=
ang sc&#39;,helvetica,tahoma,arial,&#39;hiragino sans gb&#39;,&#39;microsof=
t yahei&#39;,=E5=BE=AE=E8=BD=AF=E9=9B=85=E9=BB=91,simsun,=E5=AE=8B=E4=BD=93=
,heiti,=E9=BB=91=E4=BD=93,sans-serif;font-size:14.6667px;line-height:24.933=
3px"><span class=3D"gmail-author-1155855">What dose that mean ?=C2=A0 somet=
hing like seccomp ?</span></div></div><div class=3D"gmail_extra"><br><div c=
lass=3D"gmail_quote">2016-10-13 6:31 GMT+08:00 Kees Cook <span dir=3D"ltr">=
&lt;<a href=3D"mailto:keescook@chromium.org" target=3D"_blank">keescook@chr=
omium.org</a>&gt;</span>:<br><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Tue, Oct 11,=
 2016 at 8:19 PM, Gengjia Chen &lt;<a href=3D"mailto:chengjia4574@gmail.com=
">chengjia4574@gmail.com</a>&gt; wrote:<br>
&gt; Hi all,<br>
<br>
Hi, welcome!<br>
<span class=3D""><br>
&gt; My name is Jiayy (@chengjia4574). I am currently a security researcher=
 in<br>
&gt; android and linux kernel. My researches=C2=A0 consist on hunting vulne=
rabilities<br>
&gt; in kernel code (most of them within drivers) and doing exploits using =
those<br>
&gt; vulns.<br>
&gt; I had found more than 40 vulnerabilities which were confirmed by Andro=
id<br>
&gt; Security Team<br>
&gt; in the past year. I also figured out some way to attack mitigation sol=
utions<br>
&gt; of kernel<br>
&gt; (such as Bypass PXN).<br>
<br>
</span>In your research have you seen a common kind of bug that results in<=
br>
the vulnerabilities you find? Is there anything that would have<br>
significantly made exploitation more difficult in the things you<br>
worked on?<br>
<span class=3D""><br>
&gt; Those works help me get familiar with the kernel(device tree, memory<b=
r>
&gt; management,<br>
&gt; network , some features especially those associated with security such=
 as<br>
&gt; pxn, selinux, seccomp) and ARM instruction. However, it is not enough =
to get<br>
&gt; involved in real security development in kernel. Therefore, I am looki=
ng for<br>
&gt; task<br>
&gt; I can accomplish to be involved into real kernel development!=C2=A0 Re=
cently I<br>
&gt; found<br>
&gt; this project (kernel self protection) and I thought it is so interesti=
ng.<br>
&gt;<br>
&gt; I don&#39;t know whether I can involve and=C2=A0 where I can begin, I =
am looking<br>
&gt; forward to<br>
&gt; your response.<br>
<br>
</span>Are you interested mostly in ARM-specific things? Are you interested=
<br>
in kernel-assisted userspace defenses too?<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Nexus Security<br>
</div></div></blockquote></div><br></div>

--001a113fa8483499f4053ebd38e2--
