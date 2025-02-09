Return-Path: <kernel-hardening-return-21938-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 8192EC0219B
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 22:15:38 +0000 (UTC)
Received: (qmail 9670 invoked by uid 550); 9 Feb 2025 22:15:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1576 invoked from network); 9 Feb 2025 21:40:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739137250; x=1739742050; darn=lists.openwall.com;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vHmVTfsnRz1JF9lpJrmG696etUTSYNASGKo7x++LBE=;
        b=I9GjbG8ChQwQeXZKk+TRUQvKRbYZDLiCXDAdTbM85SKBdPxnZuzL354l0ck/h7oe/V
         id4QMcdWlWpjwyYpt9jsYvcSLLF2l8elTkxLZK+J5POqJNxLvGeu7F+Uuv6BPcEfO4Qt
         80WkN9wW71WWB3nJ/syLvZISdCKXl8g83EhAu0bzxyrQJGeXpTm2KNM8rWhWlrhdnSfv
         WXyQ9ZaItX4KrTg+70mitUmnCwLbemFRk8nEFYoqn6QdyyTVdp+D5Rc/yXvBQZ2axUAY
         V3I5s49hdhvfFfi9hyj4a61gf54b9xPso5Y4z5XadaVXZsUHONaFPMKeUx5kEa1dWaPa
         6jfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739137250; x=1739742050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4vHmVTfsnRz1JF9lpJrmG696etUTSYNASGKo7x++LBE=;
        b=DMQSm7EwrMFue0cgOuOnZMRNAwemfi9iCvtE2mdV1whx3cRW1pIo6rUjElOq6DhPr5
         TLUeXzA1rvAIE80kT3xXvWNAL74ZV2uUnFnYdLQkeeAN68at/i4cH9XIBJe4r9P9Erlh
         ckDL28LtYNkwYNaHo3icuIDkxxzC7gFKYrS+BPQZGbYFKpT5hMM9tLXbcSDJbbVpJLSr
         9GmaBFc6p8brltw/UlYqYeRuUB/2jpaz91CcqKSchAlrZ4kL7iN7Dkw/cgPECXiu9VCQ
         IkhF4TyZCR2x/WWOBw2iyJaVpz2DRj7SN6SvsO04wZmJ2HNF/DTf2xmqd05Mqf4tDclq
         HMFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaNVLBcw/nJFzwH4Tc9ZwUWVmYdaFUhV80xazpokpomor7ZUKvnnIeDOoTZ3tfOmfFmus88aFHoYmWfSrtIPdM@lists.openwall.com
X-Gm-Message-State: AOJu0Yx3zCA2QcA1LGpbV69N5C2epe4jyk9qaoT32aRpEffTeKiWaDmJ
	wUjWvMRyTnt1HnNkOXOdKcP5fCw5RQzoJYJOXfqjsubswVYX8fYM
X-Gm-Gg: ASbGncs49eSo86esfhWqcCeZOFQj52l9Im8+YVvraRVjNbfog5bTKcqsQEIDiCWnWVD
	wZnln+EiuBal7+YPZHqvxrrw9N12wKhgkuboSSifi0N6Qtdx0RMtitf+5NQbD0Ni7bs5ENs8LMN
	AajUR1ZgEe0pY2X4dnXgVENLvTQc9wt1Nc71xxQmSsQuWhNuaC8ghzO7Nh1GM0v8O4MYEAkmfTb
	T9kPlV8LbVguvZEgo7im7jhXHtcxRfxGrmol6cTr7mStoJfu85mq7iNglJ53NEKH+TGu75QbBkh
	Wh9+q1fGhakKqWV+r8v8FSDVZVp3nqvZ56FB2o3BSvq5vPqxU9+3ig==
X-Google-Smtp-Source: AGHT+IFSxBwa9KnAS8L9/EAz8cLmuKb/l0d8yDFFaz3zOamCgdFD5cNHDH4gBGKhfk0z5d3IqpoPdw==
X-Received: by 2002:a05:600c:34c2:b0:439:3ba0:d564 with SMTP id 5b1f17b1804b1-4393ba0d6f4mr32217185e9.6.1739137249560;
        Sun, 09 Feb 2025 13:40:49 -0800 (PST)
Date: Sun, 9 Feb 2025 21:40:47 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
 <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Josh Poimboeuf
 <jpoimboe@redhat.com>, Andi Kleen <ak@linux.intel.com>, Dan Williams
 <dan.j.williams@intel.com>, linux-arch@vger.kernel.org, Kees Cook
 <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH 1/1] x86: In x86-64 barrier_nospec can always be lfence
Message-ID: <20250209214047.4552e806@pumpkin>
In-Reply-To: <CAHk-=wiQQQ9yo84KCk=Y_61siPsrH=dF9t5LPva0Sbh_RZ0-3Q@mail.gmail.com>
References: <20250209191008.142153-1-david.laight.linux@gmail.com>
	<CAHk-=wiQQQ9yo84KCk=Y_61siPsrH=dF9t5LPva0Sbh_RZ0-3Q@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 9 Feb 2025 11:32:32 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, 9 Feb 2025 at 11:10, David Laight <david.laight.linux@gmail.com> wrote:
> >
> > +#define barrier_nospec() __rmb()  
> 
> This is one of those "it happens to work, but it's wrong" things.
> 
> Just make it explicit that it's "lfence" in the current implementation.

Easily done.

Any idea what the one used to synchronise rdtsc should be?
'lfence' is the right instruction (give or take), but it isn't
a speculation issue.
It really is 'wait for all memory accesses to finish' to give
a sensible(ish) answer for cycle timing.
And on old cpu you want nothing - not a locked memory access.

> 
> Is __rmb() also an lfence? Yes. And that's actually very confusing too
> too. Because on x86, a regular read barrier is a no-op, and the "main"
> rmb definition is actually this:
> 
>   #define __dma_rmb()     barrier()
>   #define __smp_rmb()     dma_rmb()
> 
> so that it's only a compiler barrier.

I couldn't work out why __smp_mb() is so much stronger than the rmb()
and wmb() forms - I presume the is history there I wasn't looking for.

> And yes, __rmb() exists as the architecture-specific helper for "I
> need to synchronize with unordered IO accesses" and is purely about
> driver IO.

I'd missed the history of it being IO related.

...
> And some day in the future, maybe even that implementation equivalence
> ends up going away again, and we end up with new barrier instructions
> that depend on new CPU capabilities (or fake software capabilities:
> kernel bootup flags that say "don't bother with the nospec
> barriers").

Actually there is already the cpu flag to treat addresses with the top
bit set as 'supervisor' in the initial address decode - rather that
checking the page table in parallel with the d-cache accesses.
When that hits real silicon then patching out the barrier_nospec()
lfence would make sense.
There is also your kernel build machine where you don't care.
So compiling them out or boot patching them out is a real option.

This does make it more clear that the rdtsc code has the wrong barrier.

> So please keep the __rmb() and the barrier_nospec() separate, don't
> tie them together. They just have *soo* many differences, both
> conceptual and practical.

A simple V2 :-)

	David

> 
>              Linus

