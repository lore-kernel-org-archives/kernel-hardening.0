Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 6150A606A323
	for <kernel-hardening@archiver.kernel.org>; Sun, 15 Nov 2026 05:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0EE2kdia
Received: (qmail 7571 invoked by uid 550); 15 Nov 2026 05:14:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21700 invoked from network); 15 Nov 2026 05:04:47 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1794719076; cv=none;
        d=google.com; s=arc-20260327;
        b=aTs4cfJybFDUjqNdvnE+c4UL/c6xuf5TiylPQ92KQbXVfBJMsc3pivMC4YyPU6ubD0
         8EXSq8LZIogWOFMesPGUqvU01119ndAHnH7ofmTZ1SzMSYJnNVIFQ68L8vl+KCBgSqOZ
         ekYT7BSarUKE9t8xT35ZBitq/pgUftw6l8AcsUE3KKjZqiugYF5BvMJtnRZxVVk8ukYH
         i9Whprwue8BMInH0RHtFoejoYCtTEO/i9eTrh6atAun1RueikcgcaHhHE8UPpq9ioSvz
         UeZ9apvFEoaFHKNmc65PEJnLniF+G8ISA6QVib8V944w/QQS68Jf4NPEJ2WOFOck9MpD
         gi1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SgvuvYF8PGLNaNTs2994Os9KZuYKECf0z3D8OUpUwHs=;
        fh=928UfdIKImDcujTIhSl1s/ScfOOd2AAevaUmTjLrhcE=;
        b=ZNoT084aRtZMKn7IbwUWmciiqKEWcpDZqH5aiASAVScQt76zWUjgT2rtL9vVd55tLV
         5IGoimMLnk/1pIbryBCXVryOMCI9cAtqub7aADwr0EHx69xO+kEvMmxh7NdYpOF0257l
         wrhrmUBASOBEQGqLW3hwEGjqmxZlC9TsVhWjrqUzW+zZsgzKin5+p7kSlc8QgoW01ybu
         Zf7ErdcFAGrrULkKyvN9BgCHZcEacJreW3ikWvjJOoeviqx0pTqDpByHSux5llBdAaUG
         ZW2uR+6oK/doWsWrREbKCGEGe+MdEvpjbugwVF2KjbgOBvj/wWelYunj357OTDL1b988
         Z5uQ==;
        darn=lists.openwall.com
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794719076; x=1795323876; darn=lists.openwall.com;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SgvuvYF8PGLNaNTs2994Os9KZuYKECf0z3D8OUpUwHs=;
        b=0EE2kdiafmiRmbH47GEVDHGBW7utfVHMJXpJ5eKlXchCLyBA9EXruZ0bgj4JtBU3Td
         tVSi0B2boy/7KllABY9gjfl0Dm7Hl9J1kBflk83peDxpu8WA9QqpPF0W2yzwn/YcaOh4
         UBnnu/ppi2jgAM2U8u+55EjLbTAZjU4jgwKrWYgNcGYQGhn5zNapD8U+sxzwgyJJqCw6
         k9BLBM6+AEUj9d/f0t/wqNqa4aa0xwxu2uiggbFmF/R7yALAaI0p9KlbzHslXFAFr54Y
         BNT0sNU70Spy0HB5iEY0UwPYoA/KUVRGnXvuJ+/ON+/o4r30iyP+yQvOFkR1HjkjDj/+
         Lf7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794719076; x=1795323876;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SgvuvYF8PGLNaNTs2994Os9KZuYKECf0z3D8OUpUwHs=;
        b=gyFDzFGAbIUyN08BupORJE8BYhvku9gpe2EYld6MVJTMRj6LdZBJ0l2pNFZ42JitY9
         DEVZejPTsMnJiI7o6HALV3GLX1LHUkwWgujso8LwymyyRVWmrvt/Smpu7MvQxOsp01Ms
         o3vrtgQzxgdy9xpOnwH0uVsYvaONmGTGASiJIinOaJcjV7PV0+B1CcybyT8ZNNhMvkSa
         /vn8JXdfXUDcF9klm4KlJ9YIPS4SAisYvEBoWr4AC6V0bIxFGdNkjVWPo14GZUxOm/Ts
         N7fQ+37ZNDRLAMN0GGd8sxJ5hsxJSgggPvFz0Vw3A7oLFi06YWZQ330PTIm5YkFN2iE2
         wMwg==
X-Gm-Message-State: APuU4Z8Fn5DX1D/6livbTaXOM0slux5PSZcq1YJweHOtCMCoAqD9djXB
	Cqc20T6ZIQ1aSDlTp9G7pRgT3AwIz2/ITSGHd2DRfbmCDrcGMircW8xup5bP8Yqj4eV9FZ4j84G
	vH83QuDEVeSu4nwpkztkcFhUQC+gb75g=
X-Gm-Gg: AYBFou0v76rHDnnWR3j3VkKJVUDz7Qc8z486vbHPt+Otr0R11qxnBeHQGzhWm+q+qtW
	OAjPniyklyIB7UZ0UcNj3b7xeO4MiKPD7spkI65ZqLC0nW++rwBJU41hDR9NniBkkrUkOTCVAcI
	3l5wQK7n73+w+ziyrxFFuoTlwXEDkgq41qVxdcjxVZPwgUlsH8acpJLn7MMi7ext2cfls8umtZ6
	Vk/dMHBAHlJQ1qTdqA0y12zEQyGSw4eY55mHz2ez/I5mDhzxUbeCNswxtOX//sduA6ykUzDN8hg
	K1+/Q/+Dt8d9GssF/7sMD5oLn3vlbeo80nBuW4NG/PreStPORkogmB6nwHMgADH82yvgTmy9tHw
	3i6TNFLCwkg+DyJryOaAcj9GuX4Etla02BF47RWUbhW5yhdZ7BrMtHLjOgYEMTVcsH/yglw==
X-Received: by 2002:a17:902:ec8d:b0:2e6:2868:e576 with SMTP id
 d9443c01a7336-2ee0dacce34mr78461005ad.31.1794719075549; Sat, 14 Nov 2026
 21:04:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
 <2026110611-tassel-bubble-dc09@gregkh> <9417ef01-a367-43c7-85f2-1b02c446c160@canonical.com>
In-Reply-To: <9417ef01-a367-43c7-85f2-1b02c446c160@canonical.com>
From: Loganaden Velvindron <loganaden@gmail.com>
Date: Sun, 15 Nov 2026 09:04:23 +0400
X-Gm-Features: AclHuK9uNEEzIjhRttPEtlklKsYqcf6XAQ1yIFb4qGfnikkMfIWnnZKJ6fdNm4E
Message-ID: <CAOp4FwRHE51d3CwB=z3b3nVKqHZTax5aeptU1r9DLjzWunKn2Q@mail.gmail.com>
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
To: John Johansen <john.johansen@canonical.com>
Cc: kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I think that the project https://kspp.github.io/ is highly relevant in
the post AI era.

I'm not sure we need a bpf firewall. However, I think that exploit
mitigations can
act as a 2nd layer of defense to reduce impact of vulnerabilities.
