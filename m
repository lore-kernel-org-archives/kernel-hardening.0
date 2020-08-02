Return-Path: <SRS0=LmNN=BM=lists.openwall.com=kernel-hardening-return-19513-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAB4C433DF
	for <kernel-hardening@archiver.kernel.org>; Sun,  2 Aug 2020 18:54:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 60411206DA
	for <kernel-hardening@archiver.kernel.org>; Sun,  2 Aug 2020 18:54:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="fHpnzFOJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60411206DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19513-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1250 invoked by uid 550); 2 Aug 2020 18:54:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1227 invoked from network); 2 Aug 2020 18:54:49 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8B20620B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1596394477;
	bh=Bi0Avm087nVKLtlYIbtSWKURIDHCpmDKtLVQ5vuWflc=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=fHpnzFOJOlzwXKwSY8zPf6k+L+PvjjAKdLTYmh86GcRZ1GlLSdgkG9g2/aH5jJhcq
	 rLnj76Yu6QdnUO6KTpkXFwOCQ9jicshEkSNSDxcUKT9TPhmvEepbEQ05Wq5VephZTP
	 PadVn+hOSExc6VqPzwe7hlZHes7rqpGKqv+UP3nE=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: Andy Lutomirski <luto@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 linux-integrity <linux-integrity@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <3b916198-3a98-bd19-9a1c-f2d8d44febe8@linux.microsoft.com>
Date: Sun, 2 Aug 2020 13:54:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US

More responses inline..

On 7/28/20 12:31 PM, Andy Lutomirski wrote:
>> On Jul 28, 2020, at 6:11 AM, madvenka@linux.microsoft.com wrote:
>>
>> ﻿From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>
> 2. Use existing kernel functionality.  Raise a signal, modify the
> state, and return from the signal.  This is very flexible and may not
> be all that much slower than trampfd.

Let me understand this. You are saying that the trampoline code
would raise a signal and, in the signal handler, set up the context
so that when the signal handler returns, we end up in the target
function with the context correctly set up. And, this trampoline code
can be generated statically at build time so that there are no
security issues using it.

Have I understood your suggestion correctly?

So, my argument would be that this would always incur the overhead
of a trip to the kernel. I think twice the overhead if I am not mistaken.
With trampfd, we can have the kernel generate the code so that there
is no performance penalty at all.

Signals have many problems. Which signal number should we use for this
purpose? If we use an existing one, that might conflict with what the application
is already handling. Getting a new signal number for this could meet
with resistance from the community.

Also, signals are asynchronous. So, they are vulnerable to race conditions.
To prevent other signals from coming in while handling the raised signal,
we would need to block and unblock signals. This will cause more
overhead.

> 3. Use a syscall.  Instead of having the kernel handle page faults,
> have the trampoline code push the syscall nr register, load a special
> new syscall nr into the syscall nr register, and do a syscall. On
> x86_64, this would be:
>
> pushq %rax
> movq __NR_magic_trampoline, %rax
> syscall
>
> with some adjustment if the stack slot you're clobbering is important.

How is this better than the kernel handling an address fault?
The system call still needs to do the same work as the fault handler.
We do need to specify the register and stack contexts before hand
so the system call can do its job.

Also, this always incurs a trip to the kernel. With trampfd, the kernel
could generate the code to avoid the performance penalty.


>
> Also, will using trampfd cause issues with various unwinders?  I can
> easily imagine unwinders expecting code to be readable, although this
> is slowly going away for other reasons.

I need to study unwinders a little before I respond to this question.
So, bear with me.

> All this being said, I think that the kernel should absolutely add a
> sensible interface for JITs to use to materialize their code.  This
> would integrate sanely with LSMs and wouldn't require hacks like using
> files, etc.  A cleverly designed JIT interface could function without
> seriailization IPIs, and even lame architectures like x86 could
> potentially avoid shootdown IPIs if the interface copied code instead
> of playing virtual memory games.  At its very simplest, this could be:
>
> void *jit_create_code(const void *source, size_t len);
>
> and the result would be a new anonymous mapping that contains exactly
> the code requested.  There could also be:
>
> int jittfd_create(...);
>
> that does something similar but creates a memfd.  A nicer
> implementation for short JIT sequences would allow appending more code
> to an existing JIT region.  On x86, an appendable JIT region would
> start filled with 0xCC, and I bet there's a way to materialize new
> code into a previously 0xcc-filled virtual page wthout any
> synchronization.  One approach would be to start with:
>
> <some code>
> 0xcc
> 0xcc
> ...
> 0xcc
>
> and to create a whole new page like:
>
> <some code>
> <some more code>
> 0xcc
> ...
> 0xcc
>
> so that the only difference is that some code changed to some more
> code.  Then replace the PTE to swap from the old page to the new page,
> and arrange to avoid freeing the old page until we're sure it's gone
> from all TLBs.  This may not work if <some more code> spans a page
> boundary.  The #BP fixup would zap the TLB and retry.  Even just
> directly copying code over some 0xcc bytes almost works, but there's a
> nasty corner case involving instructions that fetch I$ fetch
> boundaries.  I'm not sure to what extent I$ snooping helps.

I am thinking that the trampfd API can be used for addressing JIT
code as well. I have not yet started thinking about the details. But I
think the API is sufficient. E.g.,

    struct trampfd_jit {
        void    *source;
        size_t    len;
    };

    struct trampfd_jit    jit;
    struct trampfd_map    map;
    void    *addr;

    jit.source = blah;
    jit.size = blah;

    fd = syscall(440, TRAMPFD_JIT, &jit, flags);
    pread(fd, &map, sizeof(map), TRAMPFD_MAP_OFFSET);
    addr = mmap(NULL, map.size, map.prot, map.flags, fd, map.offset);

And addr would be used to invoke the generated JIT code.

Madhavan

