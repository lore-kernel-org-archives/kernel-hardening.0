Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
Date: Thu, 5 Nov 2015 16:14:22 -0500
Message-ID: <CAEXv5_g07h_LhAx0M_xS5Km7kzrFXf7R-tbdhzcYicZna+pjkg@mail.gmail.com>
From: David Windsor <dave@0x4141.net>
Content-Type: multipart/alternative; boundary=001a114e43e0673e750523d19cce
Subject: Re: [kernel-hardening] Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a114e43e0673e750523d19cce
Content-Type: text/plain; charset=UTF-8

Hi,

I've done some work towards adding PAX_REFCOUNT to Ubuntu previously [1],
so I can resurrect those patches.  Note that those patches were directly
cherrypicked from PaX/grsec, without any sort of controls (sysctl, proc,
ioctl or otherwise) governing runtime behavior of this feature.  I can add
them if desired.

I also proposed a patch for adding overflow protection to kref [2], but
that patch was ultimately shot down.  Point being, I have some related
patches laying around that directly relate to refcount-based protection
which might be useful here.

Thanks,
David Windsor

[1]
https://www.mail-archive.com/ubuntu-bugs@lists.ubuntu.com/msg3420821.html
[2] https://lkml.org/lkml/2012/2/24/331

On Thu, Nov 5, 2015 at 3:59 PM, Kees Cook <keescook@chromium.org> wrote:

> I'm organizing a community of people to work on the various kernel
> self-protection technologies (most of which are found in PaX and
> Grsecurity). I'm building on the presentation I gave at Kernel Summit
> where I sought to convince the other upstream Linux kernel developers
> that security is more than fixing bugs, and that we need to bring in
> proactive defenses:
> http://lwn.net/Articles/662219/
>
> This is especially highlighted by the Washington Post article today:
>
> http://www.washingtonpost.com/sf/business/2015/11/05/net-of-insecurity-the-kernel-of-the-argument/
>
> Between the companies that recognize the critical nature of this work,
> and with Linux Foundation's Core Infrastructure Initiative happy to
> start funding specific work in this area, I think we can really make a
> dent.
>
> Let's start the work. I've built some wiki pages around my slides,
> where we can take notes, list examples, and coordinate:
> http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project
>
> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
> gcc plugin, which will also get us the gcc plugin infrastructure.
> Other people, please speak up on what you'd like to tackle.
>
> I recommend PAX_REFCOUNT, PAX_USERCOPY, and GRKERNSEC_KSTACKOVERFLOW
> for some non-plugin stuff to look at.
>
> Once we've got plugins, then we should look at PAX_MEMORY_STACKLEAK
> and PAX_CONSTIFY_PLUGIN.
>
> If you're feeling like disrupting people who depend on debugging, do
> GRKERNSEC_HIDESYM.
>
> If you're feeling especially bold, start on PAX_KERNEXEC and follow it
> up with PAX_MEMORY_UDEREF.
>
> Of course, there's plenty of other things, and tons I haven't listed
> in the wiki -- please add them and bring them up for discussion here.
>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security
>

--001a114e43e0673e750523d19cce
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hi,<br><br></div>I&#39;ve done some work to=
wards adding PAX_REFCOUNT to Ubuntu previously [1], so I can resurrect thos=
e patches.=C2=A0 Note that those patches were directly cherrypicked from Pa=
X/grsec, without any sort of controls (sysctl, proc, ioctl or otherwise) go=
verning runtime behavior of this feature.=C2=A0 I can add them if desired.=
=C2=A0 <br><br>I also proposed a patch for adding overflow protection to kr=
ef [2], but that patch was ultimately shot down.=C2=A0 Point being, I have =
some related patches laying around that directly relate to refcount-based p=
rotection which might be useful here.=C2=A0 <br><br></div>Thanks,<br></div>=
David Windsor<br><br>[1] <a href=3D"https://www.mail-archive.com/ubuntu-bug=
s@lists.ubuntu.com/msg3420821.html">https://www.mail-archive.com/ubuntu-bug=
s@lists.ubuntu.com/msg3420821.html</a><br>[2] <a href=3D"https://lkml.org/l=
kml/2012/2/24/331">https://lkml.org/lkml/2012/2/24/331</a><br></div><div cl=
ass=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, Nov 5, 2015 at 3=
:59 PM, Kees Cook <span dir=3D"ltr">&lt;<a href=3D"mailto:keescook@chromium=
.org" target=3D"_blank">keescook@chromium.org</a>&gt;</span> wrote:<br><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex">I&#39;m organizing a community of people to work=
 on the various kernel<br>
self-protection technologies (most of which are found in PaX and<br>
Grsecurity). I&#39;m building on the presentation I gave at Kernel Summit<b=
r>
where I sought to convince the other upstream Linux kernel developers<br>
that security is more than fixing bugs, and that we need to bring in<br>
proactive defenses:<br>
<a href=3D"http://lwn.net/Articles/662219/" rel=3D"noreferrer" target=3D"_b=
lank">http://lwn.net/Articles/662219/</a><br>
<br>
This is especially highlighted by the Washington Post article today:<br>
<a href=3D"http://www.washingtonpost.com/sf/business/2015/11/05/net-of-inse=
curity-the-kernel-of-the-argument/" rel=3D"noreferrer" target=3D"_blank">ht=
tp://www.washingtonpost.com/sf/business/2015/11/05/net-of-insecurity-the-ke=
rnel-of-the-argument/</a><br>
<br>
Between the companies that recognize the critical nature of this work,<br>
and with Linux Foundation&#39;s Core Infrastructure Initiative happy to<br>
start funding specific work in this area, I think we can really make a<br>
dent.<br>
<br>
Let&#39;s start the work. I&#39;ve built some wiki pages around my slides,<=
br>
where we can take notes, list examples, and coordinate:<br>
<a href=3D"http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project=
" rel=3D"noreferrer" target=3D"_blank">http://kernsec.org/wiki/index.php/Ke=
rnel_Self_Protection_Project</a><br>
<br>
For now, I&#39;m going to focus on taking a look at the PAX_SIZE_OVERFLOW<b=
r>
gcc plugin, which will also get us the gcc plugin infrastructure.<br>
Other people, please speak up on what you&#39;d like to tackle.<br>
<br>
I recommend PAX_REFCOUNT, PAX_USERCOPY, and GRKERNSEC_KSTACKOVERFLOW<br>
for some non-plugin stuff to look at.<br>
<br>
Once we&#39;ve got plugins, then we should look at PAX_MEMORY_STACKLEAK<br>
and PAX_CONSTIFY_PLUGIN.<br>
<br>
If you&#39;re feeling like disrupting people who depend on debugging, do<br=
>
GRKERNSEC_HIDESYM.<br>
<br>
If you&#39;re feeling especially bold, start on PAX_KERNEXEC and follow it<=
br>
up with PAX_MEMORY_UDEREF.<br>
<br>
Of course, there&#39;s plenty of other things, and tons I haven&#39;t liste=
d<br>
in the wiki -- please add them and bring them up for discussion here.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Chrome OS Security<br>
</font></span></blockquote></div><br></div>

--001a114e43e0673e750523d19cce--
