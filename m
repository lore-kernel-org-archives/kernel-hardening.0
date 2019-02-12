MIME-Version: 1.0
References: <cover.1549927666.git.igor.stoppa@huawei.com> <CAGXu5j+n3ky2dOe4F+VyneQsM4VJbGPUw+DO55NkxxPhKzKHag@mail.gmail.com>
 <25bf3c63-c54c-f7ea-bec1-996a2c05d997@gmail.com> <CAGXu5jLqmYRUVLb7-jPsN4onO5UNH+D6qOF=9TOiVjJa-=DnZQ@mail.gmail.com>
In-Reply-To: <CAGXu5jLqmYRUVLb7-jPsN4onO5UNH+D6qOF=9TOiVjJa-=DnZQ@mail.gmail.com>
From: "igor.stoppa@gmail.com" <igor.stoppa@gmail.com>
Date: Tue, 12 Feb 2019 05:08:03 +0400
Message-ID: <CAH2bzCRZ5xYOT0R8piqZx4mSGj1_8fNG=Ce4UU8i6F7mYD9m9Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/12] hardening: statically allocated protected memory
Content-Type: multipart/alternative; boundary="00000000000058dc140581a80fc2"
To: Kees Cook <keescook@chromium.org>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity <linux-integrity@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

--00000000000058dc140581a80fc2
Content-Type: text/plain; charset="UTF-8"

On Tue, 12 Feb 2019, 4.47 Kees Cook <keescook@chromium.org wrote:

> On Mon, Feb 11, 2019 at 4:37 PM Igor Stoppa <igor.stoppa@gmail.com> wrote:
> >
> >
> >
> > On 12/02/2019 02:09, Kees Cook wrote:
> > > On Mon, Feb 11, 2019 at 3:28 PM Igor Stoppa <igor.stoppa@gmail.com>
> wrote:
> > > It looked like only the memset() needed architecture support. Is there
> > > a reason for not being able to implement memset() in terms of an
> > > inefficient put_user() loop instead? That would eliminate the need for
> > > per-arch support, yes?
> >
> > So far, yes, however from previous discussion about power arch, I
> > understood this implementation would not be so easy to adapt.
> > Lacking other examples where the extra mapping could be used, I did not
> > want to add code without a use case.
> >
> > Probably both arm and x86 32 bit could do, but I would like to first get
> > to the bitter end with memory protection (the other 2 thirds).
> >
> > Mostly, I hated having just one arch and I also really wanted to have
> arm64.
>
> Right, I meant, if you implemented the _memset() case with put_user()
> in this version, you could drop the arch-specific _memset() and shrink
> the patch series. Then you could also enable this across all the
> architectures in one patch. (Would you even need the Kconfig patches,
> i.e. won't this "Just Work" on everything with an MMU?)
>

I had similar thoughts, but this answer [1] deflated my hopes (if I
understood it correctly).
It seems that each arch needs to be massaged in separately.

--
igor


[1] https://www.openwall.com/lists/kernel-hardening/2018/12/12/15

>

--00000000000058dc140581a80fc2
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><br><div class=3D"gmail_quote"><div dir=3D"ltr">=
On Tue, 12 Feb 2019, 4.47 Kees Cook &lt;<a href=3D"mailto:keescook@chromium=
.org">keescook@chromium.org</a> wrote:<br></div><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex">On Mon, Feb 11, 2019 at 4:37 PM Igor Stoppa &lt;<a href=3D"mailto:igor.=
stoppa@gmail.com" target=3D"_blank" rel=3D"noreferrer">igor.stoppa@gmail.co=
m</a>&gt; wrote:<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On 12/02/2019 02:09, Kees Cook wrote:<br>
&gt; &gt; On Mon, Feb 11, 2019 at 3:28 PM Igor Stoppa &lt;<a href=3D"mailto=
:igor.stoppa@gmail.com" target=3D"_blank" rel=3D"noreferrer">igor.stoppa@gm=
ail.com</a>&gt; wrote:<br>
&gt; &gt; It looked like only the memset() needed architecture support. Is =
there<br>
&gt; &gt; a reason for not being able to implement memset() in terms of an<=
br>
&gt; &gt; inefficient put_user() loop instead? That would eliminate the nee=
d for<br>
&gt; &gt; per-arch support, yes?<br>
&gt;<br>
&gt; So far, yes, however from previous discussion about power arch, I<br>
&gt; understood this implementation would not be so easy to adapt.<br>
&gt; Lacking other examples where the extra mapping could be used, I did no=
t<br>
&gt; want to add code without a use case.<br>
&gt;<br>
&gt; Probably both arm and x86 32 bit could do, but I would like to first g=
et<br>
&gt; to the bitter end with memory protection (the other 2 thirds).<br>
&gt;<br>
&gt; Mostly, I hated having just one arch and I also really wanted to have =
arm64.<br>
<br>
Right, I meant, if you implemented the _memset() case with put_user()<br>
in this version, you could drop the arch-specific _memset() and shrink<br>
the patch series. Then you could also enable this across all the<br>
architectures in one patch. (Would you even need the Kconfig patches,<br>
i.e. won&#39;t this &quot;Just Work&quot; on everything with an MMU?)<br></=
blockquote></div></div><div dir=3D"auto"><br></div><div dir=3D"auto">I had =
similar thoughts, but this answer [1] deflated my hopes (if I understood it=
 correctly).</div><div dir=3D"auto">It seems that each arch needs to be mas=
saged in separately.=C2=A0</div><div dir=3D"auto"><br></div><div dir=3D"aut=
o">--</div><div dir=3D"auto">igor</div><div dir=3D"auto"><br></div><div dir=
=3D"auto"><br></div><div dir=3D"auto">[1]=C2=A0<a href=3D"https://www.openw=
all.com/lists/kernel-hardening/2018/12/12/15">https://www.openwall.com/list=
s/kernel-hardening/2018/12/12/15</a></div><div dir=3D"auto"><div class=3D"g=
mail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex">
</blockquote></div></div></div>

--00000000000058dc140581a80fc2--
