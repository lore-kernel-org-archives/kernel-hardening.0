MIME-Version: 1.0
References: <CAEk6tExvL7NCB8P-YP7MwT6Ysi8S08H+RgsvBfRXp336noTfxg@mail.gmail.com>
 <CAGXu5j+KYYRvWC1MmMyn3w1N5DsXeAnHR3wZvjpUfUaqd3L2Rw@mail.gmail.com>
 <CAEk6tEyquWE2HS=Nrtzx4RS_GXRMNBBXVtac1dFP2Py17cN_MQ@mail.gmail.com> <CAGXu5jL=W0WVNU7LC8j_A1o=dnP0KwiU+Qp=Wu1bzR_FnCtEuw@mail.gmail.com>
In-Reply-To: <CAGXu5jL=W0WVNU7LC8j_A1o=dnP0KwiU+Qp=Wu1bzR_FnCtEuw@mail.gmail.com>
From: Jessica Frazelle <me@jessfraz.com>
Date: Fri, 27 Jan 2017 19:14:11 +0000
Message-ID: <CAEk6tEwVF5mLgo4JX+jkX+zuhe6_hZYKBzTCsFYrmAgZVthcCw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a1140338af8d113054718458e
Subject: Re: [kernel-hardening] Introduction
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a1140338af8d113054718458e
Content-Type: text/plain; charset=UTF-8

Cool! Have already started looking into it! Super excited :D

On Thu, Jan 26, 2017 at 1:42 PM Kees Cook <keescook@chromium.org> wrote:

> On Wed, Jan 25, 2017 at 8:12 PM, Jessica Frazelle <me@jessfraz.com> wrote:
> > On Wed, Jan 25, 2017, 11:37 Kees Cook <keescook@chromium.org> wrote:
> >>
> >> On Mon, Jan 23, 2017 at 4:06 PM, Jessica Frazelle <me@jessfraz.com>
> wrote:
> >> > I've been lurking on this mailing list for over a year now, so I think
> >> > I understand the gist of how it works. I am looking for some ways to
> >> > help out in my free time.
> >>
> >> Greetings! Thanks for saying "hi". :)
> >>
> >> > The subsystems I know the most about are cgroups and namespaces. I
> >> > previously was a maintainer of Docker (I added the seccomp integration
> >> > and maintained the AppArmor bits) and now I work on kubernetes.
> >> >
> >> > Let me know if you think there is a good place to start!
> >>
> >> I've mostly been trying to keep track of kernel self-protection TODO
> >> items, so I haven't been keeping too up to date on userspace-support
> >> things that the kernel provides. I know Solar has a list of things
> >> he'd like to see, and I know there was an earlier attempt at building
> >> an LSM to provide a more hardened chroot implementation (that Elena
> >> sent a version of last year).
> >>
> >
> > I am familiar with the chroot LSM from GRSEC, I'm not sure if this
> > would help containers much mostly because we use pivot_root and a lot
> > of that functionality can be reproduced by either capabilities
> > dropping or seccomp. I'm guessing it has a use outside containers but
> > I'm not really sure what that may be other than ease of use of not
> > having to drop caps etc. I am more than willing to help make sure it
> > gets done in a way everyone wants if that's the case.
> >
> >>
> >> Are there any gaps in existing cgroups/namespaces stuff that you'd
> >> like to see fixed? Or are there any areas of self-protection work that
> >> you find interesting and would want to learn more about?
> >>
> >> -Kees
> >>
> >> --
> >> Kees Cook
> >> Nexus Security
> >
> > I would definitely like to help with some mechanisms that containers
> > and others could integrate to become more secure and I have some ideas
> > for this, but they are kind of a larger scale feature.
> >
> > For now, I would love to help with whatever low hanging fruit no one
> > else wants to do but that might benefit some people. Then maybe once
> > I've been around the block enough times see if you all are interested
> > in something I have briefly thought of that maybe we could make
> > awesome together.
> >
> > Honestly I'm open to working on whatever no one else wants too :)
>
> You said the magic words! ;) Looking at the TODO, I'll pick this
> semi-randomly:
>
> - expand use of __ro_after_init, especially in arch/arm64
>
> It'd be nice to look through arch/arm64 to find anything that is close
> to be able to be declared as const, but can't due to some post-boot
> but pre-init changes. This is needs some manual examination currently,
> but you can look at other uses of __ro_after_init in arch/x86 and
> arch/arm. Of course, there's no reason to limit yourself to arch/arm64
> if you find similar things in the core kernel code too.
>
> -Kees
>
> --
> Kees Cook
> Nexus Security
>

--001a1140338af8d113054718458e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Cool! Have already started looking into it! Super excited =
:D</div><br><div class=3D"gmail_quote"><div dir=3D"ltr">On Thu, Jan 26, 201=
7 at 1:42 PM Kees Cook &lt;<a href=3D"mailto:keescook@chromium.org">keescoo=
k@chromium.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On We=
d, Jan 25, 2017 at 8:12 PM, Jessica Frazelle &lt;<a href=3D"mailto:me@jessf=
raz.com" class=3D"gmail_msg" target=3D"_blank">me@jessfraz.com</a>&gt; wrot=
e:<br class=3D"gmail_msg">
&gt; On Wed, Jan 25, 2017, 11:37 Kees Cook &lt;<a href=3D"mailto:keescook@c=
hromium.org" class=3D"gmail_msg" target=3D"_blank">keescook@chromium.org</a=
>&gt; wrote:<br class=3D"gmail_msg">
&gt;&gt;<br class=3D"gmail_msg">
&gt;&gt; On Mon, Jan 23, 2017 at 4:06 PM, Jessica Frazelle &lt;<a href=3D"m=
ailto:me@jessfraz.com" class=3D"gmail_msg" target=3D"_blank">me@jessfraz.co=
m</a>&gt; wrote:<br class=3D"gmail_msg">
&gt;&gt; &gt; I&#39;ve been lurking on this mailing list for over a year no=
w, so I think<br class=3D"gmail_msg">
&gt;&gt; &gt; I understand the gist of how it works. I am looking for some =
ways to<br class=3D"gmail_msg">
&gt;&gt; &gt; help out in my free time.<br class=3D"gmail_msg">
&gt;&gt;<br class=3D"gmail_msg">
&gt;&gt; Greetings! Thanks for saying &quot;hi&quot;. :)<br class=3D"gmail_=
msg">
&gt;&gt;<br class=3D"gmail_msg">
&gt;&gt; &gt; The subsystems I know the most about are cgroups and namespac=
es. I<br class=3D"gmail_msg">
&gt;&gt; &gt; previously was a maintainer of Docker (I added the seccomp in=
tegration<br class=3D"gmail_msg">
&gt;&gt; &gt; and maintained the AppArmor bits) and now I work on kubernete=
s.<br class=3D"gmail_msg">
&gt;&gt; &gt;<br class=3D"gmail_msg">
&gt;&gt; &gt; Let me know if you think there is a good place to start!<br c=
lass=3D"gmail_msg">
&gt;&gt;<br class=3D"gmail_msg">
&gt;&gt; I&#39;ve mostly been trying to keep track of kernel self-protectio=
n TODO<br class=3D"gmail_msg">
&gt;&gt; items, so I haven&#39;t been keeping too up to date on userspace-s=
upport<br class=3D"gmail_msg">
&gt;&gt; things that the kernel provides. I know Solar has a list of things=
<br class=3D"gmail_msg">
&gt;&gt; he&#39;d like to see, and I know there was an earlier attempt at b=
uilding<br class=3D"gmail_msg">
&gt;&gt; an LSM to provide a more hardened chroot implementation (that Elen=
a<br class=3D"gmail_msg">
&gt;&gt; sent a version of last year).<br class=3D"gmail_msg">
&gt;&gt;<br class=3D"gmail_msg">
&gt;<br class=3D"gmail_msg">
&gt; I am familiar with the chroot LSM from GRSEC, I&#39;m not sure if this=
<br class=3D"gmail_msg">
&gt; would help containers much mostly because we use pivot_root and a lot<=
br class=3D"gmail_msg">
&gt; of that functionality can be reproduced by either capabilities<br clas=
s=3D"gmail_msg">
&gt; dropping or seccomp. I&#39;m guessing it has a use outside containers =
but<br class=3D"gmail_msg">
&gt; I&#39;m not really sure what that may be other than ease of use of not=
<br class=3D"gmail_msg">
&gt; having to drop caps etc. I am more than willing to help make sure it<b=
r class=3D"gmail_msg">
&gt; gets done in a way everyone wants if that&#39;s the case.<br class=3D"=
gmail_msg">
&gt;<br class=3D"gmail_msg">
&gt;&gt;<br class=3D"gmail_msg">
&gt;&gt; Are there any gaps in existing cgroups/namespaces stuff that you&#=
39;d<br class=3D"gmail_msg">
&gt;&gt; like to see fixed? Or are there any areas of self-protection work =
that<br class=3D"gmail_msg">
&gt;&gt; you find interesting and would want to learn more about?<br class=
=3D"gmail_msg">
&gt;&gt;<br class=3D"gmail_msg">
&gt;&gt; -Kees<br class=3D"gmail_msg">
&gt;&gt;<br class=3D"gmail_msg">
&gt;&gt; --<br class=3D"gmail_msg">
&gt;&gt; Kees Cook<br class=3D"gmail_msg">
&gt;&gt; Nexus Security<br class=3D"gmail_msg">
&gt;<br class=3D"gmail_msg">
&gt; I would definitely like to help with some mechanisms that containers<b=
r class=3D"gmail_msg">
&gt; and others could integrate to become more secure and I have some ideas=
<br class=3D"gmail_msg">
&gt; for this, but they are kind of a larger scale feature.<br class=3D"gma=
il_msg">
&gt;<br class=3D"gmail_msg">
&gt; For now, I would love to help with whatever low hanging fruit no one<b=
r class=3D"gmail_msg">
&gt; else wants to do but that might benefit some people. Then maybe once<b=
r class=3D"gmail_msg">
&gt; I&#39;ve been around the block enough times see if you all are interes=
ted<br class=3D"gmail_msg">
&gt; in something I have briefly thought of that maybe we could make<br cla=
ss=3D"gmail_msg">
&gt; awesome together.<br class=3D"gmail_msg">
&gt;<br class=3D"gmail_msg">
&gt; Honestly I&#39;m open to working on whatever no one else wants too :)<=
br class=3D"gmail_msg">
<br class=3D"gmail_msg">
You said the magic words! ;) Looking at the TODO, I&#39;ll pick this semi-r=
andomly:<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
- expand use of __ro_after_init, especially in arch/arm64<br class=3D"gmail=
_msg">
<br class=3D"gmail_msg">
It&#39;d be nice to look through arch/arm64 to find anything that is close<=
br class=3D"gmail_msg">
to be able to be declared as const, but can&#39;t due to some post-boot<br =
class=3D"gmail_msg">
but pre-init changes. This is needs some manual examination currently,<br c=
lass=3D"gmail_msg">
but you can look at other uses of __ro_after_init in arch/x86 and<br class=
=3D"gmail_msg">
arch/arm. Of course, there&#39;s no reason to limit yourself to arch/arm64<=
br class=3D"gmail_msg">
if you find similar things in the core kernel code too.<br class=3D"gmail_m=
sg">
<br class=3D"gmail_msg">
-Kees<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
--<br class=3D"gmail_msg">
Kees Cook<br class=3D"gmail_msg">
Nexus Security<br class=3D"gmail_msg">
</blockquote></div>

--001a1140338af8d113054718458e--
