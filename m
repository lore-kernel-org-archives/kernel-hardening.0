Return-Path: <SRS0=w4wO=DN=lists.openwall.com=kernel-hardening-return-20106-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE76FC4363A
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 02:16:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B12382085B
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 02:16:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VSSaWD0W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B12382085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20106-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10188 invoked by uid 550); 6 Oct 2020 02:16:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10168 invoked from network); 6 Oct 2020 02:16:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ifD/jW+MjbtS2EijgQAS4OITv0Z9zRA4cL1N04HQHu4=;
        b=VSSaWD0WAT8lHVeaIEU8br+ZuZLpGvG3RSgyTiKVEHpRLj5caJa8VuxrOzMMZmi4/I
         +jc18B7Thyp3/FetZnGQgiu+3jGf71BUbdlYdfQ/sXkO4yIffJZxsNlUT3OTfTYc+V53
         s/rD9zQmzH7e/+nYz+ii0l6JB/cgE0XhGNA8YvQrzBYVVZv+tfs+QQFQOzjgU6l2HxUK
         XgMhDW8lxfC88/jHL1K9CxVfkjKO7y42/ifl50NEIctn5atANq4PIvf9c4TvRkLRtmhv
         tnJm3J56L+FQTruYZN7URj8QELVaRv71JNVB9HeCWh34hlHaMpNzgxJKGO/gMn3MIfVk
         OgKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ifD/jW+MjbtS2EijgQAS4OITv0Z9zRA4cL1N04HQHu4=;
        b=d7nD5izj82BAIey7ct3MADY7XqJN7e2Cq1IXGmv5Jg1TL7sXd2gMeV/jc1mdrPO8Pi
         pzDPlHhrgZxgkB2inuSIjbspQZ7azCT1J754kToYRQex3tKWi+MVR+1TMPLJdrqLXYlJ
         cRFshLK8434ceg/s6IYbIoVH2fzaOqAMNazc0qEtloUk7Y+suJ35n4aWi5HEcl98on9y
         SawWpCCHReSQXGGTl7sdQnlrcNH6qMuy9tDcuaUYRqO1FAJrWDH8kuehmhiCBnQh3xcK
         OU7tf8WII+FBsfYT1xT+WoV1yt97+skJ4z2oe9rOwNgXcI+hs/qlKJBs+DuJBRqSOfLj
         s7gA==
X-Gm-Message-State: AOAM5303Eor5P2kay0uBCu+FxjDVG5YA5plDlsaB02t1boZlZiSHWMKE
	g8EXItYjT6fAfDXPLjojakRcBK+YZgjKD9livBhaUw==
X-Google-Smtp-Source: ABdhPJwxo4AWg8S4Ze5aWA5+V2LLRVib5nWtluQURuOp9DVBriFY+LJHVl4ksm/ZNF2+q+SZWj8S0GCu3SVtK3S+aco=
X-Received: by 2002:a17:906:fcae:: with SMTP id qw14mr2849150ejb.537.1601950598646;
 Mon, 05 Oct 2020 19:16:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200929183513.380760-1-alex.popov@linux.com> <91d564a6-9000-b4c5-15fd-8774b06f5ab0@linux.com>
 <CAG48ez1tNU_7n8qtnxTYZ5qt-upJ81Fcb0P2rZe38ARK=iyBkA@mail.gmail.com>
 <20201006004414.GP20115@casper.infradead.org> <202010051905.62D79560@keescook>
In-Reply-To: <202010051905.62D79560@keescook>
From: Jann Horn <jannh@google.com>
Date: Tue, 6 Oct 2020 04:16:12 +0200
Message-ID: <CAG48ez19ecXyqz+GZVsqqM73WZo7tNL4F7Q1vTTP6QG75NaWKw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/6] Break heap spraying needed for exploiting use-after-free
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>, Alexander Popov <alex.popov@linux.com>, 
	Will Deacon <will@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Christoph Lameter <cl@linux.com>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Patrick Bellasi <patrick.bellasi@arm.com>, 
	David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Laura Abbott <labbott@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Micay <danielmicay@gmail.com>, 
	Andrey Konovalov <andreyknvl@google.com>, Pavel Machek <pavel@denx.de>, 
	Valentin Schneider <valentin.schneider@arm.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	kernel list <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 6, 2020 at 4:09 AM Kees Cook <keescook@chromium.org> wrote:
> On Tue, Oct 06, 2020 at 01:44:14AM +0100, Matthew Wilcox wrote:
> > On Tue, Oct 06, 2020 at 12:56:33AM +0200, Jann Horn wrote:
> > > It seems to me like, if you want to make UAF exploitation harder at
> > > the heap allocator layer, you could do somewhat more effective things
> > > with a probably much smaller performance budget. Things like
> > > preventing the reallocation of virtual kernel addresses with different
> > > types, such that an attacker can only replace a UAF object with
> > > another object of the same type. (That is not an idea I like very much
> > > either, but I would like it more than this proposal.) (E.g. some
> > > browsers implement things along those lines, I believe.)
> >
> > The slab allocator already has that functionality.  We call it
> > TYPESAFE_BY_RCU, but if forcing that on by default would enhance security
> > by a measurable amount, it wouldn't be a terribly hard sell ...
>
> Isn't the "easy" version of this already controlled by slab_merge? (i.e.
> do not share same-sized/flagged kmem_caches between different caches)

Yes, but slab_merge still normally frees slab pages to the page allocator.

> The large trouble are the kmalloc caches, which don't have types
> associated with them. Having implicit kmem caches based on the type
> being allocated there would need some pretty extensive plumbing, I
> think?

Well, a bit of plumbing, at least. You'd need to teach the compiler
frontend to grab type names from sizeof() and stuff that type
information somewhere, e.g. by generating an extra function argument
referring to the type, or something like that. Could be as simple as a
reference to a bss section variable that encodes the type in the name,
and the linker already has the logic to automatically deduplicate
those across compilation units - that way, on the compiler side, a
pure frontend plugin might do the job?
