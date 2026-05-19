Return-Path: <kernel-hardening-return-22008-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 83673CD4F54
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 May 2026 21:42:20 +0000 (UTC)
Received: (qmail 15563 invoked by uid 550); 19 May 2026 21:41:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19691 invoked from network); 19 May 2026 21:32:06 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1779226317; cv=none;
        d=google.com; s=arc-20240605;
        b=Q6dmfTlgRKxqKzQcOI1M2TplFcCD8tfONzhn3Ud+v/1rtI5Q0AgAu+qfsXe1mQ2rgi
         b7mYQ/wXaLM2P2laoYoz7hF4T7S+qIkHwxEgi5iqZFvHz6s4P9r5fQ+af6ctcil+t2f8
         8dNt/HU2nealBBC7Kh/vniM1sMQAXi1cT1X9B3q3sjuwp0fOIGpIMUN0tHEXbmPBg6bQ
         x9ewJVwgNjx4mPqHje4DZx9wIw3+uwsOitxJE0tac/DfpG8PhRBfR4fjGaWjI1HkZJFE
         rZySpI+zy2U12HhiCyizjNEHQR17N1jQPqg5n5Z5ai3P0vdY+6N1VJRXTBRgyszABPow
         HHxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bQ8THDZ01faz2OJpFzxaxhIaM0owGhduryMkauZF9z0=;
        fh=X4RcdA7M2UTYMEGzXJKn/XpAMhudF8TCe7qfTfWwH6U=;
        b=gWbI1k2vuFh/Oqv9/noMZzdW06advP8a/718XU3VPGsMAZCSPlrNM6Dz5ZbpS/hj4l
         ujJQIlnrxgTDDNOBycSCIiw6+wRC24eOoOHJcX8dqcCKX7iw3Wlhv4xefOU62JY5pT8p
         M04nPKF8XYCSB9EouE1E1tVEmGLUbOmvitK6hJX+URcE0H6frdE4+whV84nE/hCyvXro
         mzC2lzB+Auk6mHm3dl5pFYqu9Vr6+TrXrHu1Q7Y4iRelmH8Dfk4W9f8zhs4loDPJB/Ze
         PJaQ/JN7edkOviGwNIqZGKohmZfteftxEtPnaIUiU9wXo0FzWo9LUShd0phtjVImaVWu
         dliw==;
        darn=lists.openwall.com
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779226317; x=1779831117; darn=lists.openwall.com;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bQ8THDZ01faz2OJpFzxaxhIaM0owGhduryMkauZF9z0=;
        b=Y0KR7wos1tCm74tIv2VoHtfsaESWVlJqi3aQV0uHX90xyLBQO5KuMRlgiiTg2vsBui
         HJQE7cmoqJnARhUir0YBt1rB8u5EHsMXPIV0YaD+jRKF8PFVJ5pSustjNbZ7pkGh4mNj
         QVqCWEl8Q4yzihODSmUWvMVLRsjbGsNRC+RH6FoOwCjCTxE6CTEdtWWoC0hFZ3pKNdeW
         BOt+YQiaVIL2d8zka8Gq3tJhTvhsZiegj1sz9RFxOoyJ34pqCpyVF6EiwOn9jAgB1Agx
         pSil+ItCvNv4jEEBBWd2Ll+HtlEoP00UGGELv67dCj1awXIhVxtDyLVKYQ1jOf6E3tkW
         M+dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779226317; x=1779831117;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bQ8THDZ01faz2OJpFzxaxhIaM0owGhduryMkauZF9z0=;
        b=Apgu0apUratKmhksObuU8oBXfG2fHlLyds5tBERjdMSGX9wAUM3tUXQmxTvodXaLfC
         3XM71KxkYPuZjsKEVENeHyMZVLyIgnCWHycgL0p2lL+LFjL3xF5bW4F4Oehhg34k6sjx
         qo6jaBCsst8X3hcy7D+9io8GzHadfVR3bcJaWZSP8C6XeIVzeEmT8F/A0W1CghK+mxDK
         DF9slhpRVCkn0hSohQBVZJ/ziJnVkp9aUO7h4WMFZgRqWy8cVPASaAePKXp0XlrL8YQW
         heXM9j9CmKk0QUQxqENNd8bra5tIoeKbIXcftcTCUyauhOnECDfRluJlqnwtLoj34p62
         mAkQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Z44WTcpThpWWfs5hWhRdt/Ipw5pwbRMdPgCF1naPrMEyuVQ3J4uW5BwoVQ53TWLnOCqXOEWPmkgmx06TZGmmx@lists.openwall.com
X-Gm-Message-State: AOJu0YwwNTXAmJ1hJvtCICFjo5Ot8lr+bWYww8ihGSimbzKg3J6E8bNr
	/o6tGc4rw/C7vHB4ZR/+w4Mt9Ws5mv4YC8rvNSCowmaTg+KraJHF59Dp9qC6mYLd/MqhhbBqVas
	9n0pNzrxyX484Goee2tWiiAOv7zHZqYQ=
X-Gm-Gg: Acq92OHXGzjLENNTJOuL8yp+C4Vwb7z4SbSRJEqUmZc07M1yiV65y8ZuzYvMFYtHoe3
	VWbG66IfW++C/o83Qwe+EKls892ummJsFnJXZ+FnsHawXj+Z4TleatNhzM+0wwSX8E5sPi3Rq1D
	qpzzSLY0ZHRQHP2EGnRWmTfY2xYHalgd8+9ixcG+m7X38ongiRdU+8lYkFKLexyyi7TNoSvVqa/
	uNON2HPjNAUQUBL1zGpF4FtYGGe5WxzLBQ1NwG1Hll7vEAbJrvHS9Of4ZXL8jmpjJEZAGjvJU15
	YCqyAvoYFwLDQqbaX8A=
X-Received: by 2002:a17:907:3e1d:b0:bd9:2b46:99b0 with SMTP id
 a640c23a62f3a-bd92b46ac04mr318962266b.49.1779226317237; Tue, 19 May 2026
 14:31:57 -0700 (PDT)
MIME-Version: 1.0
References: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com> <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com>
In-Reply-To: <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com>
From: Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
Date: Wed, 20 May 2026 00:31:45 +0300
X-Gm-Features: AVHnY4L4Y-5gKrbCMYxVYBedA_uSwgHTT7X14oTDJT5fjjB4iOMz-I5Pux6tIC0
Message-ID: <CAAmtCfMHqdWbYh-Hc5sGbOhXSM-aCA9G0-s64G8FTM+rGEV5RA@mail.gmail.com>
Subject: Re: [RFC] TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: Jann Horn <jannh@google.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000009d310f065232683c"

--0000000000009d310f065232683c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you for your questions. I'll address each one:

=3D=3D 1. Threat Model =3D=3D

The target scenario is a same-machine attacker
in multi-tenant/cloud environments where two
processes share physical L3 cache.

Example: a cryptographic service and a malicious
process running on the same host. The attacker
uses Flush+Reload to measure cache access timing
after every encryption operation =E2=80=94 no physical
access required.

This is documented with real measurements:
- Without TID: 78 cycles (Cache HIT =E2=80=94 key pattern visible)
- With TID v2.0: 286 cycles (Cache MISS =E2=80=94 attack defeated)

The 78-cycle result proves the data remains in
cache after memzero. If cache eviction happened
automatically, we would always see 286 cycles.

Full threat model: Section 2.1 of the paper.
Timing analysis: Section 5.2.

=3D=3D 2. Why Kernel Module and not userspace? =3D=3D

You are correct that CLFLUSHOPT does not require
Ring 0. However, userspace execution can be
interrupted by a Context Switch, which expands
the timing window from 372ns to 36,640ns =E2=80=94
making the attack significantly easier.

The Kernel Module guarantees:
- Non-preemption during the PROTECT+ZERO sequence
- Atomic execution across wipe + flush + barrier
- Reliable page locking via pin_user_pages_fast

This is documented in Section 5.2 and Section 5.4.

A userspace library implementation is a valid
alternative and is noted as future work =E2=80=94 the
goal is eventually integrating CLFLUSHOPT
directly into libsodium and OpenSSL.

=3D=3D 3. Why not add this directly to libraries? =3D=3D

No major security library implements CLFLUSHOPT
after wiping =E2=80=94 not OpenSSL, not libsodium, not
glibc, not memzero_explicit. This gap has existed
since Flush+Reload was published in 2014.

TID is a proof of concept that demonstrates the
PROTECT+ZERO protocol works. The next step is
proposing integration into existing libraries.

Full comparison table: Section 2.3 of the paper.

=3D=3D References =3D=3D

DOI: https://doi.org/10.5281/zenodo.17585929
GitHub: https://github.com/ahmaaaaadbntaaaaa-byte/
TID-The-Instant-Destroyer

Sections 2.1, 2.3, 5.2, 5.4 address your points
in detail.

Regards,
Ahmad Qasim Mohammad Hassan
Independent Hardware Security Researcher
ORCID: 0009-0001-4360-0802

=D9=81=D9=8A =D8=A7=D9=84=D8=AB=D9=84=D8=A7=D8=AB=D8=A7=D8=A1=D8=8C =D9=A1=
=D9=A9 =D9=85=D8=A7=D9=8A=D9=88 =D9=A2=D9=A0=D9=A2=D9=A6, =D9=A7:=D9=A4=D9=
=A7 =D9=85 Jann Horn <jannh@google.com> =D9=83=D8=AA=D8=A8:

> On Mon, May 18, 2026 at 11:47=E2=80=AFPM Ahmed Hassan
> <ahmaaaaadbntaaaaa@gmail.com> wrote:
> >
> > Hi kernel developers,
> >
> > I am sharing TID (The Instant Destroyer) v2.0, a Linux kernel module
> > written in C that addresses a specific gap in existing security
> > libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)
> > flush CPU cache lines after memory zeroization.
> >
> >
> > =3D=3D Problem =3D=3D
> >
> > Standard zeroization functions (explicit_bzero, sodium_memzero,
> > OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do
> > not evict CPU cache lines (L1/L2/L3). This leaves residual key
> > material measurable via Flush+Reload (Yarom & Falkner, 2014) after
> > data use ends.
>
> The thing you're talking about isn't really related to the
> Flush+Reload side channel attack, right? You're just talking about
> flushing cache lines.
>
> In what threat model would this be an issue? Normally, the goal of
> memory zeroing is to ensure that sensitive data is wiped before an
> attacker has a chance to physically pull out the RAM from a machine
> and plug it into another device that can reveal RAM contents, or
> before an attacker gains physical control of a locked device and can
> connect malicious peripherals to it, or such.
>
> So for this to be an actual security problem, the device would have to
> keep running in a sufficiently high power state that data caches are
> not discarded, and at the same time not perform enough memory accesses
> to cause this memory to be discarded...
>
> Assuming that this is an actual problem, why are you using a kernel
> module for this? At least on x86, CLFLUSH is unprivileged, so crypto
> libraries should be able to just use that directly. (There is the
> caveat of what happens when the kernel migrates pages or kills a
> process, but that's a larger problem.)
>

--0000000000009d310f065232683c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Thank you for your questions. I&#39;ll address each one:<=
div dir=3D"auto"><br></div><div dir=3D"auto">=3D=3D 1. Threat Model =3D=3D<=
/div><div dir=3D"auto"><br></div><div dir=3D"auto">The target scenario is a=
 same-machine attacker=C2=A0</div><div dir=3D"auto">in multi-tenant/cloud e=
nvironments where two=C2=A0</div><div dir=3D"auto">processes share physical=
 L3 cache.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Example: a cr=
yptographic service and a malicious=C2=A0</div><div dir=3D"auto">process ru=
nning on the same host. The attacker=C2=A0</div><div dir=3D"auto">uses Flus=
h+Reload to measure cache access timing=C2=A0</div><div dir=3D"auto">after =
every encryption operation =E2=80=94 no physical=C2=A0</div><div dir=3D"aut=
o">access required.</div><div dir=3D"auto"><br></div><div dir=3D"auto">This=
 is documented with real measurements:</div><div dir=3D"auto">- Without TID=
: 78 cycles (Cache HIT =E2=80=94 key pattern visible)</div><div dir=3D"auto=
">- With TID v2.0: 286 cycles (Cache MISS =E2=80=94 attack defeated)</div><=
div dir=3D"auto"><br></div><div dir=3D"auto">The 78-cycle result proves the=
 data remains in=C2=A0</div><div dir=3D"auto">cache after memzero. If cache=
 eviction happened=C2=A0</div><div dir=3D"auto">automatically, we would alw=
ays see 286 cycles.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Full=
 threat model: Section 2.1 of the paper.</div><div dir=3D"auto">Timing anal=
ysis: Section 5.2.</div><div dir=3D"auto"><br></div><div dir=3D"auto">=3D=
=3D 2. Why Kernel Module and not userspace? =3D=3D</div><div dir=3D"auto"><=
br></div><div dir=3D"auto">You are correct that CLFLUSHOPT does not require=
=C2=A0</div><div dir=3D"auto">Ring 0. However, userspace execution can be=
=C2=A0</div><div dir=3D"auto">interrupted by a Context Switch, which expand=
s=C2=A0</div><div dir=3D"auto">the timing window from 372ns to 36,640ns =E2=
=80=94=C2=A0</div><div dir=3D"auto">making the attack significantly easier.=
</div><div dir=3D"auto"><br></div><div dir=3D"auto">The Kernel Module guara=
ntees:</div><div dir=3D"auto">- Non-preemption during the PROTECT+ZERO sequ=
ence</div><div dir=3D"auto">- Atomic execution across wipe + flush + barrie=
r</div><div dir=3D"auto">- Reliable page locking via pin_user_pages_fast</d=
iv><div dir=3D"auto"><br></div><div dir=3D"auto">This is documented in Sect=
ion 5.2 and Section 5.4.</div><div dir=3D"auto"><br></div><div dir=3D"auto"=
>A userspace library implementation is a valid=C2=A0</div><div dir=3D"auto"=
>alternative and is noted as future work =E2=80=94 the=C2=A0</div><div dir=
=3D"auto">goal is eventually integrating CLFLUSHOPT=C2=A0</div><div dir=3D"=
auto">directly into libsodium and OpenSSL.</div><div dir=3D"auto"><br></div=
><div dir=3D"auto">=3D=3D 3. Why not add this directly to libraries? =3D=3D=
</div><div dir=3D"auto"><br></div><div dir=3D"auto">No major security libra=
ry implements CLFLUSHOPT=C2=A0</div><div dir=3D"auto">after wiping =E2=80=
=94 not OpenSSL, not libsodium, not=C2=A0</div><div dir=3D"auto">glibc, not=
 memzero_explicit. This gap has existed=C2=A0</div><div dir=3D"auto">since =
Flush+Reload was published in 2014.</div><div dir=3D"auto"><br></div><div d=
ir=3D"auto">TID is a proof of concept that demonstrates the=C2=A0</div><div=
 dir=3D"auto">PROTECT+ZERO protocol works. The next step is=C2=A0</div><div=
 dir=3D"auto">proposing integration into existing libraries.</div><div dir=
=3D"auto"><br></div><div dir=3D"auto">Full comparison table: Section 2.3 of=
 the paper.</div><div dir=3D"auto"><br></div><div dir=3D"auto">=3D=3D Refer=
ences =3D=3D</div><div dir=3D"auto"><br></div><div dir=3D"auto">DOI: <a hre=
f=3D"https://doi.org/10.5281/zenodo.17585929">https://doi.org/10.5281/zenod=
o.17585929</a></div><div dir=3D"auto">GitHub: <a href=3D"https://github.com=
/ahmaaaaadbntaaaaa-byte/">https://github.com/ahmaaaaadbntaaaaa-byte/</a></d=
iv><div dir=3D"auto">TID-The-Instant-Destroyer</div><div dir=3D"auto"><br><=
/div><div dir=3D"auto">Sections 2.1, 2.3, 5.2, 5.4 address your points=C2=
=A0</div><div dir=3D"auto">in detail.</div><div dir=3D"auto"><br></div><div=
 dir=3D"auto">Regards,</div><div dir=3D"auto">Ahmad Qasim Mohammad Hassan</=
div><div dir=3D"auto">Independent Hardware Security Researcher</div><div di=
r=3D"auto">ORCID: 0009-0001-4360-0802</div></div><br><div class=3D"gmail_qu=
ote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">=D9=81=D9=
=8A =D8=A7=D9=84=D8=AB=D9=84=D8=A7=D8=AB=D8=A7=D8=A1=D8=8C =D9=A1=D9=A9 =D9=
=85=D8=A7=D9=8A=D9=88 =D9=A2=D9=A0=D9=A2=D9=A6, =D9=A7:=D9=A4=D9=A7 =D9=85 =
Jann Horn &lt;<a href=3D"mailto:jannh@google.com">jannh@google.com</a>&gt; =
=D9=83=D8=AA=D8=A8:<br></div><blockquote class=3D"gmail_quote" style=3D"mar=
gin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Mon, May 18,=
 2026 at 11:47=E2=80=AFPM Ahmed Hassan<br>
&lt;<a href=3D"mailto:ahmaaaaadbntaaaaa@gmail.com" target=3D"_blank" rel=3D=
"noreferrer">ahmaaaaadbntaaaaa@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Hi kernel developers,<br>
&gt;<br>
&gt; I am sharing TID (The Instant Destroyer) v2.0, a Linux kernel module<b=
r>
&gt; written in C that addresses a specific gap in existing security<br>
&gt; libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)<b=
r>
&gt; flush CPU cache lines after memory zeroization.<br>
&gt;<br>
&gt;<br>
&gt; =3D=3D Problem =3D=3D<br>
&gt;<br>
&gt; Standard zeroization functions (explicit_bzero, sodium_memzero,<br>
&gt; OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do<br=
>
&gt; not evict CPU cache lines (L1/L2/L3). This leaves residual key<br>
&gt; material measurable via Flush+Reload (Yarom &amp; Falkner, 2014) after=
<br>
&gt; data use ends.<br>
<br>
The thing you&#39;re talking about isn&#39;t really related to the<br>
Flush+Reload side channel attack, right? You&#39;re just talking about<br>
flushing cache lines.<br>
<br>
In what threat model would this be an issue? Normally, the goal of<br>
memory zeroing is to ensure that sensitive data is wiped before an<br>
attacker has a chance to physically pull out the RAM from a machine<br>
and plug it into another device that can reveal RAM contents, or<br>
before an attacker gains physical control of a locked device and can<br>
connect malicious peripherals to it, or such.<br>
<br>
So for this to be an actual security problem, the device would have to<br>
keep running in a sufficiently high power state that data caches are<br>
not discarded, and at the same time not perform enough memory accesses<br>
to cause this memory to be discarded...<br>
<br>
Assuming that this is an actual problem, why are you using a kernel<br>
module for this? At least on x86, CLFLUSH is unprivileged, so crypto<br>
libraries should be able to just use that directly. (There is the<br>
caveat of what happens when the kernel migrates pages or kills a<br>
process, but that&#39;s a larger problem.)<br>
</blockquote></div>

--0000000000009d310f065232683c--
