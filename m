Return-Path: <SRS0=AqKd=5J=lists.openwall.com=kernel-hardening-return-18216-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9A92C10DCE
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 23:08:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 374E52078A
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 23:08:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BD55ubdc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 374E52078A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18216-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11831 invoked by uid 550); 24 Mar 2020 23:08:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11796 invoked from network); 24 Mar 2020 23:08:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hZYGrrYHl0NkyIgc2uGWToFLNVXOPMpm5ALW355x8l8=;
        b=BD55ubdcQFGlrkHGIItP7aQDYlQQqN7BWHznAV/BjGLMmkbrJluW3YXOG3HL/kyDw3
         42/9FZDOe8ljg+1CRL8AXZrMCy3hHzGKeh/6wZnm1iCU/d6Aup3GFDglcGpiGZQja3QM
         Urwx0W7yYX5sK3oS2wzmYSIY/u5xoQbapUf/A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hZYGrrYHl0NkyIgc2uGWToFLNVXOPMpm5ALW355x8l8=;
        b=e4HdyIGTscQUEA+st0O7B0tiag4RrYdynR0gfrUMcaFiCrZlB5jebprrUx/3XNe78h
         hLlTf15rhdFx5dSm/DTquWA18xM9NMhi+Td7DxeAtMM/5r43mb9oQ7npyqEYtIveCaeX
         iW8/xlOPWFVCJJtX8OjRfX8XBOgdNp9Z2wnhWndS60HBedcVEPm0BFlK+7BJxes+ByT2
         EWBuSHTb7DF6ToN+M8RcF0M3xZHJaBsv7DTK+ri14hEQvzCzmY6kS6PEQ3QG/ioCpwsa
         8c50QYCURWIsqeV09tdmuOJBX0uKOKFrUgjZynIVd65BHPQrwBl2sGxO6Inmc4gcsrFa
         zagw==
X-Gm-Message-State: ANhLgQ3adFGxuB9KjUrBeohPz2dhbzHl1xkzp/GDU+X4bfre+LMjejHX
	w43SdaYFWmOEKAlFT6sJeaseAA==
X-Google-Smtp-Source: ADFU+vticqY9doh2mTEaDYaNe3t5j0AxJERCJeuUe+VbDwiLI2y3AIoOf4ls11Z+6Qtp0zkgNcLtEg==
X-Received: by 2002:a62:1894:: with SMTP id 142mr151739pfy.27.1585091275699;
        Tue, 24 Mar 2020 16:07:55 -0700 (PDT)
Date: Tue, 24 Mar 2020 16:07:53 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel@lists.infradead.org, Linux-MM <linux-mm@kvack.org>,
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Optionally randomize kernel stack offset each
 syscall
Message-ID: <202003241604.7269C810B@keescook>
References: <20200324203231.64324-1-keescook@chromium.org>
 <CAG48ez3yYkMdxEEW6sJzBC5BZSbzEZKnpWzco32p-TJx7y_srg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3yYkMdxEEW6sJzBC5BZSbzEZKnpWzco32p-TJx7y_srg@mail.gmail.com>

[-enrico, who is bouncing]

On Tue, Mar 24, 2020 at 10:28:35PM +0100, Jann Horn wrote:
> On Tue, Mar 24, 2020 at 9:32 PM Kees Cook <keescook@chromium.org> wrote:
> > This is a continuation and refactoring of Elena's earlier effort to add
> > kernel stack base offset randomization. In the time since the previous
> > discussions, two attacks[1][2] were made public that depended on stack
> > determinism, so we're no longer in the position of "this is a good idea
> > but we have no examples of attacks". :)
> [...]
> > [1] https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html
> 
> This one only starts using the stack's location after having parsed
> it out of dmesg (which in any environment that wants to provide a
> reasonable level of security really ought to be restricted to root),
> right? If you give people read access to dmesg, they can leak all
> sorts of pointers; not just the stack pointer, but also whatever else
> happens to be in the registers at that point - which is likely to give
> the attacker more ways to place controlled data at a known location.
> See e.g. <https://googleprojectzero.blogspot.com/2018/09/a-cache-invalidation-bug-in-linux.html>,
> which leaks the pointer to a BPF map out of dmesg.

It was mentioned that it would re-use the base across syscalls, so this
defense would have frustrated it.

More to my point was that there still are attacks using a deterministic
stack as part of the exploit chain. We have a low-cost way to make that
go away.

> Also, are you sure that it isn't possible to make the syscall that
> leaked its stack pointer never return to userspace (via ptrace or
> SIGSTOP or something like that), and therefore never realign its
> stack, while keeping some controlled data present on the syscall's
> stack?
> 
> > [2] https://repositorio-aberto.up.pt/bitstream/10216/125357/2/374717.pdf
> 
> That's a moderately large document; which specific part are you referencing?

IIRC, section 3.3 discusses using the stack for CFI bypass, though
thinking about it again, it may have been targeting pt_regs. I'll
double check and remove this reference if that's the case.

But, as I mention, this is proactive and I'd like to stop yet more
things from being able to depend on the stack location.

-- 
Kees Cook
