Return-Path: <kernel-hardening-return-22005-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 36B50CD4F4A
	for <kernel-hardening@archiver.kernel.org>; Mon, 18 May 2026 21:47:35 +0000 (UTC)
Received: (qmail 30301 invoked by uid 550); 18 May 2026 21:47:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8050 invoked from network); 18 May 2026 21:40:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779140403; x=1779745203; darn=lists.openwall.com;
        h=content-transfer-encoding:mime-version:message-id:user-agent
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u3x/laSl/cXThLkBNBE4Ng9WrKRc2pOzPBZ0vXrjTrQ=;
        b=svCQ1+JURKTcn9PT8ueoKMzgFkbOZfXskdkp3l45JYykr+c9yZk0JVuxtz+0qEh7f1
         J1D+SDPevE8vqCCnaqOw/GjCaRH7lOyNu1XW+JBI92wILjVrwc+3FT2sfvbTuiHCWxte
         m/4Z8E+cZROqb6PfUozW1lqvEA4HbdpI1LyOvEenDTnhT1ANj7efEeViX5XVCe3pzyF0
         UtplBZcyklDykWyUOCI4bfrpFju/b1u4oeN5grhySYuv2kQh0OhnBdYIINu/ko1XL8H+
         +fKS8sAwWozdTjD8ckX4T5SIuj6SLJbkkPqfaRYFpIHuyttybwfwOLGryXFw0zk23RzW
         nYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779140403; x=1779745203;
        h=content-transfer-encoding:mime-version:message-id:user-agent
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3x/laSl/cXThLkBNBE4Ng9WrKRc2pOzPBZ0vXrjTrQ=;
        b=r7wVSU4I1Tw0z0i0LBGLvEMcWUi7mMBLPm+52TEo4ptxZXE6vRSAqJyOFrPX9BrbR7
         BND0kTYFJw3rxukug5mFqtJY3LuWvwWdncDve5pvB/CE6wB4wUrz/YtzPPMOzrAxhqij
         Jqamzl8IoVFytCpcFdjSr+NjAsAGS2KVGnNF6sn/iwhkYYODmFSHfEZewr8GKKKpM0aP
         why+QTQS8/hdg/DkTQqZ4ghwpmWDhRZnNFBU6I2n8Ysjap0bsnx1CfycGPMfwHnvIpep
         GO+oRTZVKH9SU2B5Nig3VwuIHOxvJKCIt+S9SZgyy8qwz1u7OkcIes10XqO2V4BHqQtn
         BCdA==
X-Forwarded-Encrypted: i=1; AFNElJ9hIZsCo3E/KstBBStRlWST1UErf2eEly+L046UQhb3wBRuPguyBJq/TW49tBo1M0xst7gUG9jx7VAfaWJdw4/Q@lists.openwall.com
X-Gm-Message-State: AOJu0YxxCMm+3iDPZUKUIX2wiUskRfjCxIMKFPn6P4LbyW3QGx81vc91
	0g5aGr5RxCTv8O4hmMdOIUl/8cfgrzA9J/WhHVCHEmSg6w34imdWXXqe
X-Gm-Gg: Acq92OFZTcjOw17hOLU0CarPoUy2KoVSsKVK4xNrP4F9uw1dmG+xwpVWtTIHVhEGiWR
	4a5c9FWydUtlh7mqYKC0dI5mVWfb5LaZwOdvPL6GBLao5fbcE1zrzju9TNpwkzvYL7fwG0rs5J2
	fMXHV2h93NmVRNITuCBq68TMj1XXp94vCsN0kWAxX5Z4VHozRJewLrjkGD8wVWhyo7K9d5JDhrG
	eddfOc40Um1q7x6qmZ7lnv7w0BWAg7dAQpmnruXsecPVLOZbGR8zaHa/2rlLDoTpEP4KHQAggbL
	y6ce5KtOqQZ4hvk2VGu/e3NgO5rQgt1w1X58FHQ1z43ugIdUWx+6tNR08FR5f66RaFyP2a6e+tp
	SLBaK9l/8QfL/Pf8oAUXHlLGm3fMY3R1vB+kDgzBRIU028nfEgCA0T3orWj/kLYJd4pjZzly0Sk
	lIk5tS6MG8To3NJrSxvSONyl2CoE75mw8zvdFWbwl6zpS2iA==
X-Received: by 2002:a05:600c:a010:b0:48f:e230:2a1e with SMTP id 5b1f17b1804b1-48fe66316cfmr247405255e9.33.1779140402904;
        Mon, 18 May 2026 14:40:02 -0700 (PDT)
Date: Tue, 19 May 2026 00:39:59 +0300
From: Ahmed Hassan <ahmaaaaadbntaaaaa@gmail.com>
To: linux-kernel@vger.kernel.org
CC: linux-security-module@vger.kernel.org, linux-hardening@vger.kernel.org,
 kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org,
 linux-mm@kvack.org, linux-api@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: =?US-ASCII?Q?=5BRFC=5D_TID_v2=2E0=3A_kernel_modu?=
 =?US-ASCII?Q?le_for_cache-line_zeroizatio?=
 =?US-ASCII?Q?n_against_Flush+Reload_=28CLFLUSHOPT_+_LFENCE_+_REP_STOSQ=29?=
User-Agent: K-9 Mail for Android
Message-ID: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary=----CDKNMF2C75Z7NW35JVKMW1L7XC4WCL
Content-Transfer-Encoding: 7bit

------CDKNMF2C75Z7NW35JVKMW1L7XC4WCL
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi kernel developers,

I am sharing TID (The Instant Destroyer) v2=2E0, a Linux kernel module
written in C that addresses a specific gap in existing security
libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)
flush CPU cache lines after memory zeroization=2E


=3D=3D Problem =3D=3D

Standard zeroization functions (explicit_bzero, sodium_memzero,
OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do
not evict CPU cache lines (L1/L2/L3)=2E This leaves residual key
material measurable via Flush+Reload (Yarom & Falkner, 2014) after
data use ends=2E


=3D=3D Approach: PROTECT+ZERO Protocol =3D=3D

TID combines three instructions in a single kernel module:

Phase 1 - PROTECT (before data use):
  LFENCE     <- close speculative execution window
  MFENCE     <- ensure all prior writes are complete

Phase 2 - ZERO (after data use):
  LFENCE     <- close speculation window
  REP STOSQ  <- compiler-resistant wipe
  CLFLUSHOPT <- evict all cache lines (L1/L2/L3)
  MFENCE     <- ensure eviction is complete
  LFENCE     <- close the far-side window

This follows directly the Intel Spectre Mitigation Guide (2018) and
AMD Speculative Execution Software Techniques (2018)=2E


=3D=3D Benchmark Results (AMD EPYC 9B14, Linux 6=2E14=2E11) =3D=3D

Without TID : attacker measures ~78 cycles  (Cache HIT)
With TID v2 : attacker measures ~286 cycles (Cache MISS)
Ratio       : 3=2E7x latency increase -- attack defeated

Physical lower bound confirmed:
  LFENCE (~40ns) + REP STOSQ (~50ns) + CLFLUSHOPT (~150ns)
  + MFENCE (~40ns) + LFENCE (~40ns) =3D ~320ns
  (measured: 290-372ns)


=3D=3D What Distinguishes TID =3D=3D

No major security library implements CLFLUSHOPT post-wipe eviction=2E
TID is the only known kernel-module-level implementation of the
PROTECT+ZERO protocol=2E


=3D=3D Known Limitations =3D=3D

- A 372ns window during data use remains (physical lower bound);
  v3=2E0 target via Intel CAT integration
- Requires same-machine attacker model (shared memory)
- Does not protect against cold-boot attacks
- Not a replacement for disk encryption


=3D=3D Project Details =3D=3D

License  : AGPL-3=2E0
Hardware : AMD EPYC 9B14 (Zen 4), x86_64
Kernel   : Linux 6=2E14=2E11
DOI      : https://doi=2Eorg/10=2E5281/zenodo=2E17585929
GitHub   : https://github=2Ecom/ahmaaaaadbntaaaaa-byte/The-Instant-Destroy=
er

Comments and technical criticism are welcome=2E

Regards,
Ahmad Qasim Mohammad Hassan
Independent Hardware Security Researcher
ORCID: 0009-0001-4360-0802
Ahmed Hassan 
------CDKNMF2C75Z7NW35JVKMW1L7XC4WCL
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html><html><body><div dir=3D"auto">Hi kernel developers,<br><br>I=
 am sharing TID (The Instant Destroyer) v2=2E0, a Linux kernel module<br>wr=
itten in C that addresses a specific gap in existing security<br>libraries:=
 none of them (libsodium, OpenSSL, glibc memzero_explicit)<br>flush CPU cac=
he lines after memory zeroization=2E<br><br><br>=3D=3D Problem =3D=3D<br><b=
r>Standard zeroization functions (explicit_bzero, sodium_memzero,<br>OPENSS=
L_cleanse) prevent the compiler from eliding the wipe, but do<br>not evict =
CPU cache lines (L1/L2/L3)=2E This leaves residual key<br>material measurab=
le via Flush+Reload (Yarom &amp; Falkner, 2014) after<br>data use ends=2E<b=
r><br><br>=3D=3D Approach: PROTECT+ZERO Protocol =3D=3D<br><br>TID combines=
 three instructions in a single kernel module:<br><br>Phase 1 - PROTECT (be=
fore data use):<br>=C2=A0 LFENCE=C2=A0=C2=A0=C2=A0=C2=A0 &lt;- close specul=
ative execution window<br>=C2=A0 MFENCE=C2=A0=C2=A0=C2=A0=C2=A0 &lt;- ensur=
e all prior writes are complete<br><br>Phase 2 - ZERO (after data use):<br>=
=C2=A0 LFENCE=C2=A0=C2=A0=C2=A0=C2=A0 &lt;- close speculation window<br>=C2=
=A0 REP STOSQ=C2=A0 &lt;- compiler-resistant wipe<br>=C2=A0 CLFLUSHOPT &lt;=
- evict all cache lines (L1/L2/L3)<br>=C2=A0 MFENCE=C2=A0=C2=A0=C2=A0=C2=A0=
 &lt;- ensure eviction is complete<br>=C2=A0 LFENCE=C2=A0=C2=A0=C2=A0=C2=A0=
 &lt;- close the far-side window<br><br>This follows directly the Intel Spe=
ctre Mitigation Guide (2018) and<br>AMD Speculative Execution Software Tech=
niques (2018)=2E<br><br><br>=3D=3D Benchmark Results (AMD EPYC 9B14, Linux =
6=2E14=2E11) =3D=3D<br><br>Without TID : attacker measures ~78 cycles=C2=A0=
 (Cache HIT)<br>With TID v2 : attacker measures ~286 cycles (Cache MISS)<br=
>Ratio=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : 3=2E7x latency increase -- att=
ack defeated<br><br>Physical lower bound confirmed:<br>=C2=A0 LFENCE (~40ns=
) + REP STOSQ (~50ns) + CLFLUSHOPT (~150ns)<br>=C2=A0 + MFENCE (~40ns) + LF=
ENCE (~40ns) =3D ~320ns<br>=C2=A0 (measured: 290-372ns)<br><br><br>=3D=3D W=
hat Distinguishes TID =3D=3D<br><br>No major security library implements CL=
FLUSHOPT post-wipe eviction=2E<br>TID is the only known kernel-module-level=
 implementation of the<br>PROTECT+ZERO protocol=2E<br><br><br>=3D=3D Known =
Limitations =3D=3D<br><br>- A 372ns window during data use remains (physica=
l lower bound);<br>=C2=A0 v3=2E0 target via Intel CAT integration<br>- Requ=
ires same-machine attacker model (shared memory)<br>- Does not protect agai=
nst cold-boot attacks<br>- Not a replacement for disk encryption<br><br><br=
>=3D=3D Project Details =3D=3D<br><br>License=C2=A0 : AGPL-3=2E0<br>Hardwar=
e : AMD EPYC 9B14 (Zen 4), x86_64<br>Kernel=C2=A0=C2=A0 : Linux 6=2E14=2E11=
<br>DOI=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 : <a href=3D"https://doi=2Eorg/10=2E5=
281/zenodo=2E17585929">https://doi=2Eorg/10=2E5281/zenodo=2E17585929</a><br=
>GitHub=C2=A0=C2=A0 : <a href=3D"https://github=2Ecom/ahmaaaaadbntaaaaa-byt=
e/The-Instant-Destroyer">https://github=2Ecom/ahmaaaaadbntaaaaa-byte/The-In=
stant-Destroyer</a><br><br>Comments and technical criticism are welcome=2E<=
br><br>Regards,<br>Ahmad Qasim Mohammad Hassan<br>Independent Hardware Secu=
rity Researcher<br>ORCID: 0009-0001-4360-0802</div><div dir=3D"auto">Ahmed =
Hassan </div></body></html>
------CDKNMF2C75Z7NW35JVKMW1L7XC4WCL--
