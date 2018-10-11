MIME-Version: 1.0
References: <CALS6=qXmb0sXPbaSS-9ftRidxNSCck-NMxQWpA9AfCWFhwXKwg@mail.gmail.com>
 <CALS6=qUf52a877nH414P0T2B7_9=A6FvqBLc24a-5duX0KrtSQ@mail.gmail.com> <CAGXu5j+kx_QE8fN0QjCLh-EwObTKfh9xt4BxBA0mF40oygcvqQ@mail.gmail.com>
In-Reply-To: <CAGXu5j+kx_QE8fN0QjCLh-EwObTKfh9xt4BxBA0mF40oygcvqQ@mail.gmail.com>
From: Carter Cheng <cartercheng@gmail.com>
Date: Fri, 12 Oct 2018 02:52:53 +0800
Message-ID: <CALS6=qWHdneaZ3=_BaZHKn=QeLGK6X_nUwxVA1+siJ-D4uuAvw@mail.gmail.com>
Subject: Re: link time analysis for the kernel.
Content-Type: multipart/alternative; boundary="00000000000018e6290577f87bb7"
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--00000000000018e6290577f87bb7
Content-Type: text/plain; charset="UTF-8"

Thanks for the detailed reply. I actually am exploring whether it's
feasible perhaps in the coming months for me to look at implementing some
kind of automatic solution to the memory safety issue. I posted about this
briefly before earlier this month on the mailing list. I am currently
reviewing the relevant papers I have found and doing some exploratory
thinking about the problem.

On Fri, Oct 12, 2018 at 12:59 AM Kees Cook <keescook@chromium.org> wrote:

> On Thu, Oct 11, 2018 at 9:38 AM, Carter Cheng <cartercheng@gmail.com>
> wrote:
> > There are some detaills about the current procedures for linking the
> kernel
> > that I am unfamiliar with. My understanding is that GCC and Clang both
> have
> > the ability to do link time analysis and transforms on code but is it
> > possible to write link time passes that will run on the kernel since the
> > linking phase is a bit different (i.e. doesnt produce an ELF file)?
>
> I think you'd need to build with LTO for this to work. I'm not sure
> what the state of gcc and LTO against the kernel is right now, but it
> works under Clang[0] with some patches[1].
>
> For gcc, once you get LTO working, I assume you'd want to write a
> linker plugin[2].
>
> >
> > Are there other tools that are used for the purpose of analysing the
> kernel
> > and patching it? I have encountered a tool called Coccinelle but I am
> > uncertain if CTL can be used to simulate the analysis I would need for
> > adding and eliding runtime checks on various pointer operations.
>
> Coccinelle isn't a linker, but rather a static analysis and semantic
> patching tool. It's possible it might be able to do what you need,
> though. What are you working on, specifically?
>
> > I assume from previous discussions that the gcc would be best since clang
> > still doesn't correctly compile the kernel without patches.
>
> Building the kernel for arm64 works well with Clang. Doing x86 builds
> requires a little more work, but that should be solved soon only
> asm-goto support lands (it's under development now...)
>
> -Kees
>
> [0] https://llvm.org/docs/LinkTimeOptimization.html
> [1] https://android-review.googlesource.com/q/topic:android-4.14-lto
> [2] https://www.cleancss.com/explain-command/gcc/79600
>
> --
> Kees Cook
> Pixel Security
>

--00000000000018e6290577f87bb7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks for the detailed reply. I actually am exploring whe=
ther it&#39;s feasible perhaps in the coming months for me to look at imple=
menting some kind of automatic solution to the memory safety issue. I poste=
d about this briefly before earlier this month on the mailing list. I am cu=
rrently reviewing the relevant papers I have found and doing some explorato=
ry thinking about the problem.</div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr">On Fri, Oct 12, 2018 at 12:59 AM Kees Cook &lt;<a href=3D"mailto:k=
eescook@chromium.org">keescook@chromium.org</a>&gt; wrote:<br></div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex">On Thu, Oct 11, 2018 at 9:38 AM, Carter Cheng &lt;<=
a href=3D"mailto:cartercheng@gmail.com" target=3D"_blank">cartercheng@gmail=
.com</a>&gt; wrote:<br>
&gt; There are some detaills about the current procedures for linking the k=
ernel<br>
&gt; that I am unfamiliar with. My understanding is that GCC and Clang both=
 have<br>
&gt; the ability to do link time analysis and transforms on code but is it<=
br>
&gt; possible to write link time passes that will run on the kernel since t=
he<br>
&gt; linking phase is a bit different (i.e. doesnt produce an ELF file)?<br=
>
<br>
I think you&#39;d need to build with LTO for this to work. I&#39;m not sure=
<br>
what the state of gcc and LTO against the kernel is right now, but it<br>
works under Clang[0] with some patches[1].<br>
<br>
For gcc, once you get LTO working, I assume you&#39;d want to write a<br>
linker plugin[2].<br>
<br>
&gt;<br>
&gt; Are there other tools that are used for the purpose of analysing the k=
ernel<br>
&gt; and patching it? I have encountered a tool called Coccinelle but I am<=
br>
&gt; uncertain if CTL can be used to simulate the analysis I would need for=
<br>
&gt; adding and eliding runtime checks on various pointer operations.<br>
<br>
Coccinelle isn&#39;t a linker, but rather a static analysis and semantic<br=
>
patching tool. It&#39;s possible it might be able to do what you need,<br>
though. What are you working on, specifically?<br>
<br>
&gt; I assume from previous discussions that the gcc would be best since cl=
ang<br>
&gt; still doesn&#39;t correctly compile the kernel without patches.<br>
<br>
Building the kernel for arm64 works well with Clang. Doing x86 builds<br>
requires a little more work, but that should be solved soon only<br>
asm-goto support lands (it&#39;s under development now...)<br>
<br>
-Kees<br>
<br>
[0] <a href=3D"https://llvm.org/docs/LinkTimeOptimization.html" rel=3D"nore=
ferrer" target=3D"_blank">https://llvm.org/docs/LinkTimeOptimization.html</=
a><br>
[1] <a href=3D"https://android-review.googlesource.com/q/topic:android-4.14=
-lto" rel=3D"noreferrer" target=3D"_blank">https://android-review.googlesou=
rce.com/q/topic:android-4.14-lto</a><br>
[2] <a href=3D"https://www.cleancss.com/explain-command/gcc/79600" rel=3D"n=
oreferrer" target=3D"_blank">https://www.cleancss.com/explain-command/gcc/7=
9600</a><br>
<br>
-- <br>
Kees Cook<br>
Pixel Security<br>
</blockquote></div>

--00000000000018e6290577f87bb7--
