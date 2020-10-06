Return-Path: <SRS0=TpFA=DN=lists.openwall.com=kernel-hardening-return-20104-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF92C4363A
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 02:09:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F097A20760
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 02:09:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jDfIYFTb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F097A20760
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20104-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4074 invoked by uid 550); 6 Oct 2020 02:09:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4047 invoked from network); 6 Oct 2020 02:09:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5uyUjU81WTaoePaJ6pjDUCkELEhzyE83H9lRZhP1V5g=;
        b=jDfIYFTbm5fkMc29R8o9ZHzX7Pte5RCT8w+9F5TNDpMHIl3zGQzp4q/T71oiQgb/Si
         k1O/y8IqkbJWAFT7y97YeQ6EIsYzITVWj2oBZvzYlLyMjwb8Wu46wKdTHdqb5EdpdpIe
         2MJyTF338pNoHuKyl4uFjC7Li4Vt/hvBkHZ6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5uyUjU81WTaoePaJ6pjDUCkELEhzyE83H9lRZhP1V5g=;
        b=Da9hw8dyqL5FOJ/NL5lbHAzUJmq7GmYWg19q0r+ae0O4pscW6qLwaT8CSF3ToFQ2Vw
         B/vGT6b1G+eVXjWFnAZnlAQ4+v//tNSd/j/HV7hFSaNGCn7dM6lLtb2Tk3/mxZlj+yUa
         bX4tSRBn25lFmlASo9ZhbQhGk6DUOhaCoehQiluDnuk7izivUwmdUtzXZIPub30wRWCY
         dMcvOqqFVemnCHjV3BX21tdByj30UvowoWttTR6dphICgQDl0a5uHfm/H+Y42XLF1lrM
         mfctPpmoMNlMuIkDAJXsmLqw8Kho+VOjKYQsIATvUi6Xg5qx+9AIgSjwZJ4Tk3/Poa/o
         Asow==
X-Gm-Message-State: AOAM533/K8U2E2Q9u9lQiNmpwYHzbjtlH5l7JTPVlNIiDyd6HKK3EhEu
	+BNaiMkto5P6eyW2XrLihXOdRw==
X-Google-Smtp-Source: ABdhPJw1yy34c+6y9kLpMI11/8Zi779s/k+fdqtafVTUPFWsVg2uuJr39pC14FmoS/i8HTu+80T8OQ==
X-Received: by 2002:aa7:8249:0:b029:142:2501:3964 with SMTP id e9-20020aa782490000b029014225013964mr2373840pfn.41.1601950167029;
        Mon, 05 Oct 2020 19:09:27 -0700 (PDT)
Date: Mon, 5 Oct 2020 19:09:24 -0700
From: Kees Cook <keescook@chromium.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>, Alexander Popov <alex.popov@linux.com>,
	Will Deacon <will@kernel.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Patrick Bellasi <patrick.bellasi@arm.com>,
	David Howells <dhowells@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Laura Abbott <labbott@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Pavel Machek <pavel@denx.de>,
	Valentin Schneider <valentin.schneider@arm.com>,
	kasan-dev <kasan-dev@googlegroups.com>,
	Linux-MM <linux-mm@kvack.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	kernel list <linux-kernel@vger.kernel.org>, notify@kernel.org
Subject: Re: [PATCH RFC v2 0/6] Break heap spraying needed for exploiting
 use-after-free
Message-ID: <202010051905.62D79560@keescook>
References: <20200929183513.380760-1-alex.popov@linux.com>
 <91d564a6-9000-b4c5-15fd-8774b06f5ab0@linux.com>
 <CAG48ez1tNU_7n8qtnxTYZ5qt-upJ81Fcb0P2rZe38ARK=iyBkA@mail.gmail.com>
 <20201006004414.GP20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006004414.GP20115@casper.infradead.org>

On Tue, Oct 06, 2020 at 01:44:14AM +0100, Matthew Wilcox wrote:
> On Tue, Oct 06, 2020 at 12:56:33AM +0200, Jann Horn wrote:
> > It seems to me like, if you want to make UAF exploitation harder at
> > the heap allocator layer, you could do somewhat more effective things
> > with a probably much smaller performance budget. Things like
> > preventing the reallocation of virtual kernel addresses with different
> > types, such that an attacker can only replace a UAF object with
> > another object of the same type. (That is not an idea I like very much
> > either, but I would like it more than this proposal.) (E.g. some
> > browsers implement things along those lines, I believe.)
> 
> The slab allocator already has that functionality.  We call it
> TYPESAFE_BY_RCU, but if forcing that on by default would enhance security
> by a measurable amount, it wouldn't be a terribly hard sell ...

Isn't the "easy" version of this already controlled by slab_merge? (i.e.
do not share same-sized/flagged kmem_caches between different caches)

The large trouble are the kmalloc caches, which don't have types
associated with them. Having implicit kmem caches based on the type
being allocated there would need some pretty extensive plumbing, I
think?

-- 
Kees Cook
