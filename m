Return-Path: <SRS0=OHjr=WZ=lists.openwall.com=kernel-hardening-return-16832-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD553C3A59F
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 19:55:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 257AE22CEA
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Aug 2019 19:55:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="U75GJORV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 257AE22CEA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16832-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22335 invoked by uid 550); 29 Aug 2019 19:55:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22317 invoked from network); 29 Aug 2019 19:55:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aYf/lCZC1gwMIR9/lhwT5M/JPgKzeUqjFNgwUcFRWFg=;
        b=U75GJORVMHIr0iUVnntJaP5CkG0L6J04X+1V/ZPN5uW3dQqnBj8pdaROlXs8b4Z1SG
         DR1yBHet2NvJnJhuzP0i5c/qQ5sBWpaG0KlB9URDDEL2UqurL8fMaEild5hR6irruZ3I
         WwlNUWnUuDyL8bRkDmAo8qYqSmnG/ayXfekSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aYf/lCZC1gwMIR9/lhwT5M/JPgKzeUqjFNgwUcFRWFg=;
        b=g+dDfPmmAABwHxmhV0ciLfPx4Le4UBnK3Ii5ca2OZFh/EKlEI966ppM3suURhMRoYW
         qteKKeUfUgrjivCTYWzbcB37NyONPv3vLehkz9bc10qmmTcWG3E/dwKpkldUsnQSLtGK
         zBel4Kvfc4VhuSZMzCHGNu52aDlhDGnWPJBAcZGKcC1MSZuZDjG1QGvQduZNC7xNBneo
         fU9PqTu9x5m1HQkC/Szmy5F0FU5d0qWYk/XtpvIGuKTuVPkYkWEqr1UEuQxqBXHTUEu6
         Zx19Ox5fQIzS3dgJ94IXhXqDaIxuXcr0D8l8WquE/llQRNVo+PhDlZl676GVkpWp35xQ
         OzMw==
X-Gm-Message-State: APjAAAWbUcwAertR4ZqprrdXE0Tt7ZrQb6Nn2Gn43rbCkSxbxjrKJs8T
	tRwzXmNGc3B7CrKtD1pQNhqcDN984Qs=
X-Google-Smtp-Source: APXvYqz6tH2L/SSCAYO3L7Da+cdF9PgInKzNkE1zlYrOOMZtZa5y2ZtxVl+KXuMJpQnv8CqZC2ExxQ==
X-Received: by 2002:a17:906:131a:: with SMTP id w26mr9848330ejb.131.1567108516459;
        Thu, 29 Aug 2019 12:55:16 -0700 (PDT)
X-Received: by 2002:a5d:4a4e:: with SMTP id v14mr13235010wrs.200.1567108513590;
 Thu, 29 Aug 2019 12:55:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190806154347.GD25897@zn.tnic> <20190806155034.GP2349@hirez.programming.kicks-ass.net>
In-Reply-To: <20190806155034.GP2349@hirez.programming.kicks-ass.net>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Thu, 29 Aug 2019 12:55:00 -0700
X-Gmail-Original-Message-ID: <CAJcbSZETvvQYmh6U_Oauptdsrp-emmSG_QsAZzKLv+0-b2Yxig@mail.gmail.com>
Message-ID: <CAJcbSZETvvQYmh6U_Oauptdsrp-emmSG_QsAZzKLv+0-b2Yxig@mail.gmail.com>
Subject: Re: [PATCH v9 00/11] x86: PIE support to extend KASLR randomization
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>, 
	Thomas Hellstrom <thellstrom@vmware.com>, "VMware, Inc." <pv-drivers@vmware.com>, 
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, 
	Nadav Amit <namit@vmware.com>, Jann Horn <jannh@google.com>, Feng Tang <feng.tang@intel.com>, 
	Maran Wilson <maran.wilson@oracle.com>, Enrico Weigelt <info@metux.net>, 
	Allison Randal <allison@lohutok.net>, Alexios Zavras <alexios.zavras@intel.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	virtualization@lists.linux-foundation.org, 
	Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Aug 6, 2019 at 8:51 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Aug 06, 2019 at 05:43:47PM +0200, Borislav Petkov wrote:
> > On Tue, Jul 30, 2019 at 12:12:44PM -0700, Thomas Garnier wrote:
> > > These patches make some of the changes necessary to build the kernel as
> > > Position Independent Executable (PIE) on x86_64. Another patchset will
> > > add the PIE option and larger architecture changes.
> >
> > Yeah, about this: do we have a longer writeup about the actual benefits
> > of all this and why we should take this all? After all, after looking
> > at the first couple of asm patches, it is posing restrictions to how
> > we deal with virtual addresses in asm (only RIP-relative addressing in
> > 64-bit mode, MOVs with 64-bit immediates, etc, for example) and I'm
> > willing to bet money that some future unrelated change will break PIE
> > sooner or later.

The goal is being able to extend the range of addresses where the
kernel can be placed with KASLR. I will look at clarifying that in the
future.

>
> Possibly objtool can help here; it should be possible to teach it about
> these rules, and then it will yell when violated. That should avoid
> regressions.
>

I will look into that as well.
