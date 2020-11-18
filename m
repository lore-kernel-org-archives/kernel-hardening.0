Return-Path: <SRS0=81i9=EY=lists.openwall.com=kernel-hardening-return-20424-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED6CBC56201
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:43:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CB58420637
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Nov 2020 22:43:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wM9aPQLk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB58420637
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20424-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3556 invoked by uid 550); 18 Nov 2020 22:43:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3524 invoked from network); 18 Nov 2020 22:43:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ixC0u6OyfxUYrt6QPqUZ5rujN8BJlqxwPvY/3+nhmXw=;
        b=wM9aPQLkCBhozlv2tfs90X5CI/Gs7zj3W6yTsPL8ES9kkqjKh9iwLJkDQbSmZNpPLv
         RkDOiDVBzFOBN7f2DWutl/757ig3/smDTusOtJ0ogOVayqIKQf03FO221+RCzKz0RL1M
         lIePHojAzGK+lkneSQi3IaBQCGycKs9Is3+G/9FX2LGDtYxarsXwe+NvcRF1w0eD8vc5
         57UiQ/6QoCU1He2HVP18Mkb6b7FyJI8E4/ztzOoiGFc69FJKJsZkoCUHCpldX1hGS5Bd
         +qciHnJn+5niJMe/hEyj2WRvIbyvqkFLZwU5jjNk7p7pJ3hoTwMcIaW/78Dt5d4afqBH
         z88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ixC0u6OyfxUYrt6QPqUZ5rujN8BJlqxwPvY/3+nhmXw=;
        b=i4NCL88q3E1MS4dY1KOuXtiLJWX568LYkHHHnKgezui4SaKDwgIv7k56Kx1i/oSMnu
         KEVBSByUOmuP5Z7VA0eryc14Yolfd32T0ejiSaQPRl6N6qNOSwNxtCTz2pspnFmUuOl0
         An4fNMgp9PJJXv8ChorVhT1rkJOlmLk/72ioUM625jJNaayfEoHgmIqW4YgDnxoEqo4j
         Vdub9lZpvtL7fpHTIN3wW6RWCXol5P0zLQVrGewgBihq5aOuBPzEimImp1TMLPKUnXXD
         keVswEsbab1uvmBG7rh35ZrLrRY+vt84mNEtfBNdfzV8V9+cqAp0FWG8q3VDVXtrC8bb
         iKmw==
X-Gm-Message-State: AOAM532W7vtY4oVVRIqt8BF5+JSttAcZG5wnPbSY5an0Gbe+3Wk1RqkA
	t6zoBpLeNWgU1heLWqVatF1huY2RahCPO4bkFaSfBw==
X-Google-Smtp-Source: ABdhPJxl5FB4w+I/3B3Kt/0LDlsbAGvVIt8KjuVNjLyXl4970VrDg0GQ1NlTl543R7gFJlHkLyHKMWM5T6NkljfYu5Q=
X-Received: by 2002:a05:6512:348e:: with SMTP id v14mr4178858lfr.97.1605739375008;
 Wed, 18 Nov 2020 14:42:55 -0800 (PST)
MIME-Version: 1.0
References: <20201026160518.9212-1-toiwoton@gmail.com> <20201117165455.GN29991@casper.infradead.org>
In-Reply-To: <20201117165455.GN29991@casper.infradead.org>
From: Jann Horn <jannh@google.com>
Date: Wed, 18 Nov 2020 23:42:28 +0100
Message-ID: <CAG48ez0LyOMnA4Khv9eV1_JpEJhjZy4jJYF=ze3Ha2vSNAfapw@mail.gmail.com>
Subject: Re: [PATCH v4] mm: Optional full ASLR for mmap() and mremap()
To: Matthew Wilcox <willy@infradead.org>
Cc: Topi Miettinen <toiwoton@gmail.com>, linux-hardening@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, 
	Mike Rapoport <rppt@kernel.org>, Mateusz Jurczyk <mjurczyk@google.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 17, 2020 at 5:55 PM Matthew Wilcox <willy@infradead.org> wrote:
> On Mon, Oct 26, 2020 at 06:05:18PM +0200, Topi Miettinen wrote:
> > Writing a new value of 3 to /proc/sys/kernel/randomize_va_space
> > enables full randomization of memory mappings created with mmap(NULL,
> > ...). With 2, the base of the VMA used for such mappings is random,
> > but the mappings are created in predictable places within the VMA and
> > in sequential order. With 3, new VMAs are created to fully randomize
> > the mappings. Also mremap(..., MREMAP_MAYMOVE) will move the mappings
> > even if not necessary.
>
> Is this worth it?
>
> https://www.ndss-symposium.org/ndss2017/ndss-2017-programme/aslrcache-practical-cache-attacks-mmu/

Yeah, against local attacks (including from JavaScript), ASLR isn't
very robust; but it should still help against true remote attacks
(modulo crazyness like NetSpectre).

E.g. Mateusz Jurczyk's remote Samsung phone exploit via MMS messages
(https://googleprojectzero.blogspot.com/2020/08/mms-exploit-part-5-defeating-aslr-getting-rce.html)
would've probably been quite a bit harder to pull off if he hadn't
been able to rely on having all those memory mappings sandwiched
together.
