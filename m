Return-Path: <SRS0=T8iN=6S=lists.openwall.com=kernel-hardening-return-18712-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CACC47257
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 May 2020 18:04:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DADA02073B
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 May 2020 18:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rpULkMOh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DADA02073B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18712-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5287 invoked by uid 550); 4 May 2020 18:04:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5267 invoked from network); 4 May 2020 18:04:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rcDmJIg6XQDOa3chgWWWTIDoYfHpXCrYezz5o9UsioM=;
        b=rpULkMOhQ4XZU3gawsHD+pAOZ/hs2S8hKO6veZt59CSRwuHnSJXAiuoI75zoy7R9Ll
         uf4UZP+VqLBAvTEWV5yIfVLut+GowlNGk+3EGPjaOP5qKHnnI3l48fex3cTWR4l44GLH
         8wd5MdAVyv692TTfAXe+O3MU9ndQq3PxjqaW6TxHBflien/xVKeDzY6auFfoNRYH/B/2
         fC6JEADleGtaKfIPrip+5m6sMwyC2n6uWKxRL5+H+CJ0cW58eC7MD2VZjb96sOpTG+7G
         Ae7Y3Et/iIuTjbwxhdpZH3qq7AeT35TAmNFcQPrZptvKZd4RSfnQClAONC3cth5/dvFR
         Wvtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rcDmJIg6XQDOa3chgWWWTIDoYfHpXCrYezz5o9UsioM=;
        b=YvloIijHsrpbH8QUwMLuZ7zTfoabcJKFf9JqnPvdJ8g0EID8rG7QSmKecEJwfxhGo4
         rPlNlu4qcBC7EZWhllsxHnyfX0hJt21LSsha6rgbbCrmJSsSAhfX4dkQRSqS+3sWYyLf
         EmMq2x7/+r3xLGn3/m2BvTp0esNSx8qpd8YtdlFgmVeVUrKKd7tHuZXhzD/0DRgUFX+D
         HZ0MZ39KjP0em2ZgKJQkzFsGULXLWHSZiRR6C2dRdXx/+kKa7VYL/keb6b6FzleUbvwv
         zH3JMDGIqTLBdCF/+zVNheXMrizkgQrhkaBcEaAbhZX/YaJWjEtn2NrZXo34Y77cjLl6
         L9Jg==
X-Gm-Message-State: AGi0PuYIfl1xcVtIJ2effq8ohDn9UfORduYo4EMkjlrweCAJ9l7uT39H
	I/MNoe8vOxl5lpXat/BgkpYioxa1pS+CSwqDk84ERg==
X-Google-Smtp-Source: APiQypIHcgbbdXmVy3vl3ztP5eNJSATUT2t97dtLpQSHGN3q+TF5z+bWNiX9e7gWwtb8yO4Jkfo2dPzDOiP5vUAhK0c=
X-Received: by 2002:a2e:b249:: with SMTP id n9mr11270265ljm.221.1588615432462;
 Mon, 04 May 2020 11:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com> <20200416161245.148813-2-samitolvanen@google.com>
 <20200420171727.GB24386@willie-the-truck> <20200420211830.GA5081@google.com>
 <20200422173938.GA3069@willie-the-truck> <20200422235134.GA211149@google.com>
 <202004231121.A13FDA100@keescook> <20200424112113.GC21141@willie-the-truck>
 <20200427204546.GA80713@google.com> <20200504165227.GB1833@willie-the-truck>
In-Reply-To: <20200504165227.GB1833@willie-the-truck>
From: Jann Horn <jannh@google.com>
Date: Mon, 4 May 2020 20:03:25 +0200
Message-ID: <CAG48ez0OjQpCvO1EqUqtHX+zVj27p3yWd5riY_r7+rNWwec_OQ@mail.gmail.com>
Subject: Re: [PATCH v11 01/12] add support for Clang's Shadow Call Stack (SCS)
To: Will Deacon <will@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Kees Cook <keescook@chromium.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Michal Marek <michal.lkml@markovi.net>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, May 4, 2020 at 6:52 PM Will Deacon <will@kernel.org> wrote:
> On Mon, Apr 27, 2020 at 01:45:46PM -0700, Sami Tolvanen wrote:
> > On Fri, Apr 24, 2020 at 12:21:14PM +0100, Will Deacon wrote:
> > > Also, since you mentioned the lack of redzoning, isn't it a bit dodgy
> > > allocating blindly out of the kmem_cache? It means we don't have a redzone
> > > or a guard page, so if you can trigger something like a recursion bug then
> > > could you scribble past the SCS before the main stack overflows? Would this
> > > clobber somebody else's SCS?
> >
> > I agree that allocating from a kmem_cache isn't ideal for safety. It's a
> > compromise to reduce memory overhead.
>
> Do you think it would be a problem if we always allocated a page for the
> SCS?

I guess doing this safely and without wasting a page per task would
only be possible in an elegant way once MTE lands on devices?

I wonder how bad context switch latency would be if the actual SCS was
percpu and vmapped (starting at an offset inside the page such that
the SCS can only grow up to something like 0x400 bytes before
panicking the CPU) and the context switch path saved/restored the used
part of the vmapped SCS into a smaller allocation from the slab
allocator... presumably the SCS will usually just be something like
one cacheline big? That probably only costs a moderate amount of time
to copy...
Or as an extension of that, if the SCS copying turns out to be too
costly, there could be a percpu LRU cache consisting of vmapped SCS
pages, and whenever a task gets scheduled that doesn't have a vmapped
SCS, it "swaps out" the contents of the least recently used vmapped
SCS into the corresponding task's slab SCS, and "swaps in" from its
own slab SCS into the vmapped SCS. And task migration would force
"swapping out".

Not sure if this is a good idea, or if I'm just making things worse by
suggesting extra complexity...
