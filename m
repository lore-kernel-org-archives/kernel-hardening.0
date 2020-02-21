Return-Path: <SRS0=PrTT=4J=lists.openwall.com=kernel-hardening-return-17877-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F54C35661
	for <kernel-hardening@archiver.kernel.org>; Fri, 21 Feb 2020 19:51:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8A5A62072C
	for <kernel-hardening@archiver.kernel.org>; Fri, 21 Feb 2020 19:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VeZCBu8X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A5A62072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17877-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21855 invoked by uid 550); 21 Feb 2020 19:51:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21835 invoked from network); 21 Feb 2020 19:51:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1582314649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Unie+N+CR+ixt+b/4tM+0L7Mc0IBXa5zja9FG566mHU=;
	b=VeZCBu8XqibM6RYZWd5i5caYjgQJKrU4ufdiUCbmFTRmlaur5t8UE8nGSZHLzdzZfQn2GV
	a95qUugkozt0l1sQgDmhAhxjbgfRKeRTk7+xZMZ8H+37MruZSdQdUTnJRGp20SPwVOQxv1
	WU3V8bh7forNJ6qdawfqZ+f6IY2b/Gg=
X-MC-Unique: -uOvEtZqPMmhiOqSvYd13A-1
Date: Fri, 21 Feb 2020 13:50:39 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 06/11] x86: make sure _etext includes function
 sections
Message-ID: <20200221195039.dptvoerfez4r76ay@treble>
References: <75f0bd0365857ba4442ee69016b63764a8d2ad68.camel@linux.intel.com>
 <B413445A-F1F0-4FB7-AA9F-C5FF4CEFF5F5@amacapital.net>
 <20200207092423.GC14914@hirez.programming.kicks-ass.net>
 <202002091742.7B1E6BF19@keescook>
 <20200210105117.GE14879@hirez.programming.kicks-ass.net>
 <43b7ba31-6dca-488b-8a0e-72d9fdfd1a6b@linux.intel.com>
 <20200210163627.GA1829035@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200210163627.GA1829035@rani.riverdale.lan>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

On Mon, Feb 10, 2020 at 11:36:29AM -0500, Arvind Sankar wrote:
> On Mon, Feb 10, 2020 at 07:54:58AM -0800, Arjan van de Ven wrote:
> > > 
> > > I'll leave it to others to figure out the exact details. But afaict it
> > > should be possible to have fine-grained-randomization and preserve the
> > > workaround in the end.
> > > 
> > 
> > the most obvious "solution" is to compile with an alignment of 4 bytes (so tight packing)
> > and then in the randomizer preserve the offset within 32 bytes, no matter what it is
> > 
> > that would get you an average padding of 16 bytes which is a bit more than now but not too insane
> > (queue Kees' argument that tiny bits of padding are actually good)
> > 
> 
> With the patchset for adding the mbranches-within-32B-boundaries option,
> the section alignment gets forced to 32. With function-sections that
> means function alignment has to be 32 too.

We should be careful about enabling -mbranches-within-32B-boundaries.
It will hurt AMD, and presumably future Intel CPUs which don't need it.

-- 
Josh

