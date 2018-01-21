MIME-Version: 1.0
References: <151648235823.34747.15181877619346237802.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151648236968.34747.390507912161115784.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180121104019.GS17719@n2100.armlinux.org.uk>
In-Reply-To: <20180121104019.GS17719@n2100.armlinux.org.uk>
From: Jann Horn <jannh@google.com>
Date: Sun, 21 Jan 2018 15:07:57 +0000
Message-ID: <CAG48ez31rdQTv-vehUSymp4ZCM8RVxWuzJd2G7igwRF83aZiJg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="94eb2c09166c639b3505634aae98"
Subject: Re: [kernel-hardening] Re: [PATCH v4.1 02/10] asm/nospec, array_ptr:
 sanitize speculative array de-references
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>, gregkh@linuxfoundation.org, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c09166c639b3505634aae98
Content-Type: text/plain; charset="UTF-8"

On Sun, Jan 21, 2018, 11:40 Russell King - ARM Linux <linux@armlinux.org.uk>
wrote:

> On Sat, Jan 20, 2018 at 01:06:09PM -0800, Dan Williams wrote:
> > +/*
> > + * If idx is negative or if idx > size then bit 63 is set in the mask,
> > + * and the value of ~(-1L) is zero. When the mask is zero, bounds check
> > + * failed, array_ptr will return NULL.
>
> The more times I see this the more times I'm unhappy with this comment:
>
> 1. does this really mean "idx > size" or "idx >= size" ?  The code
>    implements the latter not the former.
>

Copying the code here for context:
return ~(long)(idx | (sz - 1 - idx)) >> (BITS_PER_LONG - 1);

That part of the condition (ignoring the overflow edgecases) is equivalent
to "!(idx > sz - 1)", which is equivalent to "idx <= sz - 1", which is
(ignoring overflow edgecases) equivalent to "idx < sz".

Handling of edgecases:
idx>=2^(BITS_PER_LONG-1) will cause a NULL return through the first part of
the condition.
Hmm... a problematic case might be "sz==0 && idx==2^(BITS_PER_LONG-1)-1".
The first part of the expression wouldn't trigger, the second part would be
"2^(BITS_PER_LONG)-1-(2^(BITS_PER_LONG-1)-1) ==
2^(BITS_PER_LONG)-2^(BITS_PER_LONG-1)
== 2^(BITS_PER_LONG-1)", which also wouldn't trigger, I think?

2. is "bit 63" relevant here - what if longs are 32-bit?  "the top bit"
>    or "the sign bit" would be better.
>
> 3. "and the value of ~(-1L) is zero."  So does this mean that when
>    0 <= idx < size, somehow the rules of logic change and ~(-1L)
>    magically becomes no longer zero!
>
> I'd suggest changing the description to something like:
>
>   * If 0 <= idx < size, return a mask of ~0UL, otherwise return zero.
>
> or:
>
>   * When idx is out of bounds (iow, is negative or idx >= sz), the sign
>   * bit will be set. Extend the sign bit to all bits and invert, giving
>   * a result of zero for an out of bounds idx, or ~0UL if within bounds.
>
> depending on how deeply you want to describe what's going on here.
>
> --
> RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps
> up
> According to speedtest.net: 8.21Mbps down 510kbps up
>

--94eb2c09166c639b3505634aae98
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><div class=3D"gmail_quote"><div dir=3D"ltr">On Sun, =
Jan 21, 2018, 11:40 Russell King - ARM Linux &lt;<a href=3D"mailto:linux@ar=
mlinux.org.uk" target=3D"_blank" rel=3D"noreferrer">linux@armlinux.org.uk</=
a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Sat, Jan 20, 2018 =
at 01:06:09PM -0800, Dan Williams wrote:<br>
&gt; +/*<br>
&gt; + * If idx is negative or if idx &gt; size then bit 63 is set in the m=
ask,<br>
&gt; + * and the value of ~(-1L) is zero. When the mask is zero, bounds che=
ck<br>
&gt; + * failed, array_ptr will return NULL.<br>
<br>
The more times I see this the more times I&#39;m unhappy with this comment:=
<br>
<br>
1. does this really mean &quot;idx &gt; size&quot; or &quot;idx &gt;=3D siz=
e&quot; ?=C2=A0 The code<br>
=C2=A0 =C2=A0implements the latter not the former.<br></blockquote></div></=
div><div dir=3D"auto"><br></div><div dir=3D"auto">Copying the code here for=
 context:</div><div dir=3D"auto"><span style=3D"font-family:sans-serif;font=
-size:12.8px">return ~(long)(idx | (sz - 1 - idx)) &gt;&gt; (BITS_PER_LONG =
- 1);</span><br></div><div dir=3D"auto"><br></div><div dir=3D"auto">That pa=
rt of the condition (ignoring the overflow edgecases) is equivalent to &quo=
t;!(idx &gt; sz - 1)&quot;, which is equivalent to &quot;idx &lt;=3D sz - 1=
&quot;, which is (ignoring overflow edgecases) equivalent to &quot;idx &lt;=
 sz&quot;.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Handling of e=
dgecases:</div><div dir=3D"auto">idx&gt;=3D2^(BITS_PER_LONG-1) will cause a=
 NULL return through the first part of the condition.</div><div dir=3D"auto=
">Hmm... a problematic case might be &quot;sz=3D=3D0 &amp;&amp; idx=3D=3D<s=
pan style=3D"font-family:sans-serif">2^(BITS_PER_LONG-1)-1&quot;. The first=
 part of the expression wouldn&#39;t trigger, the second part would be &quo=
t;2^(BITS_PER_LONG)-1-(</span><span style=3D"font-family:sans-serif">2^(BIT=
S_PER_LONG-1)-1) =3D=3D=C2=A0</span><span style=3D"font-family:sans-serif">=
2^(BITS_PER_LONG)-</span><span style=3D"font-family:sans-serif">2^(BITS_PER=
_LONG-1) =3D=3D=C2=A0</span><span style=3D"font-family:sans-serif">2^(BITS_=
PER_LONG-1)&quot;, which also wouldn&#39;t trigger, I think?</span></div><d=
iv dir=3D"auto"><br></div><div dir=3D"auto"><div class=3D"gmail_quote"><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex">
2. is &quot;bit 63&quot; relevant here - what if longs are 32-bit?=C2=A0 &q=
uot;the top bit&quot;<br>
=C2=A0 =C2=A0or &quot;the sign bit&quot; would be better.<br>
<br>
3. &quot;and the value of ~(-1L) is zero.&quot;=C2=A0 So does this mean tha=
t when<br>
=C2=A0 =C2=A00 &lt;=3D idx &lt; size, somehow the rules of logic change and=
 ~(-1L)<br>
=C2=A0 =C2=A0magically becomes no longer zero!<br>
<br>
I&#39;d suggest changing the description to something like:<br>
<br>
=C2=A0 * If 0 &lt;=3D idx &lt; size, return a mask of ~0UL, otherwise retur=
n zero.<br>
<br>
or:<br>
<br>
=C2=A0 * When idx is out of bounds (iow, is negative or idx &gt;=3D sz), th=
e sign<br>
=C2=A0 * bit will be set. Extend the sign bit to all bits and invert, givin=
g<br>
=C2=A0 * a result of zero for an out of bounds idx, or ~0UL if within bound=
s.<br>
<br>
depending on how deeply you want to describe what&#39;s going on here.<br>
<br>
--<br>
RMK&#39;s Patch system: <a href=3D"http://www.armlinux.org.uk/developer/pat=
ches/" rel=3D"noreferrer noreferrer noreferrer" target=3D"_blank">http://ww=
w.armlinux.org.uk/developer/patches/</a><br>
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps u=
p<br>
According to <a href=3D"http://speedtest.net" rel=3D"noreferrer noreferrer =
noreferrer" target=3D"_blank">speedtest.net</a>: 8.21Mbps down 510kbps up<b=
r>
</blockquote></div></div></div>

--94eb2c09166c639b3505634aae98--
