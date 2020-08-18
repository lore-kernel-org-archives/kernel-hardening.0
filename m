Return-Path: <SRS0=0zMC=B4=lists.openwall.com=kernel-hardening-return-19655-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38369C433E1
	for <kernel-hardening@archiver.kernel.org>; Tue, 18 Aug 2020 15:46:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5559922C9F
	for <kernel-hardening@archiver.kernel.org>; Tue, 18 Aug 2020 15:46:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ee8Rbkby"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5559922C9F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19655-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3454 invoked by uid 550); 18 Aug 2020 15:46:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3434 invoked from network); 18 Aug 2020 15:46:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LaWl8Zpiv/jFVXO3m0WashM5ldm/W64kfnal4k5ac3s=;
        b=ee8Rbkby61dQq7lCcZOsAyUQIuSGcYEtLC0PiPpU+eKTVLvPY5Q9nFZK+at9upsFjw
         xC7psyYAxV3H4XatlFiqQ3lZPTtMKxblP/lm6YmIOuL9f6naLRF1Bz7BOH/y0ffbWaUy
         Zw8ByQbMF7ZoSYo3HlbbkWRGjV7/tizUURsy25OHGpqGS6LE/jm05t9RL1+Fok4afK60
         U2t0dMWD4fD1XkZjx5Y8P16uezJ4REIRf49KSsJtAtUVAmYvkCB5stGCRSOQhkClunrq
         3p1pNqEU+Vn+ghlFl/INrW8UOJbd5A/Ulie48CIvmDUtvEkxXiiTeNyImlRzPRbrjBzT
         jLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LaWl8Zpiv/jFVXO3m0WashM5ldm/W64kfnal4k5ac3s=;
        b=qsJx+P/vTUiexxsgGV6hFS5u+3CynwpgSVgkDP4uYT+G75nLNt9F8r3I+ML8rbfz0L
         NMBuVxL3CiEo+qdTEhA3vJOluNP25svK4dnwx5aBL/DNMtGIUQPWc56B5OCxXS1syUlA
         44HX+hURwNKZ+Qtipz7fC6bqBQCj26O5qmiZgI3181mlGr1wCHeFJqVlzYqLKifZuGT6
         c1IZDJntnCwZzMdddWyFSCwLzdOG3W7ZMa2Eujd0/AIfEsYXQ5bzMTYL838l2wVxSnI7
         d9x2AEapMTkSDjLA8y1pOGmMBoZbrRUPQj0hO+XlZKxBpuqYJlaAjtr7pWRliVkLhBja
         2GyQ==
X-Gm-Message-State: AOAM531OLr9ZsP+UWCOrLhoYyzCdIG8aHqqgiwydOSWbMYNBAYnJ4uDp
	anwhreaKkHq55PkPpd0O0M4h7LToeHbXKMJAydYmbQ==
X-Google-Smtp-Source: ABdhPJwvek9/UE22iuTmUPANkh4gr6Kban+1Xge7EcyTlYgnVUC/xb5/ww37hGdor0eyhlS6u0Gg0Evh978FGWvgKVE=
X-Received: by 2002:a65:680b:: with SMTP id l11mr7436248pgt.440.1597765563163;
 Tue, 18 Aug 2020 08:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200813151922.1093791-1-alex.popov@linux.com>
 <20200813151922.1093791-2-alex.popov@linux.com> <202008150939.A994680@keescook>
 <82edcbac-a856-cf9e-b86d-69a4315ea8e4@linux.com>
In-Reply-To: <82edcbac-a856-cf9e-b86d-69a4315ea8e4@linux.com>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Tue, 18 Aug 2020 17:45:50 +0200
Message-ID: <CAAeHK+z9FPc9dqHwLA7sXTdpjt-iQweaQGQjq8L=eTYe2WdJ+g@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] mm: Extract SLAB_QUARANTINE from KASAN
To: Alexander Popov <alex.popov@linux.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, 
	kasan-dev <kasan-dev@googlegroups.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, 
	Will Deacon <will@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Peter Zijlstra <peterz@infradead.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Patrick Bellasi <patrick.bellasi@arm.com>, David Howells <dhowells@redhat.com>, 
	Eric Biederman <ebiederm@xmission.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Laura Abbott <labbott@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, kernel-hardening@lists.openwall.com, 
	LKML <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 17, 2020 at 7:32 PM Alexander Popov <alex.popov@linux.com> wrote:
>
> On 15.08.2020 19:52, Kees Cook wrote:
> > On Thu, Aug 13, 2020 at 06:19:21PM +0300, Alexander Popov wrote:
> >> Heap spraying is an exploitation technique that aims to put controlled
> >> bytes at a predetermined memory location on the heap. Heap spraying for
> >> exploiting use-after-free in the Linux kernel relies on the fact that on
> >> kmalloc(), the slab allocator returns the address of the memory that was
> >> recently freed. Allocating a kernel object with the same size and
> >> controlled contents allows overwriting the vulnerable freed object.
> >>
> >> Let's extract slab freelist quarantine from KASAN functionality and
> >> call it CONFIG_SLAB_QUARANTINE. This feature breaks widespread heap
> >> spraying technique used for exploiting use-after-free vulnerabilities
> >> in the kernel code.
> >>
> >> If this feature is enabled, freed allocations are stored in the quarantine
> >> and can't be instantly reallocated and overwritten by the exploit
> >> performing heap spraying.
> >
> > It may be worth clarifying that this is specifically only direct UAF and
> > doesn't help with spray-and-overflow-into-a-neighboring-object attacks
> > (i.e. both tend to use sprays, but the former doesn't depend on a write
> > overflow).
>
> Andrey Konovalov wrote:
> > If quarantine is to be used without the rest of KASAN, I'd prefer for
> > it to be separated from KASAN completely: move to e.g. mm/quarantine.c
> > and don't mention KASAN in function/config names.
>
> Hmm, making quarantine completely separate from KASAN would bring troubles.
>
> Currently, in many special places the allocator calls KASAN handlers:
>   kasan_cache_create()
>   kasan_slab_free()
>   kasan_kmalloc_large()
>   kasan_krealloc()
>   kasan_slab_alloc()
>   kasan_kmalloc()
>   kasan_cache_shrink()
>   kasan_cache_shutdown()
>   and some others.
> These functions do a lot of interesting things and also work with the quarantine
> using these helpers:
>   quarantine_put()
>   quarantine_reduce()
>   quarantine_remove_cache()
>
> Making quarantine completely separate from KASAN would require to move some
> internal logic of these KASAN handlers to allocator code.

It doesn't look like there's quite a lot of KASAN-specific logic there.

All those quarantine_*() calls are either at the beginning or at the
end of some kasan annotations, so it should be quite easy to move
those out. E.g. quarantine_reduce() can be moved together with the
gfpflags_allow_blocking(flags) check and put before kasan_kmalloc()
calls (or maybe also into some other places?), quarantine_put() can be
put after kasan_slab_free(), etc.

> In this patch I used another approach, that doesn't require changing the API
> between allocators and KASAN. I added linux/mm/kasan/slab_quarantine.c with slim
> KASAN handlers that implement the minimal functionality needed for quarantine.
>
> Do you think that it's a bad solution?

This solution doesn't look clean. Here you provide a second KASAN
runtime implementation, parallel to the original one, which only does
quarantine. It seems much cleaner to put quarantine logic into a
separate module, which can be either used independently, or together
with KASAN built on top of it.

Maybe other KASAN contributors have an opinion on this?
