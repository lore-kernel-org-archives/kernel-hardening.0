Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLvBMWHw_Y8ntmKB3GFqWfmT_E1neUiVQLJAsErLxFLWw@mail.gmail.com>
References: <1476016472.2329.38.camel@cvidal.org> <CE954033-54F3-47AE-9788-B26B9CE45401@gmail.com>
 <1476040182.2329.72.camel@cvidal.org> <20161009193731.GD14666@pc.thejh.net>
 <2236FBA76BA1254E88B949DDB74E612B41BDCAF6@IRSMSX102.ger.corp.intel.com>
 <1476115319.2329.108.camel@cvidal.org> <CAGXu5jLvBMWHw_Y8ntmKB3GFqWfmT_E1neUiVQLJAsErLxFLWw@mail.gmail.com>
From: Gengjia Chen <chengjia4574@gmail.com>
Date: Wed, 12 Oct 2016 11:19:05 +0800
Message-ID: <CAAseMr6oLtJEakAH-0ZC7dNrxqq4F56roNR-j2OuNN-+Jq1kuQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a114b1a3ca007a5053ea274d5
Subject: Re: [kernel-hardening] self introduction
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a114b1a3ca007a5053ea274d5
Content-Type: text/plain; charset=UTF-8

Hi all,

My name is Jiayy (@chengjia4574 <https://twitter.com/chengjia4574>). I am
currently a security researcher in
android and linux kernel. My researches  consist on hunting vulnerabilities
in kernel code (most of them within drivers) and doing exploits using those
vulns.
I had found more than 40 vulnerabilities
<http://www.linkedin.com/in/chen-gengjia-a4411855?trk=nav_responsive_tab_profile>
which were confirmed by Android Security Team
in the past year. I also figured out some way to attack mitigation
solutions of kernel
(such as Bypass PXN <http://en.mosec.org/#speech_bg>).

Those works help me get familiar with the kernel(device tree, memory
management,
network , some features especially those associated with security such as
pxn, selinux, seccomp) and ARM instruction. However, it is not enough to
get
involved in real security development in kernel. Therefore, I am looking
for task
I can accomplish to be involved into real kernel development!  Recently I
found
this project (kernel self protection) and I thought it is so interesting.

I don't know whether I can involve and  where I can begin, I am looking
forward to
your response.


Thanks,

Jiayy

2016-10-11 5:05 GMT+08:00 Kees Cook <keescook@chromium.org>:

> On Mon, Oct 10, 2016 at 9:01 AM, Colin Vidal <colin@cvidal.org> wrote:
> >> This branch to be precise:
> >> https://github.com/ereshetova/linux-stable/tree/hardened_atomic_on_next
> >>
> >> This is where the latest code for linux-next is hosted now and where
> >> we work with David and Hans.
> >> >
> >> > >
> >> > > Please contact me if you have any questions; I'd be glad to help!
> >> >
> >> > I actually have question. :-) As far as I understand, PAX_REFCOUNT
> >> > [1] is mainly a x86-only
> >>
> >> >
> >> > No, PAX_REFCOUNT also supports a bunch of other architectures. As
> >> > far as I can tell from a quick look: ARM, MIPS, PowerPC and SPARC.
> >>
> >> Yes, just in our patch series we only made implementation for x86.
> >> But if you look into Grsecurity/PaX patches, it has support for
> >> others implemented.
> >
> > OK, got it! Thanks for this clarification.
> >
> > So, I will try to start to port PAX_REFCOUNT arm-specific features to
> > hardened_atomic_on_next, and keep you in touch. Is there a deadline?
> > (4.10 / 5.0 merge window?)
>
> You may want to compare notes with Takahiro (CCed) who may have
> started to look at arm64 (and maybe arm too).
>
> As for a deadline, as Elena says, we have no specific target. ("As
> soon as possible.") The only thing around timing that I like to see is
> persistent progress: if a patch series goes up for review, getting
> people to take a look at it, ask questions, make comments, and then
> hopefully within a week or so, the next version comes up. Momentum is
> easier to maintain than to build. ;)
>
> > Just to be sure, the patch [1] and documentation [2] of PaX are still
> > up-to-date, or there is another references I missed?
> >
> > Thanks
> >
> > Colin
> >
> > [1] https://pax.grsecurity.net/pax-linux-3.6-201210022100.patch
>
> This is a quite old version of PaX. (Note the date.) If you want to
> examine PaX separately from Grsecurity (noting differences can be
> enlightening), check here:
>
> https://www.grsecurity.net/~paxguy1/?C=M;O=D
>
> > [2] https://forums.grsecurity.net/viewtopic.php?f=7&t=4173
>
> Yes, outside of reading the code itself, I believe this to be the most
> comprehensive piece of documentation about PAX_REFCOUNT.
>
> -Kees
>
> --
> Kees Cook
> Nexus Security
>

--001a114b1a3ca007a5053ea274d5
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><span style=3D"font-size:14px">Hi all,</span><br style=3D"=
font-size:14px"><br style=3D"font-size:14px"><span style=3D"font-size:14px"=
>My name is Jiayy (</span><a class=3D"gmail-DashboardProfileCard-screenname=
Link gmail-u-linkComplex gmail-u-linkClean" href=3D"https://twitter.com/che=
ngjia4574" style=3D"color:rgb(102,117,127);font-size:12px;padding-right:5px=
;font-family:&#39;helvetica neue&#39;,helvetica,arial,sans-serif;line-heigh=
t:16px;text-decoration:none;background-image:initial;background-size:initia=
l;background-origin:initial;background-clip:initial;background-position:ini=
tial;background-repeat:initial">@<span class=3D"gmail-u-linkComplex-target"=
>chengjia4574</span></a><span style=3D"font-size:14px">). I am currently a =
security researcher in=C2=A0</span><div><span style=3D"font-size:14px">andr=
oid and linux kernel</span><span style=3D"font-size:14px">. My researches=
=C2=A0=C2=A0consist on hunting vulnerabilities</span></div><div><span style=
=3D"font-size:14px">in kernel code (most of them within drivers) and doing =
exploits using those vulns.=C2=A0</span></div><div><span style=3D"font-size=
:14px">I had found more than 40 <a href=3D"http://www.linkedin.com/in/chen-=
gengjia-a4411855?trk=3Dnav_responsive_tab_profile">vulnerabilities</a> whic=
h were confirmed by Android Security Team</span></div><div><span style=3D"f=
ont-size:14px">in the past year. I also figured out some way to attack miti=
gation solutions of kernel=C2=A0</span></div><div><span style=3D"font-size:=
14px">(such as <a href=3D"http://en.mosec.org/#speech_bg">Bypass PXN</a>).=
=C2=A0</span></div><div><span style=3D"font-size:14px"><br></span></div><di=
v><span style=3D"font-size:14px">Those works help me get familiar with the =
kernel(device tree, memory management,</span></div><div><span style=3D"font=
-size:14px">network ,=C2=A0</span><span style=3D"font-size:14px">some featu=
res especially those associated with security such as=C2=A0</span></div><di=
v><span style=3D"font-size:14px">pxn, selinux, seccomp) and ARM instruction=
.=C2=A0</span><span style=3D"font-size:14px">However,=C2=A0</span><span sty=
le=3D"font-size:14px">it is not enough to get=C2=A0</span></div><div><span =
style=3D"font-size:14px">involved in real security </span><span style=3D"fo=
nt-size:14px">development in kernel. Therefore, I am looking for task=C2=A0=
</span></div><div><span style=3D"font-size:14px">I can accomplish to be=C2=
=A0</span><span style=3D"font-size:14px">involved into real=C2=A0</span><sp=
an style=3D"font-size:14px">kernel development!=C2=A0</span><span style=3D"=
font-size:14px">=C2=A0</span><span style=3D"font-size:14px">Recently I foun=
d=C2=A0</span></div><div><span style=3D"font-size:14px">this project (kerne=
l self protection)=C2=A0</span><span style=3D"font-size:14px">and I thought=
 it is so interesting.</span></div><div><span style=3D"font-size:14px"><br>=
</span></div><div><span style=3D"font-size:14px">I don&#39;t know whether I=
 can involve and =C2=A0where I can begin, I am looking forward to</span></d=
iv><div><span style=3D"font-size:14px">your response.</span></div><div>=C2=
=A0</div><div><br style=3D"font-size:14px"><span style=3D"font-size:14px">T=
hanks,</span><br style=3D"font-size:14px"><br style=3D"font-size:14px"><spa=
n style=3D"font-size:14px">Jiayy</span></div></div><div class=3D"gmail_extr=
a"><br><div class=3D"gmail_quote">2016-10-11 5:05 GMT+08:00 Kees Cook <span=
 dir=3D"ltr">&lt;<a href=3D"mailto:keescook@chromium.org" target=3D"_blank"=
>keescook@chromium.org</a>&gt;</span>:<br><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><s=
pan class=3D"">On Mon, Oct 10, 2016 at 9:01 AM, Colin Vidal &lt;<a href=3D"=
mailto:colin@cvidal.org">colin@cvidal.org</a>&gt; wrote:<br>
&gt;&gt; This branch to be precise:<br>
&gt;&gt; <a href=3D"https://github.com/ereshetova/linux-stable/tree/hardene=
d_atomic_on_next" rel=3D"noreferrer" target=3D"_blank">https://github.com/e=
reshetova/<wbr>linux-stable/tree/hardened_<wbr>atomic_on_next</a><br>
&gt;&gt;<br>
&gt;&gt; This is where the latest code for linux-next is hosted now and whe=
re<br>
&gt;&gt; we work with David and Hans.<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; &gt;<br>
&gt;&gt; &gt; &gt; Please contact me if you have any questions; I&#39;d be =
glad to help!<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; I actually have question. :-) As far as I understand, PAX_REF=
COUNT<br>
&gt;&gt; &gt; [1] is mainly a x86-only<br>
&gt;&gt;<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; No, PAX_REFCOUNT also supports a bunch of other architectures=
. As<br>
&gt;&gt; &gt; far as I can tell from a quick look: ARM, MIPS, PowerPC and S=
PARC.<br>
&gt;&gt;<br>
&gt;&gt; Yes, just in our patch series we only made implementation for x86.=
<br>
&gt;&gt; But if you look into Grsecurity/PaX patches, it has support for<br=
>
&gt;&gt; others implemented.<br>
&gt;<br>
&gt; OK, got it! Thanks for this clarification.<br>
&gt;<br>
&gt; So, I will try to start to port PAX_REFCOUNT arm-specific features to<=
br>
&gt; hardened_atomic_on_next, and keep you in touch. Is there a deadline?<b=
r>
&gt; (4.10 / 5.0 merge window?)<br>
<br>
</span>You may want to compare notes with Takahiro (CCed) who may have<br>
started to look at arm64 (and maybe arm too).<br>
<br>
As for a deadline, as Elena says, we have no specific target. (&quot;As<br>
soon as possible.&quot;) The only thing around timing that I like to see is=
<br>
persistent progress: if a patch series goes up for review, getting<br>
people to take a look at it, ask questions, make comments, and then<br>
hopefully within a week or so, the next version comes up. Momentum is<br>
easier to maintain than to build. ;)<br>
<span class=3D""><br>
&gt; Just to be sure, the patch [1] and documentation [2] of PaX are still<=
br>
&gt; up-to-date, or there is another references I missed?<br>
&gt;<br>
&gt; Thanks<br>
&gt;<br>
&gt; Colin<br>
&gt;<br>
&gt; [1] <a href=3D"https://pax.grsecurity.net/pax-linux-3.6-201210022100.p=
atch" rel=3D"noreferrer" target=3D"_blank">https://pax.grsecurity.net/<wbr>=
pax-linux-3.6-201210022100.<wbr>patch</a><br>
<br>
</span>This is a quite old version of PaX. (Note the date.) If you want to<=
br>
examine PaX separately from Grsecurity (noting differences can be<br>
enlightening), check here:<br>
<br>
<a href=3D"https://www.grsecurity.net/~paxguy1/?C=3DM;O=3DD" rel=3D"norefer=
rer" target=3D"_blank">https://www.grsecurity.net/~<wbr>paxguy1/?C=3DM;O=3D=
D</a><br>
<br>
&gt; [2] <a href=3D"https://forums.grsecurity.net/viewtopic.php?f=3D7&amp;t=
=3D4173" rel=3D"noreferrer" target=3D"_blank">https://forums.grsecurity.net=
/<wbr>viewtopic.php?f=3D7&amp;t=3D4173</a><br>
<br>
Yes, outside of reading the code itself, I believe this to be the most<br>
comprehensive piece of documentation about PAX_REFCOUNT.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Nexus Security<br>
</div></div></blockquote></div><br></div>

--001a114b1a3ca007a5053ea274d5--
