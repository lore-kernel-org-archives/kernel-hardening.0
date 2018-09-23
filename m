MIME-Version: 1.0
References: <CALS6=qVgYYxcjv8Fj4pdPJ0Z_fUceTV60DtKwOhFkSz4HZohxg@mail.gmail.com>
 <CAGXu5jKPeXWVV0480xt_5K4O2x8iA2xRf_9t8Rr0yG6szYebhQ@mail.gmail.com>
In-Reply-To: <CAGXu5jKPeXWVV0480xt_5K4O2x8iA2xRf_9t8Rr0yG6szYebhQ@mail.gmail.com>
From: Carter Cheng <cartercheng@gmail.com>
Date: Sun, 23 Sep 2018 16:39:12 +0800
Message-ID: <CALS6=qWNeRM18kgtvpVZw2O6+Zt5eJdOQ2cXbDCbEkBCeRSe4A@mail.gmail.com>
Subject: Re: temporal and spatial locality in the kernel
Content-Type: multipart/alternative; boundary="000000000000430ffb057685cf14"
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--000000000000430ffb057685cf14
Content-Type: text/plain; charset="UTF-8"

I suspect any modification would have to be made on the compiler side as
some sort of compiler plugin since skimming over the papers in the area
most optimize by doing some sort of dataflow analysis(removing runtime
checks when not needed). To produce something like this would require
reading through some of the literature and open source and constructing the
compiler transform pass in gcc or clang. Is gcc currently preferred for
something like this?

On Sat, Sep 22, 2018 at 2:41 AM Kees Cook <keescook@chromium.org> wrote:

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

--000000000000430ffb057685cf14
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I suspect any modification would have to be made on the co=
mpiler side as some sort of compiler plugin since skimming over the papers =
in the area most optimize by doing some sort of dataflow analysis(removing =
runtime checks when not needed). To produce something like this would requi=
re reading through some of the literature and open source and constructing =
the compiler transform pass in gcc or clang. Is gcc currently preferred for=
 something like this?</div><br><div class=3D"gmail_quote"><div dir=3D"ltr">=
On Sat, Sep 22, 2018 at 2:41 AM Kees Cook &lt;<a href=3D"mailto:keescook@ch=
romium.org">keescook@chromium.org</a>&gt; wrote:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">On Fri, Sep 21, 2018 at 10:25 AM, Carter Cheng &lt;<a href=3D=
"mailto:cartercheng@gmail.com" target=3D"_blank">cartercheng@gmail.com</a>&=
gt; wrote:<br>
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

--000000000000430ffb057685cf14--
