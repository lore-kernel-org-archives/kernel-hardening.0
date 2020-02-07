Return-Path: <SRS0=svZm=33=lists.openwall.com=kernel-hardening-return-17727-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B383C2D0B1
	for <kernel-hardening@archiver.kernel.org>; Fri,  7 Feb 2020 07:24:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BF49C21741
	for <kernel-hardening@archiver.kernel.org>; Fri,  7 Feb 2020 07:24:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cAVdz1Cm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF49C21741
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17727-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28290 invoked by uid 550); 7 Feb 2020 07:24:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28262 invoked from network); 7 Feb 2020 07:24:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DxUqg8wrwusThXt0eFeBc0y4uk1czUM5aCSopm/x3tI=;
        b=cAVdz1Cm84ruGfIpBvlppTP6X+HFeqv8Z18BMDBokfR+m0Oz5rIBa8YvZRS811qgYS
         bES9KMKOAebbbI22c8JfvvnfT66EymkAnziMJUJfTXvKm1SdRMgbuUoftHSwXH7ugq79
         ilmYSacaIQr3PZQRyeEfjmWLgAN9hBh7TQOwwBvALyLejXbvDtzDx8pwzNVsyPSdPes6
         M2e21il1A7v5JlPorHBnszKfSXH7ua/HT0OS9s6wtusl6HoJPjgqZ69YMi399oChJPSA
         CYCWtcNQqPgg2vmHOQGGD0pPeU388HnZIDA3nOe2MGtNNufgg7javwnpa+7pdSqqeLyk
         Xsbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DxUqg8wrwusThXt0eFeBc0y4uk1czUM5aCSopm/x3tI=;
        b=QgTwZxynV2SHHUqSUBAmp9sNQQ6FWVns9VNdFtD3TgxK4zd9+0yvhe7xc3yT0+KfHe
         HlJm3vwtHSdQkBjiratpWOSPqzIN29m7jcF6TkSCvgT6N+SREBjf/VYUBsUk1++qRQvj
         VUgxL4+v9GenStB0yaTAV8kWA8MGJrEkbHLJHF626O4G4eqNoHgKnTGM94CpK35hkSDb
         10geWxvMknj+Wmt/xIRNZdOkZQUbqUThc/tFZUmq7H2aV0XpciX0XCfY/ZMuVamDUVkG
         CIFrtMMyzQguZ/BJ2UaRgxqEi6rYagMTtYAHNRVSxXEdcFyjSfpb4G9bU+G+apeOxP9/
         TwQg==
X-Gm-Message-State: APjAAAUrvKqMyekaMLl4+Lwtb02gYp+jW0MaqD2jYNWm8E1pPnNwxTfg
	2FTxijf0YHT8U6YvH7ooDVm/Dv1B1pqlU1r29K0=
X-Google-Smtp-Source: APXvYqzqk+ROe/x18BMhepXyBYLxUA1AO8ZEaLpWKGarvfWo88vLnvnWyoUyfnZssnqBbyAS4LV4WunX8/nYxIEy4OE=
X-Received: by 2002:a5d:6ac4:: with SMTP id u4mr2928629wrw.318.1581060243980;
 Thu, 06 Feb 2020 23:24:03 -0800 (PST)
MIME-Version: 1.0
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-5-kristen@linux.intel.com> <20200206151001.GA280489@zx2c4.com>
In-Reply-To: <20200206151001.GA280489@zx2c4.com>
From: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Date: Fri, 7 Feb 2020 08:23:53 +0100
Message-ID: <CAGiyFdes26XnNeDfaz-vkm+bU7MBYQiK3xty2EigGjOXBGui2w@mail.gmail.com>
Subject: Re: [RFC PATCH 04/11] x86/boot/KASLR: Introduce PRNG for faster shuffling
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, keescook@chromium.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com, arjan@linux.intel.com, 
	rick.p.edgecombe@intel.com, x86@kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
Content-Type: multipart/alternative; boundary="00000000000036047f059df74698"

--00000000000036047f059df74698
Content-Type: text/plain; charset="UTF-8"

Let me share my 2 cents:

That permutation might be safe but afaict it hasn't been analyzed wrt
modern cryptographic techniques and there might well be differential
characteristics, statistical biases, etc.

What about just using SipHash's permutation, already in the kernel? It
works on 4*u64 words too, and 6 rounds would be enough.

Doing a basic ops count, we currently have 5 group operations and 3
rotations per round or 150 and 90 for the 30 init rounds. With SipHash it'd
be 48 and 36 with the proposed 6 rounds. Probably insignificant speed wise
as init is only done once but just to show that we'd get both better
security assurance and better performance.


On Thu, Feb 6, 2020 at 4:10 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> Hey Kees,
>
> On Wed, Feb 05, 2020 at 02:39:43PM -0800, Kristen Carlson Accardi wrote:
> > +#define rot(x, k) (((x)<<(k))|((x)>>(64-(k))))
> > +static u64 prng_u64(struct prng_state *x)
> > +{
> > +     u64 e;
> > +
> > +     e = x->a - rot(x->b, 7);
> > +     x->a = x->b ^ rot(x->c, 13);
> > +     x->b = x->c + rot(x->d, 37);
> > +     x->c = x->d + e;
> > +     x->d = e + x->a;
> > +
> > +     return x->d;
> > +}
>
> I haven't looked closely at where the original entropy sources are
> coming from and how all this works, but on first glance, this prng
> doesn't look like an especially cryptographically secure one. I realize
> that isn't necessarily your intention (you're focused on speed), but
> actually might this be sort of important? If I understand correctly, the
> objective of this patch set is so that leaking the address of one
> function doesn't leak the address of all other functions, as is the case
> with fixed-offset kaslr. But if you leak the addresses of _some_ set of
> functions, and your prng is bogus, might it be possible to figure out
> the rest? For some prngs, if you give me the output stream of a few
> numbers, I can predict the rest. For others, it's not this straight
> forward, but there are some varieties of similar attacks. If any of that
> set of concerns turns out to apply to your prng_u64 here, would that
> undermine kaslr in similar ways as the current fixed-offset variety? Or
> does it not matter because it's some kind of blinded fixed-size shuffle
> with complex reasoning that makes this not a problem?
>
> Jason
>

--00000000000036047f059df74698
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Let me share my 2 cents:<div><br></div><div>That permutati=
on might be safe but afaict it hasn&#39;t been analyzed wrt modern cryptogr=
aphic techniques and there might well be differential characteristics, stat=
istical biases, etc.=C2=A0</div><div><br></div><div>What about just using S=
ipHash&#39;s permutation, already in the kernel? It works on 4*u64 words to=
o, and 6 rounds would be enough.=C2=A0</div><div><br></div><div>Doing a bas=
ic ops count, we currently have 5 group operations and 3 rotations per roun=
d or 150 and 90 for the 30 init rounds. With SipHash it&#39;d be 48 and 36 =
with the proposed 6 rounds. Probably insignificant speed wise as init is on=
ly done once but just to show that we&#39;d get both better security assura=
nce and better performance.</div><div><br></div></div><br><div class=3D"gma=
il_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Feb 6, 2020 at 4:10=
 PM Jason A. Donenfeld &lt;<a href=3D"mailto:Jason@zx2c4.com">Jason@zx2c4.c=
om</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex=
">Hey Kees,<br>
<br>
On Wed, Feb 05, 2020 at 02:39:43PM -0800, Kristen Carlson Accardi wrote:<br=
>
&gt; +#define rot(x, k) (((x)&lt;&lt;(k))|((x)&gt;&gt;(64-(k))))<br>
&gt; +static u64 prng_u64(struct prng_state *x)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0u64 e;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0e =3D x-&gt;a - rot(x-&gt;b, 7);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0x-&gt;a =3D x-&gt;b ^ rot(x-&gt;c, 13);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0x-&gt;b =3D x-&gt;c + rot(x-&gt;d, 37);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0x-&gt;c =3D x-&gt;d + e;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0x-&gt;d =3D e + x-&gt;a;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return x-&gt;d;<br>
&gt; +}<br>
<br>
I haven&#39;t looked closely at where the original entropy sources are<br>
coming from and how all this works, but on first glance, this prng<br>
doesn&#39;t look like an especially cryptographically secure one. I realize=
<br>
that isn&#39;t necessarily your intention (you&#39;re focused on speed), bu=
t<br>
actually might this be sort of important? If I understand correctly, the<br=
>
objective of this patch set is so that leaking the address of one<br>
function doesn&#39;t leak the address of all other functions, as is the cas=
e<br>
with fixed-offset kaslr. But if you leak the addresses of _some_ set of<br>
functions, and your prng is bogus, might it be possible to figure out<br>
the rest? For some prngs, if you give me the output stream of a few<br>
numbers, I can predict the rest. For others, it&#39;s not this straight<br>
forward, but there are some varieties of similar attacks. If any of that<br=
>
set of concerns turns out to apply to your prng_u64 here, would that<br>
undermine kaslr in similar ways as the current fixed-offset variety? Or<br>
does it not matter because it&#39;s some kind of blinded fixed-size shuffle=
<br>
with complex reasoning that makes this not a problem?<br>
<br>
Jason<br>
</blockquote></div>

--00000000000036047f059df74698--
