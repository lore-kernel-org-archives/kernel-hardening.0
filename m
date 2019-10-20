Return-Path: <SRS0=lDsZ=YN=lists.openwall.com=kernel-hardening-return-17064-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C40CCA9EA0
	for <kernel-hardening@archiver.kernel.org>; Sun, 20 Oct 2019 15:39:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D2B3921928
	for <kernel-hardening@archiver.kernel.org>; Sun, 20 Oct 2019 15:39:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PfhdEfvC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2B3921928
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17064-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7360 invoked by uid 550); 20 Oct 2019 15:38:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7325 invoked from network); 20 Oct 2019 15:38:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mRKy+IWzvzoLPClP3yhD30q6JByK0BPaIiWb8PRJQAo=;
        b=PfhdEfvCMBof5ZUzcbAPFqLfkObIBPJip8RLrfEuFDZ/WqGtCEFg9Pmu3ytQ9uJaaq
         IIHXOkUADJoEq3ZY38zOSt5IOFVADL4vla5A5x2pD/RGlMJN+PjtlHe6CwtcvTwkExBE
         GnCb5qIKASGZo8dULKxhd70mxPNRaLnsxqDNkVagXFhXj2myO/+fmO/0ZK9tDodZA1SU
         0h8YfxemV3asDpFXP2z28W5e/pxywWqUSr6sCYEqg1YaHqpTrLNq2d98i+6ZcklSBuh7
         40NsXAQtIATlpGedjj8H+KaZzDbXPP7u2pI2/phWADy6UJPjsYKlajCLfdDVr8OryiWR
         pxSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mRKy+IWzvzoLPClP3yhD30q6JByK0BPaIiWb8PRJQAo=;
        b=N7KD5DUkp6XzwuJAEuSjveVw4vs4TEMhJifzcPgAIFlaTx/HZ1bB/xaCY7bf1Ysv7G
         lMM5oM49b3Ox99nc4YT9d0gTkfIn2DVdRfK0CFsKtQmNZ5bXDIRRrvQzdIcNA9WdhinT
         pKXSVo4nc3E3sTv4bbln7KUoZCZmuYDYnMKDWiLDBBOislFMxA9+DOYyRlfD/ce1B5Cm
         QuwU9K2oM2D1cvU4c4UAz8pPkKQTA77XsUC4GpjcYGr9YePO52qiL1d0SfHOpR2qbyYw
         hyhx4ZesXwM3Y/nldPQRUde9QMX0fQij4FeFehtGOoOtzemcQDA69f0l9lE1pIODQAbf
         QTug==
X-Gm-Message-State: APjAAAWRD3uKHPY1mRMZwYh/f8teeMkPpMrXrvNHw20BrHx+x/sIca0m
	MY9ujFvHxpw0ldusjS+8aLTZy9zBiubXQ/cLuCS0jg==
X-Google-Smtp-Source: APXvYqxg1PG73Cc6ECoXvluBvp1fUYof2t+xr75WXa6OJ/A1CqQonms20lyXd0D9udZkKxOPeXQGh+w13z7UlOtUjuc=
X-Received: by 2002:a05:6830:10cc:: with SMTP id z12mr15593442oto.110.1571585925113;
 Sun, 20 Oct 2019 08:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191010103151.7708-1-mayhs11saini@gmail.com>
In-Reply-To: <20191010103151.7708-1-mayhs11saini@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Sun, 20 Oct 2019 17:38:18 +0200
Message-ID: <CAG48ez05QVn6_gQ2TBrRa1a_DWQoaSSYubUsu5YMWxx-gqMijQ@mail.gmail.com>
Subject: Re: [PATCH] slab: Redefine ZERO_SIZE_PTR to include ERR_PTR range
To: Shyam Saini <mayhs11saini@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Matthew Wilcox <willy@infradead.org>, 
	Christopher Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 10, 2019 at 12:32 PM Shyam Saini <mayhs11saini@gmail.com> wrote:
> Currently kfree does not accept ERR_PTR range so redefine ZERO_SIZE_PTR
> to include this and also change ZERO_OR_NULL_PTR macro to check this new
> range. With this change kfree will skip and behave as no-ops when ERR_PTR
> is passed.
>
> This will help error related to ERR_PTR stand out better.

What do you mean by "stand out better"? To me it sounds like before,
the kernel would probably blow up in some way if you passed an error
pointer into kfree(), and with this change, it will silently ignore it
instead, right? If you actually wanted this kind of error to stand
out, wouldn't it make more sense to add something like "if
(WARN_ON(IS_ERR(x))) return;" to the implementations of kfree()?
I would prefer that, since "kfree(<error pointer>)" probably indicates
that someone messed up their error handling jumps.

> After this, we don't need to reset any ERR_PTR variable to NULL before
> being passed to any kfree or related wrappers calls, as everything would
> be handled by ZERO_SIZE_PTR itself.

With the caveat that you still can't do it in code that might be
stable-backported, otherwise it will blow up occasionally in the rare
case where the error path is hit?

[...]
> +#define ZERO_SIZE_PTR                          \
> +({                                             \
> +       BUILD_BUG_ON(!(MAX_ERRNO & ~PAGE_MASK));\
> +       (void *)(-MAX_ERRNO-1L);                \
> +})
> +
> +#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) - 1 >= \
> +               (unsigned long)ZERO_SIZE_PTR - 1)

If you do go through with this change, you'll probably want to adjust
the message in check_bogus_address() - "null address" really isn't an
appropriate error message for an address near the end of the address
space.
