Return-Path: <SRS0=0tOI=DN=lists.openwall.com=kernel-hardening-return-20102-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADA1C4363A
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 00:45:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4D66E20791
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 00:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Onk4Nn05"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D66E20791
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20102-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30575 invoked by uid 550); 6 Oct 2020 00:45:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30552 invoked from network); 6 Oct 2020 00:45:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d7VSZPo044cxIxYzl44q0fNIFgW7c06/GV69ntJURIg=; b=Onk4Nn051IJxw0teFwDsjobrty
	/hDTEB5jMbF5zBhq7h/fTlEWFJuJQ6/DHdsGOawLRI/mo45t/zac/xr4OyiDc76laFKIS0VcEk+BH
	SYq4Tv0ANxtWGY1KTbNyqsfTQziZajI6DqMlSm0N/V0L2VBSrD7SuPaL+CNX9V22YQ4Q195wh6ypm
	7pCUi+ZoSePY0B1pgMOPGSsQz+I/sPpsHlAsHf2pn9SWMi9v5eMFuQ7aUilqpusQHg3NA00dc5td0
	VN8c8EYbPTr4LFm0wS44cWMhoPLdMg9s4QKWZQkMTSY0VZHbIm8nzywpx6/5N6wVmCH3IKoyT03BA
	WqxfoMhA==;
Date: Tue, 6 Oct 2020 01:44:14 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Alexander Popov <alex.popov@linux.com>,
	Kees Cook <keescook@chromium.org>, Will Deacon <will@kernel.org>,
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
Message-ID: <20201006004414.GP20115@casper.infradead.org>
References: <20200929183513.380760-1-alex.popov@linux.com>
 <91d564a6-9000-b4c5-15fd-8774b06f5ab0@linux.com>
 <CAG48ez1tNU_7n8qtnxTYZ5qt-upJ81Fcb0P2rZe38ARK=iyBkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1tNU_7n8qtnxTYZ5qt-upJ81Fcb0P2rZe38ARK=iyBkA@mail.gmail.com>

On Tue, Oct 06, 2020 at 12:56:33AM +0200, Jann Horn wrote:
> It seems to me like, if you want to make UAF exploitation harder at
> the heap allocator layer, you could do somewhat more effective things
> with a probably much smaller performance budget. Things like
> preventing the reallocation of virtual kernel addresses with different
> types, such that an attacker can only replace a UAF object with
> another object of the same type. (That is not an idea I like very much
> either, but I would like it more than this proposal.) (E.g. some
> browsers implement things along those lines, I believe.)

The slab allocator already has that functionality.  We call it
TYPESAFE_BY_RCU, but if forcing that on by default would enhance security
by a measurable amount, it wouldn't be a terribly hard sell ...
