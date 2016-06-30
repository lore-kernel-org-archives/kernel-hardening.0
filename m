Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
References: <CAJcbSZHbGJBhTMeAEJF4VVazYypDCO=UFJpi8y0kXKrdM=WXQA@mail.gmail.com>
 <CAGXu5jK_42d+jkPr4Ck0iL52-ignY9gq-eUZ73_YuhKJERrRxA@mail.gmail.com>
 <20160623193358.GL9922@io.lakedaemon.net> <CAGXu5jJpFPuOrKSWT_H1oeTDObQKcgqL9ZwAHUV7y9=how_n9w@mail.gmail.com>
 <CAKv+Gu8SGsLCbVqDQVtZU4nNf=zzhONSFoSNF_Q29VmD=TZMWw@mail.gmail.com>
 <20160624011115.GU9922@io.lakedaemon.net> <CAKv+Gu_p5WLXBO0k=VWuX_ps1SMSte4_BhZFQY9pjveiTbSxAA@mail.gmail.com>
 <20160624160238.GV9922@io.lakedaemon.net> <CAGXu5j+hsPcrCAEcY-s9EDDUVqWOhpdx5iGNTBRqCqkExOJh5w@mail.gmail.com>
 <CALCETrX0bsFiykT=6d8K_igkBCDavdzxmq-A3VJ+7nht2s8FFg@mail.gmail.com> <20160630214856.GI9922@io.lakedaemon.net>
In-Reply-To: <20160630214856.GI9922@io.lakedaemon.net>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 30 Jun 2016 21:56:27 +0000
Message-ID: <CAJcbSZEBeowdRqpRPx2TEByWUevQ3cpFwgpmifsFa4rFtVLgvg@mail.gmail.com>
Content-Type: multipart/alternative; boundary=94eb2c1154dcb4eb20053685f19b
Subject: [kernel-hardening] Re: devicetree random-seed properties, was: "Re: [PATCH v7 0/9]
 x86/mm: memory area address KASLR"
To: Jason Cooper <jason@lakedaemon.net>, Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c1154dcb4eb20053685f19b
Content-Type: text/plain; charset=UTF-8

So would I!

On Thu, Jun 30, 2016, 2:49 PM Jason Cooper <jason@lakedaemon.net> wrote:

> On Fri, Jun 24, 2016 at 01:40:41PM -0700, Andy Lutomirski wrote:
> > On Fri, Jun 24, 2016 at 12:04 PM, Kees Cook <keescook@chromium.org>
> wrote:
> > > On Fri, Jun 24, 2016 at 9:02 AM, Jason Cooper <jason@lakedaemon.net>
> wrote:
> > >> Thomas,
> > >>
> > >> Sorry for wandering off the topic of your series.  The big take away
> for
> > >> me is that you and Kees are concerned about x86 systems pre-RDRAND.
> > >> Just as I'm concerned about deployed embedded systems without
> bootloader
> > >> support for hw-rngs and so forth.
> > >>
> > >> Whatever final form the approach takes for ARM/dt, I'll make sure we
> can
> > >> extend it to legacy x86 systems.
> > >
> > > Yeah, this seems like a productive conversation to me. :)
> >
> > I have an old patch and spec I need to dust off that does this during
> > *very* early boot on x86 using MSRs so that kASLR can use it.
>
> I'd love to see that. ;-)
>
> thx,
>
> Jason.
>
-- 

Thomas

--94eb2c1154dcb4eb20053685f19b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">So would I!</p>
<br><div class=3D"gmail_quote"><div dir=3D"ltr">On Thu, Jun 30, 2016, 2:49 =
PM Jason Cooper &lt;<a href=3D"mailto:jason@lakedaemon.net">jason@lakedaemo=
n.net</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Fri, Jun 24=
, 2016 at 01:40:41PM -0700, Andy Lutomirski wrote:<br>
&gt; On Fri, Jun 24, 2016 at 12:04 PM, Kees Cook &lt;<a href=3D"mailto:kees=
cook@chromium.org" target=3D"_blank">keescook@chromium.org</a>&gt; wrote:<b=
r>
&gt; &gt; On Fri, Jun 24, 2016 at 9:02 AM, Jason Cooper &lt;<a href=3D"mail=
to:jason@lakedaemon.net" target=3D"_blank">jason@lakedaemon.net</a>&gt; wro=
te:<br>
&gt; &gt;&gt; Thomas,<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Sorry for wandering off the topic of your series.=C2=A0 The b=
ig take away for<br>
&gt; &gt;&gt; me is that you and Kees are concerned about x86 systems pre-R=
DRAND.<br>
&gt; &gt;&gt; Just as I&#39;m concerned about deployed embedded systems wit=
hout bootloader<br>
&gt; &gt;&gt; support for hw-rngs and so forth.<br>
&gt; &gt;&gt;<br>
&gt; &gt;&gt; Whatever final form the approach takes for ARM/dt, I&#39;ll m=
ake sure we can<br>
&gt; &gt;&gt; extend it to legacy x86 systems.<br>
&gt; &gt;<br>
&gt; &gt; Yeah, this seems like a productive conversation to me. :)<br>
&gt;<br>
&gt; I have an old patch and spec I need to dust off that does this during<=
br>
&gt; *very* early boot on x86 using MSRs so that kASLR can use it.<br>
<br>
I&#39;d love to see that. ;-)<br>
<br>
thx,<br>
<br>
Jason.<br>
</blockquote></div><div dir=3D"ltr">-- <br></div><div data-smartmail=3D"gma=
il_signature"><p dir=3D"ltr">Thomas</p>
</div>

--94eb2c1154dcb4eb20053685f19b--
