Return-Path: <SRS0=CnBk=FH=lists.openwall.com=kernel-hardening-return-20527-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768C7C4361A
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 20:49:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 67BBA221F4
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 20:49:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67BBA221F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20527-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22333 invoked by uid 550); 3 Dec 2020 20:49:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22310 invoked from network); 3 Dec 2020 20:49:29 -0000
Date: Thu, 3 Dec 2020 12:49:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1607028557;
	bh=Iz54XglcOoe77jtz7VvpJX1zZYveIrI7EDKyUjAzBNE=;
	h=From:To:Cc:Subject:In-Reply-To:References:From;
	b=gxZrBLg1g38jqJHt+4TRxSacQbXjfAQyuNgBBZy/cHOBt0sXTYgy/SY+E87Kr7A9h
	 tFbME0BPQ1cog44iqdXw5RjgsNxbHMs84gS8XcDB3hspHs3AN4ciqPywFHnHriekqe
	 +t5UDh5+9/BvJElIScMwNeWi/GHHDLWAYKDfnpIU=
From: Andrew Morton <akpm@linux-foundation.org>
To: alex.popov@linux.com
Cc: Alexander Potapenko <glider@google.com>, Kees Cook
 <keescook@chromium.org>, Jann Horn <jannh@google.com>, Will Deacon
 <will@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Dmitry Vyukov
 <dvyukov@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg
 <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim
 <iamjoonsoo.kim@lge.com>, Masahiro Yamada <masahiroy@kernel.org>, Masami
 Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Peter Zijlstra <peterz@infradead.org>, Krzysztof Kozlowski
 <krzk@kernel.org>, Patrick Bellasi <patrick.bellasi@arm.com>, David Howells
 <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Laura Abbott <labbott@redhat.com>, Arnd
 Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Daniel Micay <danielmicay@gmail.com>, Andrey Konovalov
 <andreyknvl@google.com>, Matthew Wilcox <willy@infradead.org>, Pavel Machek
 <pavel@denx.de>, Valentin Schneider <valentin.schneider@arm.com>, kasan-dev
 <kasan-dev@googlegroups.com>, Linux Memory Management List
 <linux-mm@kvack.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>,
 notify@kernel.org
Subject: Re: [PATCH RFC v2 2/6] mm/slab: Perform init_on_free earlier
Message-Id: <20201203124914.25e63b013e9c69c79d481831@linux-foundation.org>
In-Reply-To: <1772bc7d-e87f-0f62-52a8-e9d9ac99f5e3@linux.com>
References: <20200929183513.380760-1-alex.popov@linux.com>
	<20200929183513.380760-3-alex.popov@linux.com>
	<CAG_fn=WY9OFKuy6utMHOgyr+1DYNsuzVruGCGHMDnEnaLY6s9g@mail.gmail.com>
	<1772bc7d-e87f-0f62-52a8-e9d9ac99f5e3@linux.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 3 Dec 2020 22:50:27 +0300 Alexander Popov <alex.popov@linux.com> wrote:

> On 30.09.2020 15:50, Alexander Potapenko wrote:
> > On Tue, Sep 29, 2020 at 8:35 PM Alexander Popov <alex.popov@linux.com> wrote:
> >>
> >> Currently in CONFIG_SLAB init_on_free happens too late, and heap
> >> objects go to the heap quarantine being dirty. Lets move memory
> >> clearing before calling kasan_slab_free() to fix that.
> >>
> >> Signed-off-by: Alexander Popov <alex.popov@linux.com>
> > Reviewed-by: Alexander Potapenko <glider@google.com>
> 
> Hello!
> 
> Can this particular patch be considered for the mainline kernel?

All patches are considered ;) And merged if they're reviewed, tested,
judged useful, etc.

If you think this particular patch should be fast-tracked then please
send it as a non-RFC, standalone patch.  Please also enhance the
changelog so that it actually explains what goes wrong.  Presumably
"objects go to the heap quarantine being dirty" causes some
user-visible problem?  What is that problem?

