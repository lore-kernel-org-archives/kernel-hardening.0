Return-Path: <SRS0=T5cX=BZ=lists.openwall.com=kernel-hardening-return-19632-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DFC2C433DF
	for <kernel-hardening@archiver.kernel.org>; Sat, 15 Aug 2020 16:39:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7E6A723102
	for <kernel-hardening@archiver.kernel.org>; Sat, 15 Aug 2020 16:39:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hyCX5dk0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7E6A723102
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19632-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32446 invoked by uid 550); 15 Aug 2020 16:39:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32424 invoked from network); 15 Aug 2020 16:39:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4J3Q2ehkUro4Gqm1OJFrAMNOhAG6pUBKwcsUWslCw24=;
        b=hyCX5dk0lc2fQo6AdVYPsyRwjQfIab+4kVsuGBOTS+rgoLmgvGzpAXpHdYdu25Ucxt
         p2vFxbC2jLyIN89paD62Unq+y0/DgbwcYwsRPTW0bMKamVAtr8RXj0r7D2sTV4u9WLlh
         ofnmietSfjV60Yd2MknF/JhR+Il9lbRkXQsjw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4J3Q2ehkUro4Gqm1OJFrAMNOhAG6pUBKwcsUWslCw24=;
        b=OY8cbtpQCR1MPKyaNBESY6MKpxaRnUXPoOenWfp5DsHZeWX/LpbuZ53Lk4mKOgU3VZ
         dSC547vqkei9anJFTky5x8T5TYuJOcosdUDaCZZiSyVPSt4eoLyHBjHwFC1bo+ff3PTX
         BDe78JKCgS7gcNTh6u65ht1tb/VXzoJ8tHbE0ieU2X7LT57yqKC4MeJOVWnGYju1dsfb
         RewH7V9AzcMla+DWL1zQauklNdN71NM8GbvgOJoLR9yrCAPDKYldu6vnR1ybLpZ0VAq1
         WXziS8uBx0N41RjWrztHwFp97XKssBzCqrMVb1Y5uKt1/TqTR9U80kUJ82qj0b8aHlSs
         I6mg==
X-Gm-Message-State: AOAM531+5jEGbe4OihC5OlKZYBS8dzRDko82PkNpCiU+/879U/xD/A1p
	VuTcYOF7oFtQYUCI5WWbBCTpLQ==
X-Google-Smtp-Source: ABdhPJwQ7WFh+zuUDNylvWNHBYfJx/1UItdvutSrtmbdzkqKHZNwQsyxlZmknMcj2X+TU5UN9AI9iA==
X-Received: by 2002:a17:90a:148:: with SMTP id z8mr6733727pje.197.1597509544802;
        Sat, 15 Aug 2020 09:39:04 -0700 (PDT)
Date: Sat, 15 Aug 2020 09:39:02 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Jann Horn <jannh@google.com>, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH RFC 0/2] Break heap spraying needed for exploiting
 use-after-free
Message-ID: <202008150935.4C2F32559F@keescook>
References: <20200813151922.1093791-1-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813151922.1093791-1-alex.popov@linux.com>

On Thu, Aug 13, 2020 at 06:19:20PM +0300, Alexander Popov wrote:
> I've found an easy way to break heap spraying for use-after-free
> exploitation. I simply extracted slab freelist quarantine from KASAN
> functionality and called it CONFIG_SLAB_QUARANTINE. Please see patch 1.

Ah yeah, good idea. :)

> [...]
> I did a brief performance evaluation of this feature.
> 
> 1. Memory consumption. KASAN quarantine uses 1/32 of the memory.
> CONFIG_SLAB_QUARANTINE disabled:
>   # free -m
>                 total        used        free      shared  buff/cache   available
>   Mem:           1987          39        1862          10          86        1907
>   Swap:             0           0           0
> CONFIG_SLAB_QUARANTINE enabled:
>   # free -m
>                 total        used        free      shared  buff/cache   available
>   Mem:           1987         140        1760          10          87        1805
>   Swap:             0           0           0

1/32 of memory doesn't seem too bad for someone interested in this defense.

> 2. Performance penalty. I used `hackbench -s 256 -l 200 -g 15 -f 25 -P`.
> CONFIG_SLAB_QUARANTINE disabled (x86_64, CONFIG_SLUB):
>   Times: 3.088, 3.103, 3.068, 3.103, 3.107
>   Mean: 3.0938
>   Standard deviation: 0.0144
> CONFIG_SLAB_QUARANTINE enabled (x86_64, CONFIG_SLUB):
>   Times: 3.303, 3.329, 3.356, 3.314, 3.292
>   Mean: 3.3188 (+7.3%)
>   Standard deviation: 0.0223

That's rather painful, but hackbench can produce some big deltas given
it can be an unrealistic workload for most systems. I'd be curious to
see the "building a kernel" timings, which tends to be much more
realistic for "busy system" without hammering one particular subsystem
(though it's a bit VFS heavy, obviously).

More notes in the patches...

-- 
Kees Cook
