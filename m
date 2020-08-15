Return-Path: <SRS0=vpxt=BZ=lists.openwall.com=kernel-hardening-return-19637-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5122C433E1
	for <kernel-hardening@archiver.kernel.org>; Sat, 15 Aug 2020 18:55:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3453B23B6F
	for <kernel-hardening@archiver.kernel.org>; Sat, 15 Aug 2020 18:55:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="GPHj7mF5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3453B23B6F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19637-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9422 invoked by uid 550); 15 Aug 2020 18:55:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9400 invoked from network); 15 Aug 2020 18:55:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SYhsdz9Ikw/5Id67XdrFAG6RYY/GnifUtuavkK2F1mo=; b=GPHj7mF5tQxFUHGIb+vUHBhFvb
	viu4v6hOIabQCCvC2ShC+wg5VDEpFLVz3pQ9emHprrtHALfAeBm8tyXyXzr+5ScH78gcFybPBuBFp
	8JoyUaq4GaPGa9sNYZ/RdQWnBZZO5NgJVySKsAbK0v35o2Mt5iRFpJBOy6SDfSAL5zCQathZaYN45
	aIKp7Fxx83adx921tPLvn93HeDfLHLek7YBiuGjhTMdquC435ptpkXDvrPlyaAXEnoK34Yk+ugwbX
	/++ZiDWW2wuYR6x4WAiq2ZCcu3A1BddzYWUKJhR6Kb9jmMzcxus+gohduHlSqtPrS6HYuabKex/Sf
	h/l9nB9w==;
Date: Sat, 15 Aug 2020 19:54:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
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
	kasan-dev@googlegroups.com, linux-mm@kvack.org,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	notify@kernel.org
Subject: Re: [PATCH RFC 1/2] mm: Extract SLAB_QUARANTINE from KASAN
Message-ID: <20200815185455.GB17456@casper.infradead.org>
References: <20200813151922.1093791-1-alex.popov@linux.com>
 <20200813151922.1093791-2-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813151922.1093791-2-alex.popov@linux.com>

On Thu, Aug 13, 2020 at 06:19:21PM +0300, Alexander Popov wrote:
> +config SLAB_QUARANTINE
> +	bool "Enable slab freelist quarantine"
> +	depends on !KASAN && (SLAB || SLUB)
> +	help
> +	  Enable slab freelist quarantine to break heap spraying technique
> +	  used for exploiting use-after-free vulnerabilities in the kernel
> +	  code. If this feature is enabled, freed allocations are stored
> +	  in the quarantine and can't be instantly reallocated and
> +	  overwritten by the exploit performing heap spraying.
> +	  This feature is a part of KASAN functionality.

After this patch, it isn't part of KASAN any more ;-)

The way this is written is a bit too low level.  Let's write it in terms
that people who don't know the guts of the slab allocator or security
terminology can understand:

	  Delay reuse of freed slab objects.  This makes some security
	  exploits harder to execute.  It reduces performance slightly
	  as objects will be cache cold by the time they are reallocated,
	  and it costs a small amount of memory.

(feel free to edit this)

> +struct qlist_node {
> +	struct qlist_node *next;
> +};

I appreciate this isn't new, but why do we have a new singly-linked-list
abstraction being defined in this code?

