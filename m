MIME-Version: 1.0
References: <CALS6=qVgYYxcjv8Fj4pdPJ0Z_fUceTV60DtKwOhFkSz4HZohxg@mail.gmail.com>
 <CAGXu5jKPeXWVV0480xt_5K4O2x8iA2xRf_9t8Rr0yG6szYebhQ@mail.gmail.com>
 <CALS6=qWNeRM18kgtvpVZw2O6+Zt5eJdOQ2cXbDCbEkBCeRSe4A@mail.gmail.com> <2236FBA76BA1254E88B949DDB74E612B8D6450A2@IRSMSX102.ger.corp.intel.com>
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B8D6450A2@IRSMSX102.ger.corp.intel.com>
From: Carter Cheng <cartercheng@gmail.com>
Date: Wed, 26 Sep 2018 22:39:22 +0800
Message-ID: <CALS6=qUJh5PeyXK5jwakcbr=iJKWC1pM70KFHg_DKkUgcsbtTg@mail.gmail.com>
Subject: Re: temporal and spatial locality in the kernel
Content-Type: multipart/alternative; boundary="000000000000db78cc0576c730ef"
To: elena.reshetova@intel.com
Cc: kernel-hardening@lists.openwall.com, liljestrandh@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

--000000000000db78cc0576c730ef
Content-Type: text/plain; charset="UTF-8"

Thanks Elena for the offer. I am actually a bit afraid of commiting to
working on this and then underdelivering though I think I might be able to
give it a serious attempt if nothing comparable ends up in the kernel in a
couple months. I would love to hear what you have learned about the spatial
safety issue from working on it. I am actually curious how a gcc plugin
could ever get accepted into the kernel and be actively maintained even
though I think this is the best way to get memory safety into the kernel
since there are potentially gains in terms of maintenance when automation
is used via static analysis.

Regards,

Carter.

On Wed, Sep 26, 2018 at 4:32 PM Reshetova, Elena <elena.reshetova@intel.com>
wrote:

>
> >I suspect any modification would have to be made on the compiler side as
> some sort of compiler plugin since skimming over the papers in the area
> most optimize by doing some sort of dataflow analysis(removing runtime
> checks when not needed). To >produce something like this would require
> reading through some of the literature and open source and constructing the
> compiler transform pass in gcc or clang. Is gcc currently preferred for
> something like this?
>
> Hi,
>
> We have tried to do some of this via gcc plugin and using existing (still
> last year) Intel MPX technology to prevent spatial memory errors in kernel.
> Unfortunately MPX support has been now dropped out of both gcc and kernel,
> so our exercise is more like a past example now.
> However our code is still here:
> https://github.com/ssg-kernel-memory-safety/linux-mpxk
>
> And the paper is here:
> https://onlinelibrary.wiley.com/doi/full/10.1002/spe.2638
>
> If you are interested to continue on this direction, let me know, Hans and
> me can at least share the experience and knowledge we got while doing this
> with you.
>
> Best Regards,
> Elena.
>
> On Sat, Sep 22, 2018 at 2:41 AM Kees Cook <keescook@chromium.org> wrote:
> On Fri, Sep 21, 2018 at 10:25 AM, Carter Cheng <cartercheng@gmail.com>
> wrote:
> > Hi,
>
> Welcome!
>
> > I recently attended a computer security conference for the first time and
> > have developed some interest in kernel hardening issues after one of the
> > presenters demonstrated a kernel exploit based partly around a use after
> > free bug.
> >
> > After scanning the literature a little bit and looking at some papers I
> have
> > encountered before on CCured and Cyclone. I was curious to what extent
> full
> > memory saftety checks are now possible.
>
> CONFIG_KASAN covers a lot of this, but wasn't itself designed for
> "production use". The primary concern, yes, is performance.
>
> > There are many papers going back quite a bit on spatial safety
> > implementations and some on temporal safety but they mainly target user
> > space. I am curious why such things don't exist in the linux kernel at
> least
> > as some sort of compile option. Is the slow down the main concern?
> >
> > It seems recent work has got the performance bound down to 1.29 is this
> > considered too slow for many things?
>
> This sounds lovely! :) I'd be curious to see patches implementing the
> checks you're talking about.
>
> -Kees
>
> --
> Kees Cook
> Pixel Security
>

--000000000000db78cc0576c730ef
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Elena for the offer. I am actually a bit afraid of =
commiting to working on this and then underdelivering though I think I migh=
t be able to give it a serious attempt if nothing comparable ends up in the=
 kernel in a couple months. I would love to hear what you have learned abou=
t the spatial safety issue from working on it. I am actually curious how a =
gcc plugin could ever get accepted into the kernel and be actively maintain=
ed even though I think this is the best way to get memory safety into the k=
ernel since there are potentially gains in terms of maintenance when automa=
tion is used via static analysis.=C2=A0=C2=A0<div><br></div><div>Regards,</=
div><div><br></div><div>Carter.</div></div><div dir=3D"ltr"></div><br><div =
class=3D"gmail_quote"><div dir=3D"ltr">On Wed, Sep 26, 2018 at 4:32 PM Resh=
etova, Elena &lt;<a href=3D"mailto:elena.reshetova@intel.com" target=3D"_bl=
ank">elena.reshetova@intel.com</a>&gt; wrote:<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex"><br>
&gt;I suspect any modification would have to be made on the compiler side a=
s some sort of compiler plugin since skimming over the papers in the area m=
ost optimize by doing some sort of dataflow analysis(removing runtime check=
s when not needed). To &gt;produce something like this would require readin=
g through some of the literature and open source and constructing the compi=
ler transform pass in gcc or clang. Is gcc currently preferred for somethin=
g like this?<br>
<br>
Hi,<br>
<br>
We have tried to do some of this via gcc plugin and using existing (still l=
ast year) Intel MPX technology to prevent spatial memory errors in kernel. =
<br>
Unfortunately MPX support has been now dropped out of both gcc and kernel, =
so our exercise is more like a past example now.<br>
However our code is still here: <a href=3D"https://github.com/ssg-kernel-me=
mory-safety/linux-mpxk" rel=3D"noreferrer" target=3D"_blank">https://github=
.com/ssg-kernel-memory-safety/linux-mpxk</a><br>
<br>
And the paper is here: <a href=3D"https://onlinelibrary.wiley.com/doi/full/=
10.1002/spe.2638" rel=3D"noreferrer" target=3D"_blank">https://onlinelibrar=
y.wiley.com/doi/full/10.1002/spe.2638</a><br>
<br>
If you are interested to continue on this direction, let me know, Hans and =
me can at least share the experience and knowledge we got while doing this =
with you. <br>
<br>
Best Regards,<br>
Elena.<br>
<br>
On Sat, Sep 22, 2018 at 2:41 AM Kees Cook &lt;<a href=3D"mailto:keescook@ch=
romium.org" target=3D"_blank">keescook@chromium.org</a>&gt; wrote:<br>
On Fri, Sep 21, 2018 at 10:25 AM, Carter Cheng &lt;<a href=3D"mailto:carter=
cheng@gmail.com" target=3D"_blank">cartercheng@gmail.com</a>&gt; wrote:<br>
&gt; Hi,<br>
<br>
Welcome!<br>
<br>
&gt; I recently attended a computer security conference for the first time =
and<br>
&gt; have developed some interest in kernel hardening issues after one of t=
he<br>
&gt; presenters demonstrated a kernel exploit based partly around a use aft=
er<br>
&gt; free bug.<br>
&gt;<br>
&gt; After scanning the literature a little bit and looking at some papers =
I have<br>
&gt; encountered before on CCured and Cyclone. I was curious to what extent=
 full<br>
&gt; memory saftety checks are now possible.<br>
<br>
CONFIG_KASAN covers a lot of this, but wasn&#39;t itself designed for<br>
&quot;production use&quot;. The primary concern, yes, is performance.<br>
<br>
&gt; There are many papers going back quite a bit on spatial safety<br>
&gt; implementations and some on temporal safety but they mainly target use=
r<br>
&gt; space. I am curious why such things don&#39;t exist in the linux kerne=
l at least<br>
&gt; as some sort of compile option. Is the slow down the main concern?<br>
&gt;<br>
&gt; It seems recent work has got the performance bound down to 1.29 is thi=
s<br>
&gt; considered too slow for many things?<br>
<br>
This sounds lovely! :) I&#39;d be curious to see patches implementing the<b=
r>
checks you&#39;re talking about.<br>
<br>
-Kees<br>
<br>
-- <br>
Kees Cook<br>
Pixel Security<br>
</blockquote></div>

--000000000000db78cc0576c730ef--
