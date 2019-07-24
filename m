Return-Path: <SRS0=+99M=VV=lists.openwall.com=kernel-hardening-return-16579-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52E11C76186
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 17:31:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A161721852
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 17:31:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cBh9ReMV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A161721852
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16579-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30671 invoked by uid 550); 24 Jul 2019 17:31:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32263 invoked from network); 24 Jul 2019 17:09:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U8cl4nVt9icJqK0yFnx5TQc7gNHvGEAy+pPaBq+pmC0=;
        b=cBh9ReMV8eGmBOSMW8Zb37lV8BeNSV/1KWRwZgRg4j0iO5KN3WnhA2Qu32ZWEKD+eQ
         EXrde2G7KNiEvgfnjmcRw4+n9RJPOxSJ6KCiK+lXaNn2j190ZQQ0Dnj+r9+0owvXalW+
         XrJXduBhJmMLWWMH9L/vZIpTPzMtHlHQbeDsE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U8cl4nVt9icJqK0yFnx5TQc7gNHvGEAy+pPaBq+pmC0=;
        b=dIy2slLQfT6nvGuS41fXM/h9F5bKZ6uK5+aBAgwdSCfM/ULu0rGj3JPLMMGup5YhOf
         uxilWk6DeAdF7xkxdJOfp1hLBLoLuV7a74EFnAMLytzGlloH7Z7N6nDKshL46H0y8YKg
         xyp9E3xlSlQVDb7xFhsLKSZ7i/QD4ybd8lgUwmyzLHrru96K+hBbEFtRDORsZ0r733AY
         pXoR3FxCKe5bhiqQl/hN3ncwYdlGbyDKL4fG2r18kAp/8bp/AH0xnXUvHCE2BknMUyMM
         YetXlkEOHG9sdheCmNznvOd2ROclu9L8D+KpECwqgdohlfU614cE2dja/g2CUwGuFxE8
         K2WQ==
X-Gm-Message-State: APjAAAVbHUeSG3mo3Rq33VhIRGg/C/EVbfQC1wcUTMEOVouFOfR4bvoG
	eXgbf2Ja7bJD1+OBhhIocMi9uu07VxY=
X-Google-Smtp-Source: APXvYqwqPWYRhgj0qz626CzmsL0L4GB5mZgDB6nR3SDB81xk9nJSiA75fJWrFcXigNnJ49cksvDLYQ==
X-Received: by 2002:ac2:43bb:: with SMTP id t27mr4174431lfl.187.1563988154939;
        Wed, 24 Jul 2019 10:09:14 -0700 (PDT)
X-Received: by 2002:a2e:9bc6:: with SMTP id w6mr44754092ljj.156.1563988153239;
 Wed, 24 Jul 2019 10:09:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1563841972.git.joe@perches.com> <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
 <eec901c6-ca51-89e4-1887-1ccab0288bee@rasmusvillemoes.dk> <5ffdbf4f87054b47a2daf23a6afabecf@AcuMS.aculab.com>
 <bc1ad99a420dd842ce3a17c2c38a2f94683dc91c.camel@opteya.com> <396d1eed-8edf-aa77-110b-c50ead3a5fd5@rasmusvillemoes.dk>
In-Reply-To: <396d1eed-8edf-aa77-110b-c50ead3a5fd5@rasmusvillemoes.dk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Jul 2019 10:08:57 -0700
X-Gmail-Original-Message-ID: <CAHk-=whPA-Vv-OHbUe4M5=ygTknQNOasnLAp-E3zSAaq=pue+g@mail.gmail.com>
Message-ID: <CAHk-=whPA-Vv-OHbUe4M5=ygTknQNOasnLAp-E3zSAaq=pue+g@mail.gmail.com>
Subject: Re: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Yann Droneaud <ydroneaud@opteya.com>, David Laight <David.Laight@aculab.com>, 
	Joe Perches <joe@perches.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Stephen Kitt <steve@sk2.org>, Kees Cook <keescook@chromium.org>, 
	Nitin Gote <nitin.r.gote@intel.com>, "jannh@google.com" <jannh@google.com>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 24, 2019 at 6:09 AM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> The kernel's snprintf() does not behave in a non-standard way, at least
> not with respect to its return value.

Note that the kernels snprintf() *does* very much protect against the
overflow case - not by changing the return value, but simply by having

        /* Reject out-of-range values early.  Large positive sizes are
           used for unknown buffer sizes. */
        if (WARN_ON_ONCE(size > INT_MAX))
                return 0;

at the very top.

So you can't actually overflow in the kernel by using the repeated

        offset += vsnprintf( .. size - offset ..);

model.

Yes, it's the wrong thing to do, but it is still _safe_.

              Linus
