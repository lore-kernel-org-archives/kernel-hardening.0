Return-Path: <kernel-hardening-return-22009-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 1849BCD4F54
	for <kernel-hardening@archiver.kernel.org>; Tue, 19 May 2026 21:42:57 +0000 (UTC)
Received: (qmail 30135 invoked by uid 550); 19 May 2026 21:42:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30103 invoked from network); 19 May 2026 21:42:42 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1779226954; cv=none;
        d=google.com; s=arc-20240605;
        b=i10StXZvA3zwnQu7NKknB3YZWqOOduHz6fV51h9tzXkGDmEgZQjcF4FmvfYxpFfYEU
         Ahjr3yVdaj7naEUBHCDhkTnxUwXw+7FUzy1kKQT9g+nRhtAXFMEIk1U2fdmt0vEaNEDp
         FmfN7s426iGioUfQlMBD6JpneEvLcAVZ30V76lxb9/bwyQ2QMASA4LN5hLWoRpOJIXET
         PZ8R1ecWBy8vjr5wClvjFEIa78Qc8zSXSuRvnbUBvfSP5bt8mvwbU79hdfIFSrbylg8z
         DgQPc/NNLOFgOuJ+iMjyskLJ4RhFYCLzSASbrVjbotEDF6tC4O1YkkHHcptSo/fFkoCX
         UGMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
        fh=Cq8EC+/uSVPnjFN/sxuVuVmjeZY+43zPkbMGbF2ST48=;
        b=Wi/I0uNgT7UGzPqzp1gc4EYBEYFsmhz9IsZasXu9Rthdot2zvOvmbHYt8vh+gP7ZTX
         2Tu9gWZugDc65z6XUgV9c5/N0gZECvyeuHD0GjamcwTwIG0rRzX1f4pANqWTQNA/xlN8
         H4AKLnprXnPW3k8nVacHs0dWmH4jvpE1ZnJEwOPpLJjQPJFFA/vecSFEndud9ODx9lQr
         cKj3Djh7Q3ttvx9ve2NUXhj68LoB7YnGYcnlQNykxHJ5l39rQi3vXg9+Bxr8Kd1WTktn
         K4vwaE4nrFQSR3gFB3jJhOJvg9voSoCMqxyc4OHxrZCBxJMTcnr5jm30JAgPrWQ2vEU0
         qFqQ==;
        darn=lists.openwall.com
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779226954; x=1779831754; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
        b=P2/6klAEEYwycB/EqM/fkI3/bgzI08dDTq01uZbfWs62dnEIvGla6pQo1mZb15j2uC
         N0rDdT26yKwGWdCp26FfCv+nYWp3VR7m08Gwp+EC2z5+SBXNr6Rmlrw8sHGj2Dg5otU+
         4RA91Yhv0aEil9Swin74s+gwHy2Rkp5f/LSgMgj+RmwXLuArgP3ZEB1lg9av0qCr7dLf
         P2Jj61RpDaSrUdsS42buZeaON/XR1OGlUrzCmYsaSIDz7IVeRmyb8gqReRctkDaAsF9W
         WWgnd7/OMAsRu/eiwazBaCdfOR0702P9whBJ/D571zQv6sil2Vq35Kvs08eUrVCUKH83
         WBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779226954; x=1779831754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=agpQDPE0e0tDa6PFtfyC+WslCRjLfXBgwgqDsBVIG9k=;
        b=LKqdyU+ESA+AOJcbHxPGks7xJhnUfbQpewHDmByYwf74GX5xLiJowjRHy0sif1TZSl
         tmjVcIjFgv6XGlc6jKT4b8U3hp6iRLujLeweaFV8fpJchXaa9VAMq8flHG8f/noaB6n6
         OUFOsxs61KLei+4nc/z0xj2EzfBT8ivuihqpmlI/dkZCHtwZ+QOdjw1vDWxsFkZLzm7o
         HX1r/3rVIyT37XDOg+b882j5H9fYQtogiL8O9sZzYaSZ0SoUlmQTH2hxbgBfHdyn3/bO
         tLC49Qhwi3TV5KGcXXYNihQBX9BUi5g2E+GJdpxJOtaxdJnLzZVqid9fxIIrCrkunoqk
         mQpQ==
X-Forwarded-Encrypted: i=1; AFNElJ+K1DjwTOx3uyuQkgG3ZPfl+98QV8aGzWh4ummRguEy5NwxGscidnKRP0p1TiWsgmXp1AmYviQ90WK1jDrDwvB8@lists.openwall.com
X-Gm-Message-State: AOJu0YyUVwPqwgfbv8SeWmjNQu5VjePBmVZOhJC3MObjtHwFFY1zGpFA
	0VQgsr4qmRe4/LVWjKeQionKrhm27kk5GMzbNpnSo+gA0s1/t3B7EzLBVzYyo4PzPKYbRPP+igE
	8FeBmgWZT7d4wDAR28qfpz9P8mBtI5+RvLPT3zOcw
X-Gm-Gg: Acq92OGyYy7ZXTYwIj1iEIH5I8iSQR9TD86qaOWQDgP0XWiEy2l26PN24NZeFj3F8TQ
	VEmPNXhpPrMi2+i05Zq+r9C4ln1PRPnrDiv0bS6P5KH2r5izrZewu9Km9sYKKRoQL6qQWpEu4bT
	O+QU5iJKM8aqBrGzRouZKvGdB8xsD3BFR5p1LOer+FDJIutcolG2VceTBIr4GgjsKIV+WnudLbF
	uqZo+PgwUux+x9Mo/gIhS75C4Ee4uIu+g1FxxR9A4WRMT2AtFI/zk9biQ9nPDAVsOOeqiE5P+L6
	oAxCMduE1lRvD2JWphbvqqlSaxND3h8N7RkG3JYdM1fbU2g=
X-Received: by 2002:a05:6402:20c6:20b0:678:a5c3:4d12 with SMTP id
 4fb4d7f45d1cf-684985e277fmr173995a12.3.1779226953632; Tue, 19 May 2026
 14:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <F78521DA-08DC-424E-BBE1-231BC900CEE0@gmail.com>
 <CAG48ez0KsuR5z4RDgxWPUoS8e_MJzF74RgFDJayohG48A_N0PQ@mail.gmail.com> <CAAmtCfMHqdWbYh-Hc5sGbOhXSM-aCA9G0-s64G8FTM+rGEV5RA@mail.gmail.com>
In-Reply-To: <CAAmtCfMHqdWbYh-Hc5sGbOhXSM-aCA9G0-s64G8FTM+rGEV5RA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 19 May 2026 23:41:56 +0200
X-Gm-Features: AVHnY4KelXMX0Ox3UHP6DtmSDnRxPxmxV49wSNMKd-K67wpQhqz9skVmJZNDODo
Message-ID: <CAG48ez3u1OCx+zCWEs-_gowDmQ=KLbXO2xZ83LCZ1o1gxRT3Ww@mail.gmail.com>
Subject: Re: [RFC] TID v2.0: kernel module for cache-line zeroization against
 Flush+Reload (CLFLUSHOPT + LFENCE + REP STOSQ)
To: Ahmad Hasan <ahmaaaaadbntaaaaa@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-crypto@vger.kernel.org, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 19, 2026 at 11:31=E2=80=AFPM Ahmad Hasan
<ahmaaaaadbntaaaaa@gmail.com> wrote:
> Thank you for your questions. I'll address each one:
>
> =3D=3D 1. Threat Model =3D=3D
>
> The target scenario is a same-machine attacker
> in multi-tenant/cloud environments where two
> processes share physical L3 cache.
>
> Example: a cryptographic service and a malicious
> process running on the same host. The attacker
> uses Flush+Reload to measure cache access timing
> after every encryption operation =E2=80=94 no physical
> access required.
>
> This is documented with real measurements:
> - Without TID: 78 cycles (Cache HIT =E2=80=94 key pattern visible)
> - With TID v2.0: 286 cycles (Cache MISS =E2=80=94 attack defeated)

So you're assuming that the cryptographic code leaks secrets through a
cache-based side channel? That would be a vulnerability in the crypto
code.

> =3D=3D 2. Why Kernel Module and not userspace? =3D=3D
>
> You are correct that CLFLUSHOPT does not require
> Ring 0. However, userspace execution can be
> interrupted by a Context Switch, which expands
> the timing window from 372ns to 36,640ns =E2=80=94
> making the attack significantly easier.

Why does it matter how many hundreds of nanoseconds it takes to wipe
the data from memory? You can also have a context switch directly
before you enter your cache-wiping syscall, or in the middle of a
crypto operation.

> =3D=3D 3. Why not add this directly to libraries? =3D=3D
>
> No major security library implements CLFLUSHOPT
> after wiping =E2=80=94 not OpenSSL, not libsodium, not
> glibc, not memzero_explicit. This gap has existed
> since Flush+Reload was published in 2014.

I don't think that's a gap, because the standard approach to
mitigating cache-based side channels such as FLUSH+RELOAD is to not
access memory at secret-dependent indices in the first place.
