Return-Path: <kernel-hardening-return-22006-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 44253CD4F4A
	for <kernel-hardening@archiver.kernel.org>; Mon, 18 May 2026 23:53:08 +0000 (UTC)
Received: (qmail 5735 invoked by uid 550); 18 May 2026 23:52:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7842 invoked from network); 18 May 2026 23:14:12 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1779146044; cv=none;
        d=google.com; s=arc-20240605;
        b=OmkeolMN0nbJDSzeoduP0zFWRiK/JrEALbAhds0dgZ8dT/SI0bSxo68zikNSMI8dza
         QqRyg34529mlGyISIR+4S2Cp78qy1D5F8+sYKX5bLy9t+TdDy1rB91sr1VxkFRDyTFfU
         hemYnHfaNtsgiz57C8HYv/LLJ1L1uvmNboGhIUsCHDr1qEJZ6pkY0oOaI/X5HEcWtW8b
         2rRNo/2S86nY689kGlxONzOCh2kJ7qKdSGfWZIC3PuD+Oz9esJASviNWKA4PwUpcsmHw
         vwyYSKhOqEUeQhZUkw/4CjY9+lalV6KjnxS6UW42l0PFCX646gVzYqIwK/uLQ8g9fZPr
         qbgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=IKm5QKQR8VUeuWe4WzzPmriV1yZ8lMI2aWg9ysnRnEw=;
        fh=TzFRz6gxzkRmDL/yCLmRxubrbpuut7zSPLS8Mjk3xnY=;
        b=AfdcaqBDOy5omuetZBUuR3zpXJebpBfPhjAxYcdoGAMx/zL7gFR/YR3q3beTJMzA6M
         A+iEni5R0R0wtnT39E33wCcaXvMBwFK9y4sVm5NISpyfDjQTyQTl12R/R0oBf3TEy+hc
         uzuz/h3npNM6uP/w188PAfbvQc44F3bkiAHPHk1lTbGFAHIgZWUd35d3A076MK5bULD6
         OX1cg1REqAk1ralv/hCA14gzPTuXupnOUEy1y8bIOBIDmPgVFHFaLswlBdMZ8l7Nk7LH
         8oI876XECPIoa0WWpCPRuy+9WAvDhwxqQaxsB9gcBu5AzgBOY/0SpAFaWbS5TJvLjVEN
         +q5Q==;
        darn=lists.openwall.com
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779146044; x=1779750844; darn=lists.openwall.com;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=IKm5QKQR8VUeuWe4WzzPmriV1yZ8lMI2aWg9ysnRnEw=;
        b=hVenw/uVhvNiN/iFulX5U5zwC3ZfTtinarV49Yw7bsIIUW3IfajRYUxWiidx3h+DW+
         ly7ZzvUmKnP9oSQSulM9d2j53ni6D6uOZ4cnHF5XaMmca9XNJdKqFDu/+d5pFjATKBiN
         RL9cwKQm0cirqTiSn8pKTxg2XAbmShfMn9qXm8adzizP6h3aWRhVYpfoMYriLkTUN/sG
         Kv2Cw89FCT0zjF4Kd2wFf3w18paPRGUB/FUwXqodByZSj1ROpz/Va69QSycy/peVOBat
         emBeXmiFYMUVF3XFi8Ly07YvollemkpWWdEYphsZBJQC4uTV1s7TYx1XZU/bAVFdZ46N
         yiCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779146044; x=1779750844;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IKm5QKQR8VUeuWe4WzzPmriV1yZ8lMI2aWg9ysnRnEw=;
        b=lJRIYhqi7ohIVCeNtekmRuvBJMqid/9yV4aVGIrelFtad4OawU0gNS5vQwwnWWL/1x
         PwkKv+dEjjJGkMcIvXzKyR2vfmg57Ko8xMjYYmA+1h+WoJVMbGqa1NQPXUUZqL4vlzvH
         7MyVYm9CSJkonlqsKRT8a7b9WGVRMrl4WsRtB/7c3pMdyRMUsEJb8GYXAoCbvjHlUn9h
         YjUWPaFPqZa15KxNQBXyTxNeR6V/p5T8Rooa9L1tgmZJ8ab4ogXbTGUC4eg3oMcFlKRj
         8/m03tr4gyhGOvBiOXhBTHBGFYI4j1Vsj9r5a5yWVlWC2/A8lt1tLpzIvr49otWtpG5k
         erUQ==
X-Forwarded-Encrypted: i=1; AFNElJ+2n8ZnbQiXBtZ1XJ1Cdg9CKd8NfsA54NV5jmb1Ao/La4+CKOfTS+cdQk7SJvjwB9Wc0p6CmnxvK9BbOBnj6BPJ@lists.openwall.com
X-Gm-Message-State: AOJu0YyHjRY8I4o56zotueewX3A6ibapLyHQgrcA3sS7HmMRrkTCnmUx
	Rggl3GjTJTI17TJEmQSCVWDGcpcHkvqXxp5sTHJMkJQ+3Fj8gFLE8kjAn+aZL0RSb6HumDWWqLE
	5nvYNhOavDge5/EL/oiiEphXDq6Ixsvlk8QWrhF4=
X-Gm-Gg: Acq92OEzSfWZZ5RAGcZaxm6mxzeF4uhhKpAdFd8HJZqhDHCMH+8sqt8mLbR1+NL+pd6
	wm0IBuFrHG2MBRBujHG4IbHsq7w7P7Zcq5z7zjWc9fqbh1rvyHAcsnhqkA6HkRY1LYfj/5Gwyjy
	TPfl3B8j1Z2Ab/BjlLlUmwVmZyggzgOkXrWCPVBoap8PGdvoKj4FPcgi6YFtXJLQHXfnMj4nCbo
	KEARgSgw7IGiDP7iAhuqogKO32oXj2STtOH3Q66yy1M1RaYV9nPL54cvM77UFHwIWhGRJc2XnK5
	40SVWkg94fz80/XHWMNf
X-Received: by 2002:a05:6402:a0cb:b0:676:e619:2be0 with SMTP id
 4fb4d7f45d1cf-683b4b8f9e3mr6404463a12.8.1779146044056; Mon, 18 May 2026
 16:14:04 -0700 (PDT)
MIME-Version: 1.0
From: Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
Date: Tue, 19 May 2026 02:13:52 +0300
X-Gm-Features: AVHnY4Kcw5tfKaz7bxQUfTVohvsHtO1JypTsC2D_N4_NdgHolnz-i1HFCs2vz9c
Message-ID: <CAAmtCfPiwDmyycoON5bTjhaT9s0yPd1wWHvT+=PEd+J4OW1+gA@mail.gmail.com>
Subject: TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-mm@kvack.org, linux-crypto@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000f5a75806521fb7ab"

--000000000000f5a75806521fb7ab
Content-Type: text/plain; charset="UTF-8"

Hi kernel developers,

I am sharing TID (The Instant Destroyer) v2.0, a Linux kernel module
written in C that addresses a specific gap in existing security
libraries: none of them (libsodium, OpenSSL, glibc memzero_explicit)
flush CPU cache lines after memory zeroization.


== Problem ==

Standard zeroization functions (explicit_bzero, sodium_memzero,
OPENSSL_cleanse) prevent the compiler from eliding the wipe, but do
not evict CPU cache lines (L1/L2/L3). This leaves residual key
material measurable via Flush+Reload (Yarom & Falkner, 2014) after
data use ends.


== Approach: PROTECT+ZERO Protocol ==

TID combines three instructions in a single kernel module:

Phase 1 - PROTECT (before data use):
  LFENCE <- close speculative execution window
  MFENCE <- ensure all prior writes are complete

Phase 2 - ZERO (after data use):
  LFENCE <- close speculation window
  REP STOSQ <- compiler-resistant wipe
  CLFLUSHOPT <- evict all cache lines (L1/L2/L3)
  MFENCE <- ensure eviction is complete
  LFENCE <- close the far-side window

This follows directly the Intel Spectre Mitigation Guide (2018) and
AMD Speculative Execution Software Techniques (2018).


== Benchmark Results (AMD EPYC 9B14, Linux 6.14.11) ==

Without TID : attacker measures ~78 cycles (Cache HIT)
With TID v2 : attacker measures ~286 cycles (Cache MISS)
Ratio : 3.7x latency increase -- attack defeated

Physical lower bound confirmed:
  LFENCE (~40ns) + REP STOSQ (~50ns) + CLFLUSHOPT (~150ns)
  + MFENCE (~40ns) + LFENCE (~40ns) = ~320ns
  (measured: 290-372ns)


== What Distinguishes TID ==

No major security library implements CLFLUSHOPT post-wipe eviction.
TID is the only known kernel-module-level implementation of the
PROTECT+ZERO protocol.


== Known Limitations ==

- A 372ns window during data use remains (physical lower bound);
  v3.0 target via Intel CAT integration
- Requires same-machine attacker model (shared memory)
- Does not protect against cold-boot attacks
- Not a replacement for disk encryption


== Project Details ==

License : AGPL-3.0
Hardware : AMD EPYC 9B14 (Zen 4), x86_64
Kernel : Linux 6.14.11
DOI : https://doi.org/10.5281/zenodo.17585929
GitHub : https://github.com/ahmaaaaadbntaaaaa-byte/The-Instant-Destroyer

Comments and technical criticism are welcome.

Regards,
Ahmad Qasim Mohammad Hassan
Independent Hardware Security Researcher
ORCID: 0009-0001-4360-0802

--000000000000f5a75806521fb7ab
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"rtl">Hi kernel developers,<div><br></div><div>I am sharing TID =
(The Instant Destroyer) v2.0, a Linux kernel module</div><div>written in C =
that addresses a specific gap in existing security</div><div>libraries: non=
e of them (libsodium, OpenSSL, glibc memzero_explicit)</div><div>flush CPU =
cache lines after memory zeroization.</div><div><br></div><div><br></div><d=
iv>=3D=3D Problem =3D=3D</div><div><br></div><div>Standard zeroization func=
tions (explicit_bzero, sodium_memzero,</div><div>OPENSSL_cleanse) prevent t=
he compiler from eliding the wipe, but do</div><div>not evict CPU cache lin=
es (L1/L2/L3). This leaves residual key</div><div>material measurable via F=
lush+Reload (Yarom &amp; Falkner, 2014) after</div><div>data use ends.</div=
><div><br></div><div><br></div><div>=3D=3D Approach: PROTECT+ZERO Protocol =
=3D=3D</div><div><br></div><div>TID combines three instructions in a single=
 kernel module:</div><div><br></div><div>Phase 1 - PROTECT (before data use=
):</div><div>=C2=A0 LFENCE     &lt;- close speculative execution window</di=
v><div>=C2=A0 MFENCE     &lt;- ensure all prior writes are complete</div><d=
iv><br></div><div>Phase 2 - ZERO (after data use):</div><div>=C2=A0 LFENCE =
    &lt;- close speculation window</div><div>=C2=A0 REP STOSQ  &lt;- compil=
er-resistant wipe</div><div>=C2=A0 CLFLUSHOPT &lt;- evict all cache lines (=
L1/L2/L3)</div><div>=C2=A0 MFENCE     &lt;- ensure eviction is complete</di=
v><div>=C2=A0 LFENCE     &lt;- close the far-side window</div><div><br></di=
v><div>This follows directly the Intel Spectre Mitigation Guide (2018) and<=
/div><div>AMD Speculative Execution Software Techniques (2018).</div><div><=
br></div><div><br></div><div>=3D=3D Benchmark Results (AMD EPYC 9B14, Linux=
 6.14.11) =3D=3D</div><div><br></div><div>Without TID : attacker measures ~=
78 cycles  (Cache HIT)</div><div>With TID v2 : attacker measures ~286 cycle=
s (Cache MISS)</div><div>Ratio       : 3.7x latency increase -- attack defe=
ated</div><div><br></div><div>Physical lower bound confirmed:</div><div>=C2=
=A0 LFENCE (~40ns) + REP STOSQ (~50ns) + CLFLUSHOPT (~150ns)</div><div>=C2=
=A0 + MFENCE (~40ns) + LFENCE (~40ns) =3D ~320ns</div><div>=C2=A0 (measured=
: 290-372ns)</div><div><br></div><div><br></div><div>=3D=3D What Distinguis=
hes TID =3D=3D</div><div><br></div><div>No major security library implement=
s CLFLUSHOPT post-wipe eviction.</div><div>TID is the only known kernel-mod=
ule-level implementation of the</div><div>PROTECT+ZERO protocol.</div><div>=
<br></div><div><br></div><div>=3D=3D Known Limitations =3D=3D</div><div><br=
></div><div>- A 372ns window during data use remains (physical lower bound)=
;</div><div>=C2=A0 v3.0 target via Intel CAT integration</div><div>- Requir=
es same-machine attacker model (shared memory)</div><div>- Does not protect=
 against cold-boot attacks</div><div>- Not a replacement for disk encryptio=
n</div><div><br></div><div><br></div><div>=3D=3D Project Details =3D=3D</di=
v><div><br></div><div>License  : AGPL-3.0</div><div>Hardware : AMD EPYC 9B1=
4 (Zen 4), x86_64</div><div>Kernel   : Linux 6.14.11</div><div>DOI      : <=
a href=3D"https://doi.org/10.5281/zenodo.17585929">https://doi.org/10.5281/=
zenodo.17585929</a></div><div>GitHub   : <a href=3D"https://github.com/ahma=
aaaadbntaaaaa-byte/The-Instant-Destroyer">https://github.com/ahmaaaaadbntaa=
aaa-byte/The-Instant-Destroyer</a></div><div><br></div><div>Comments and te=
chnical criticism are welcome.</div><div><br></div><div>Regards,</div><div>=
Ahmad Qasim Mohammad Hassan</div><div>Independent Hardware Security Researc=
her</div><div>ORCID: 0009-0001-4360-0802</div></div>

--000000000000f5a75806521fb7ab--
