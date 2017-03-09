MIME-Version: 1.0
In-Reply-To: <CAGXu5jKGQ+UDu8LZDou1FfOs_ExuRKTo1M86mEA9EV33QNDEtw@mail.gmail.com>
References: <CAL_7pOJU751gDD9xHqP4Vs=BCBoa9xqLHUrTZEWxF4nkDra86Q@mail.gmail.com>
 <CAGXu5jKNhZtoP-8DxG+_NsTVCMo-ZLV8E1xPMWgEn=71kTJ4rw@mail.gmail.com>
 <20170309024229.GA6638@hopstrocity> <CAGXu5jKGQ+UDu8LZDou1FfOs_ExuRKTo1M86mEA9EV33QNDEtw@mail.gmail.com>
From: Tycho Andersen <tycho@docker.com>
Date: Thu, 9 Mar 2017 09:31:52 -0800
Message-ID: <CAL_7pO+dr_1Fhk5Csywt93FFNvNqdLfHRnzV0oT7d16L4qWszQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a114a6b4eedeeee054a4f9e93
Subject: Re: [kernel-hardening] Ahoy!
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114a6b4eedeeee054a4f9e93
Content-Type: text/plain; charset=UTF-8

Hi Kees,

On Wed, Mar 8, 2017 at 10:01 PM, Kees Cook <keescook@chromium.org> wrote:

> On Wed, Mar 8, 2017 at 6:42 PM, Tycho Andersen <tycho@docker.com> wrote:
> > Hey Kees,
> >
> > On Wed, Mar 08, 2017 at 03:17:55PM -0800, Kees Cook wrote:
> >> On Tue, Mar 7, 2017 at 3:37 PM, Tycho Andersen <tycho@docker.com>
> wrote:
> >> > I'm a new engineer at Docker, and I've been given some time to work on
> >> > kernel security, so I figured I'd introduce myself here. I'm currently
> >> > trying to figure out what a good first small-ish project that matches
> up
> >> > with the company's interests (containers, infrastructure that is used
> for
> >> > security primitives like eBPF).
> >> >
> >> > Thoughts about areas to poke at are much appreciated!
> >>
> >> Hi! Welcome to the fun!
> >>
> >> As I understand it (for our earlier chat), Docker is mainly x86, which
> >> somewhat limits choices from the existing KSPP TODO list which has a
> >> lot of arm and arm64 stuff on it. :)
> >
> > Yes, unfortunately :(.
> >
> >> So, here's one that isn't protection exactly, but rather a requested
> >> arrangement of Kconfig logic: it would be nice if HARDENED_USERCOPY
> >> depended on !DEVKMEM and STRICT_DEVMEM=y, but this isn't quite trivial
> >> since STRICT_DEVMEM doesn't exist for all architectures, but maybe it
> >> should be looking at ARCH_HAS_DEVMEM_IS_ALLOWED... (it seems Dan
> >> Williams cleaned this up a lot already in commit 21266be9ed542)
> >>
> >> Regardless, no one has snagged this to make sure that hardened
> >> usercopy isn't bypassed by things like DEVKMEM or DEVMEM and the lack
> >> of STRICT_DEVMEM. I'd like to have that off the list, and mostly I
> >> think it just requires staring at the Kconfigs for a bit to figure out
> >> the right combination so that people wanting hardened usercopy don't
> >> accidentally undermine themselves.
> >
> > Yeah, I think it is fairly simple. Does the attached patch look like
> > what you had in mind? I can send out a real version to the right
> > people if it looks reasonable.
>
> Ah, I found the original thread.. https://lkml.org/lkml/2016/9/7/589
>
> Can you add the !MMU case, and then I think it'll be good.
>

Cool, I just sent it to both you and James, not sure exactly how it should
go.


>
> >> So, that's the first thing that pops out at me. What do you think? :)
> >
> > I was curious about PAX_MEMORY_STACKLEAK, actually. I noticed in the
> > initial KSPP announcement email you mentioned it, and it's not clear
> > to me that anything actually got merged for it.
>
> That was an example of one of the many plugins in grsecurity, but no
> one has looked at upstreaming it yet. Since we've got the gcc
> infrastructure in place now, yeah, please take a look; I'd love to add
> it.


> > I understand in principle what needs to happen, but I'm not sure I
> > understand why a gcc plugin is required.
>
> IIUC, the plugin is used to instrument the call depth so that it's an
> efficient clearing.
>

Ah, makes sense.


>
> > Anyway, it seems like a
> > small-ish change (that could be hid behind a sysctl or a compiler
> > flag) that is reasonable enough to start with. Thoughts?
>
> Nothing is ever simple. :) See the #ifdef CONFIG_PAX_MEMORY_STACKLEAK
> sections in the x86 entry code, fs/exec.c, etc. And it looks like
> additional changes (that lack the config ifdef in processor.h) for
> adding the new field to track depth, etc.
>
> (It'd be nice to expand this feature beyond x86 too, but that can be
> the next step.)
>
> As far as how to enable id, I would follow the existing Kconfig style
> (see how the structleak plugin was added for upstream).
>

Awesome, thanks for the pointers. I'll give it a whirl and see what I can
come up with.

Cheers,

Tycho


>
> I think it'd be a great addition!
>
> -Kees
>
> --
> Kees Cook
> Pixel Security
>

--001a114a6b4eedeeee054a4f9e93
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Kees,<br><div class=3D"gmail_extra"><br><div class=3D"g=
mail_quote">On Wed, Mar 8, 2017 at 10:01 PM, Kees Cook <span dir=3D"ltr">&l=
t;<a href=3D"mailto:keescook@chromium.org" target=3D"_blank">keescook@chrom=
ium.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D=
"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><div class=
=3D"HOEnZb"><div class=3D"h5">On Wed, Mar 8, 2017 at 6:42 PM, Tycho Anderse=
n &lt;<a href=3D"mailto:tycho@docker.com">tycho@docker.com</a>&gt; wrote:<b=
r>
&gt; Hey Kees,<br>
&gt;<br>
&gt; On Wed, Mar 08, 2017 at 03:17:55PM -0800, Kees Cook wrote:<br>
&gt;&gt; On Tue, Mar 7, 2017 at 3:37 PM, Tycho Andersen &lt;<a href=3D"mail=
to:tycho@docker.com">tycho@docker.com</a>&gt; wrote:<br>
&gt;&gt; &gt; I&#39;m a new engineer at Docker, and I&#39;ve been given som=
e time to work on<br>
&gt;&gt; &gt; kernel security, so I figured I&#39;d introduce myself here. =
I&#39;m currently<br>
&gt;&gt; &gt; trying to figure out what a good first small-ish project that=
 matches up<br>
&gt;&gt; &gt; with the company&#39;s interests (containers, infrastructure =
that is used for<br>
&gt;&gt; &gt; security primitives like eBPF).<br>
&gt;&gt; &gt;<br>
&gt;&gt; &gt; Thoughts about areas to poke at are much appreciated!<br>
&gt;&gt;<br>
&gt;&gt; Hi! Welcome to the fun!<br>
&gt;&gt;<br>
&gt;&gt; As I understand it (for our earlier chat), Docker is mainly x86, w=
hich<br>
&gt;&gt; somewhat limits choices from the existing KSPP TODO list which has=
 a<br>
&gt;&gt; lot of arm and arm64 stuff on it. :)<br>
&gt;<br>
&gt; Yes, unfortunately :(.<br>
&gt;<br>
&gt;&gt; So, here&#39;s one that isn&#39;t protection exactly, but rather a=
 requested<br>
&gt;&gt; arrangement of Kconfig logic: it would be nice if HARDENED_USERCOP=
Y<br>
&gt;&gt; depended on !DEVKMEM and STRICT_DEVMEM=3Dy, but this isn&#39;t qui=
te trivial<br>
&gt;&gt; since STRICT_DEVMEM doesn&#39;t exist for all architectures, but m=
aybe it<br>
&gt;&gt; should be looking at ARCH_HAS_DEVMEM_IS_ALLOWED... (it seems Dan<b=
r>
&gt;&gt; Williams cleaned this up a lot already in commit 21266be9ed542)<br=
>
&gt;&gt;<br>
&gt;&gt; Regardless, no one has snagged this to make sure that hardened<br>
&gt;&gt; usercopy isn&#39;t bypassed by things like DEVKMEM or DEVMEM and t=
he lack<br>
&gt;&gt; of STRICT_DEVMEM. I&#39;d like to have that off the list, and most=
ly I<br>
&gt;&gt; think it just requires staring at the Kconfigs for a bit to figure=
 out<br>
&gt;&gt; the right combination so that people wanting hardened usercopy don=
&#39;t<br>
&gt;&gt; accidentally undermine themselves.<br>
&gt;<br>
&gt; Yeah, I think it is fairly simple. Does the attached patch look like<b=
r>
&gt; what you had in mind? I can send out a real version to the right<br>
&gt; people if it looks reasonable.<br>
<br>
</div></div>Ah, I found the original thread.. <a href=3D"https://lkml.org/l=
kml/2016/9/7/589" rel=3D"noreferrer" target=3D"_blank">https://lkml.org/lkm=
l/2016/9/<wbr>7/589</a><br>
<br>
Can you add the !MMU case, and then I think it&#39;ll be good.<br></blockqu=
ote><div><br></div><div>Cool, I just sent it to both you and James, not sur=
e exactly how it should go.</div><div>=C2=A0</div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex">
<span class=3D""><br>
&gt;&gt; So, that&#39;s the first thing that pops out at me. What do you th=
ink? :)<br>
&gt;<br>
&gt; I was curious about PAX_MEMORY_STACKLEAK, actually. I noticed in the<b=
r>
&gt; initial KSPP announcement email you mentioned it, and it&#39;s not cle=
ar<br>
&gt; to me that anything actually got merged for it.<br>
<br>
</span>That was an example of one of the many plugins in grsecurity, but no=
<br>
one has looked at upstreaming it yet. Since we&#39;ve got the gcc<br>
infrastructure in place now, yeah, please take a look; I&#39;d love to add<=
br>
<span class=3D"">it.</span></blockquote><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><spa=
n class=3D"">
<br>
&gt; I understand in principle what needs to happen, but I&#39;m not sure I=
<br>
&gt; understand why a gcc plugin is required.<br>
<br>
</span>IIUC, the plugin is used to instrument the call depth so that it&#39=
;s an<br>
efficient clearing.<br></blockquote><div><br></div><div>Ah, makes sense.</d=
iv><div>=C2=A0</div><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0=
 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<span class=3D""><br>
&gt; Anyway, it seems like a<br>
&gt; small-ish change (that could be hid behind a sysctl or a compiler<br>
&gt; flag) that is reasonable enough to start with. Thoughts?<br>
<br>
</span>Nothing is ever simple. :) See the #ifdef CONFIG_PAX_MEMORY_STACKLEA=
K<br>
sections in the x86 entry code, fs/exec.c, etc. And it looks like<br>
additional changes (that lack the config ifdef in processor.h) for<br>
adding the new field to track depth, etc.<br>
<br>
(It&#39;d be nice to expand this feature beyond x86 too, but that can be<br=
>
the next step.)<br>
<br>
As far as how to enable id, I would follow the existing Kconfig style<br>
(see how the structleak plugin was added for upstream).<br></blockquote><di=
v><br></div><div>Awesome, thanks for the pointers. I&#39;ll give it a whirl=
 and see what I can come up with.</div><div><br></div><div>Cheers,</div><di=
v><br></div><div>Tycho</div><div>=C2=A0</div><blockquote class=3D"gmail_quo=
te" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"=
>
<br>
I think it&#39;d be a great addition!<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Pixel Security<br>
</div></div></blockquote></div><br></div></div>

--001a114a6b4eedeeee054a4f9e93--
