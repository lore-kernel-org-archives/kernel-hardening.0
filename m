Return-Path: <SRS0=bdiT=4F=lists.openwall.com=kernel-hardening-return-17822-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D064C34021
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Feb 2020 15:16:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BFA5120801
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Feb 2020 15:16:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FaV5EUPN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFA5120801
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17822-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15801 invoked by uid 550); 17 Feb 2020 15:16:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15764 invoked from network); 17 Feb 2020 15:16:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yaa5Zsh4wqMSELQ9D6ehDKz1fap8V26OK7n2Od5AnyQ=;
        b=FaV5EUPNcTByqJGcKaeWDedvXg0Qfzmz7kHjDpWwM2/B/AqsuKKN+uGLloMlDjbkq6
         +cNO+eEuGH9VN1bluR53j8t4+Zt/X9zaPoU1YgB4jXb/sHNRZ/MEL5EyksqKLAIo++pK
         FNqj+AhQ7GA3zFtMaGTBfg2x4DtXwPpyl6BYB90g4JdZLCGHhuo7iZeUOTzogWu7Ec96
         fzSxRcSUkCYMjrfnRcmUjYDJfsRkR+O5L4ZYbzaUc6dQ2b5koeGpoulbcaN/2PbVDfwt
         AX8y80br7ejq66qXQIiLT0XailX7B+SaWfjFj+Yobvy5ZVsoxtrFHJ+zAAzMBmlaYP6E
         OcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yaa5Zsh4wqMSELQ9D6ehDKz1fap8V26OK7n2Od5AnyQ=;
        b=d2dP5rc4k9rj8dM7D7NcJ6uFP7tNYZMW3FmhIjrdpYppW+NOtct62bzXlj71R/OP13
         t7kx2bm5yL836Ds5Qg2m987Rddxd0ygmwjju+nkHPl6ZNF28jGlHx0hYfuokE6UCpm/t
         /tpFZQy5xfeWFOdXFJzmThNNBGrpNikQeYXAO6pGkTKtLDY/Ltb1BU0lRCTEvBlfQEom
         xpmQlFGSmTxDHGxPLGI2sbFRgGZPBYO1RMJiUfqvKNzMU1KHuTygLZKollRUYiTw8fsq
         Gh9mi/mXcfRqj9S+8m2+WKgikJXtIrHEyeHqHQe+6HeBs0A6/7Uo0/ur8PEc1AtF//63
         jmhA==
X-Gm-Message-State: APjAAAXj99lHJ/bR3FBia77dk2EBRZO4ISQtS6NlHeYxMWe8xNI9xbgk
	daF5TeiD7zD5Nk1Son6pmFwXiZDbZBdKgvuXBtBzcA==
X-Google-Smtp-Source: APXvYqzCOoAfUe49HahiplG1XBHkhcPR9mmuyYNnLKrxWKu6qWfvfuKctDE/dyyA3CBU6sy9kWr1WmUZcSeH5UdbnKg=
X-Received: by 2002:a17:90a:a10c:: with SMTP id s12mr20163423pjp.47.1581952555352;
 Mon, 17 Feb 2020 07:15:55 -0800 (PST)
MIME-Version: 1.0
References: <e535d698-5268-e5fc-a238-0649c509cc4f@gmail.com>
In-Reply-To: <e535d698-5268-e5fc-a238-0649c509cc4f@gmail.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 17 Feb 2020 16:15:44 +0100
Message-ID: <CAAeHK+y-FdpH20Z7HsB0U+mgD9CK0gECCqShXFtFWpFp01jAmA@mail.gmail.com>
Subject: Re: Maybe inappropriate use BUG_ON() in CONFIG_SLAB_FREELIST_HARDENED
To: zerons <zeronsaxm@gmail.com>, Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, Shawn <citypw@gmail.com>, 
	spender@grsecurity.net
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 13, 2020 at 4:43 PM zerons <zeronsaxm@gmail.com> wrote:
>
> Hi,
>
> In slub.c(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/slub.c?h=v5.4.19#n305),
> for SLAB_FREELIST_HARDENED, an extra detection of the double free bug has been added.
>
> This patch can (maybe only) detect something like this: kfree(a) kfree(a).
> However, it does nothing when another process calls kfree(b) between the two kfree above.
>
> The problem is, if the panic_on_oops option is not set(Ubuntu 16.04/18.04 default option),
> for a bug which kfree an object twice in a row, if another process can preempt the process
> triggered this bug and then call kmalloc() to get the object, the patch doesn't work.
>
> Case 0: failure race
> Process A:
>         kfree(a)
>         kfree(a)
> the patch could terminate Process A.
>
> Case 1: race done
> Process A:
>         kfree(a)
> Process B:
>         kmalloc() -> a
> Process A:
>         kfree(a)
> the patch does nothing.
>
> The attacker can check the return status of process A to see if the race is done.
>
> Without this extra detection, the kernel could be unstable while the attacker
> trying to do the race.
> In my opinion, this patch can somehow help attacker exploit this kind of bugs
> more reliable.

+Alexander Popov, who is the author of the double free check in
SLAB_FREELIST_HARDENED.

Ah, so as long as the double free happens in a user process context,
you can retry triggering it until you succeed in winning the race to
reallocate the object (without causing slab freelist corruption, as it
would have had happened before SLAB_FREELIST_HARDENED). Nice idea!
