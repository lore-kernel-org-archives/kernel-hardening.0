Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jL+WXojAYeZB6KWCjXH_L6WnzN9m6kjVy6Lng_yYUzy4g@mail.gmail.com>
References: <20160912065318.GH16712@linaro.org> <CAGXu5jL+WXojAYeZB6KWCjXH_L6WnzN9m6kjVy6Lng_yYUzy4g@mail.gmail.com>
From: David Windsor <dave@progbits.org>
Date: Mon, 26 Sep 2016 20:29:37 -0400
Message-ID: <CAEXv5_htzh3nKjXfRk-ZR1+Q+G_N8PQ=uaOD+CLq3WAPoShrsQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a11440100faf2e2053d725625
Subject: Re: [kernel-hardening] Re: Self introduction
To: kernel-hardening@lists.openwall.com
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

--001a11440100faf2e2053d725625
Content-Type: text/plain; charset=UTF-8

Hi,


On Mon, Sep 26, 2016 at 1:17 PM, Kees Cook <keescook@chromium.org> wrote:

> On Sun, Sep 11, 2016 at 11:53 PM, AKASHI Takahiro
> <takahiro.akashi@linaro.org> wrote:
> > Hi Kees and all,
>
> Hi! Sorry for not replying sooner -- this email seemed to strangely
> not make its way into the kernel-hardening list, even though it looks
> from the headers like you sent it there. Regardless, on to my late
> reply...
>
> > I'm looking for any tasks that I could contribute in
> > kernel-hardening areas. As I'm working for Linaro,
> > arm/arm64-related items (or arch-specific implementation
> > of more generic features) would be better fitted, but I'm
> > open to broader topics, including complementary tasks
> > for other guys.
>
> Awesome! Yeah, it'll be great to have you helping. Are there any areas
> you especially enjoy working on?
>
> > Do you have any suggestions about such items for me
> > to start small (or can be even big :) with?
>
> I think a great area would be looking at arm and arm64 support for
> catching atomic_t wrap-around. This kind of protection would have
> stopped many of the public attacks from last year, since accidents
> with refcounting on atomic_t tend to be a precursor to use-after-free
> vulnerabilities.
>
> This idea has been implemented in PaX/Grsecurity for a while now as
> PAX_REFCOUNT. An earlier effort to extract it was started but he ran
> out of time to work on it.


Sorry about not communicating better about this.  I started working on v3
(porting to linux-next) a few days ago and have the code moved, but still
have to work through a few compile issues.

If you're interested in helping, take a look:

https://github.com/dwindsor/linux-next/tree/strict-refcount-v3

I'll continue working through this, but help would certainly be appreciated.

Thanks,
David

--001a11440100faf2e2053d725625
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div><br></div><div class=3D"gmail_extra"><br><div clas=
s=3D"gmail_quote">On Mon, Sep 26, 2016 at 1:17 PM, Kees Cook <span dir=3D"l=
tr">&lt;<a href=3D"mailto:keescook@chromium.org" target=3D"_blank">keescook=
@chromium.org</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" st=
yle=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padd=
ing-left:1ex">On Sun, Sep 11, 2016 at 11:53 PM, AKASHI Takahiro<br>
&lt;<a href=3D"mailto:takahiro.akashi@linaro.org">takahiro.akashi@linaro.or=
g</a>&gt; wrote:<br>
&gt; Hi Kees and all,<br>
<br>
Hi! Sorry for not replying sooner -- this email seemed to strangely<br>
not make its way into the kernel-hardening list, even though it looks<br>
from the headers like you sent it there. Regardless, on to my late<br>
reply...<br>
<br>
&gt; I&#39;m looking for any tasks that I could contribute in<br>
&gt; kernel-hardening areas. As I&#39;m working for Linaro,<br>
&gt; arm/arm64-related items (or arch-specific implementation<br>
&gt; of more generic features) would be better fitted, but I&#39;m<br>
&gt; open to broader topics, including complementary tasks<br>
&gt; for other guys.<br>
<br>
Awesome! Yeah, it&#39;ll be great to have you helping. Are there any areas<=
br>
you especially enjoy working on?<br>
<br>
&gt; Do you have any suggestions about such items for me<br>
&gt; to start small (or can be even big :) with?<br>
<br>
I think a great area would be looking at arm and arm64 support for<br>
catching atomic_t wrap-around. This kind of protection would have<br>
stopped many of the public attacks from last year, since accidents<br>
with refcounting on atomic_t tend to be a precursor to use-after-free<br>
vulnerabilities.<br>
<br>
This idea has been implemented in PaX/Grsecurity for a while now as<br>
PAX_REFCOUNT. An earlier effort to extract it was started but he ran<br>
out of time to work on it. </blockquote><div><br></div><div>Sorry about not=
 communicating better about this.=C2=A0 I started working on v3 (porting to=
 linux-next) a few days ago and have the code moved, but still have to work=
 through a few compile issues. =C2=A0<br><br>If you&#39;re interested in he=
lping, take a look:<br><br><a href=3D"https://github.com/dwindsor/linux-nex=
t/tree/strict-refcount-v3">https://github.com/dwindsor/linux-next/tree/stri=
ct-refcount-v3</a><br></div><div><br></div><div>I&#39;ll continue working t=
hrough this, but help would certainly be appreciated.</div><div><br></div><=
div>Thanks,<br>David</div><div><br></div><div><br></div></div></div></div>

--001a11440100faf2e2053d725625--
