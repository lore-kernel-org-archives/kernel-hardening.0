Return-Path: <SRS0=ApVa=DA=lists.openwall.com=kernel-hardening-return-19969-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25499C4363D
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 14:40:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2876321D43
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 14:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+dmkEqP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2876321D43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19969-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14241 invoked by uid 550); 23 Sep 2020 14:40:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14220 invoked from network); 23 Sep 2020 14:40:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1600871988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XtUNJYHV2J1JZ6JLBA0jisxCSujCzEq2vD80O/D6hKQ=;
	b=G+dmkEqPJBi3f5i7FcUcaVulmRYMAH2y73HVTLnvN6Mb3DmCloP3XKtaNvgoBj2RDKbHwA
	2MWENmDITUuUSD8/OUY1HqonbmMY3rVqddRf32kXbvH+xrq0lAzmXKun8FRQVr+oNDgv5a
	8Zj2hNFefaykwdvpC11DhMr7gX9oNk0=
X-MC-Unique: Ai1jqBmFMUa4zYresSj0Pg-1
From: Florian Weimer <fweimer@redhat.com>
To: Solar Designer <solar@openwall.com>
Cc: Pavel Machek <pavel@ucw.cz>,  madvenka@linux.microsoft.com,
  kernel-hardening@lists.openwall.com,  linux-api@vger.kernel.org,
  linux-arm-kernel@lists.infradead.org,  linux-fsdevel@vger.kernel.org,
  linux-integrity@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-security-module@vger.kernel.org,  oleg@redhat.com,  x86@kernel.org,
  luto@kernel.org,  David.Laight@ACULAB.COM,  mark.rutland@arm.com,
  mic@digikod.net,  Rich Felker <dalias@libc.org>
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
References: <20200922215326.4603-1-madvenka@linux.microsoft.com>
	<20200923081426.GA30279@amd> <20200923091456.GA6177@openwall.com>
Date: Wed, 23 Sep 2020 16:39:31 +0200
In-Reply-To: <20200923091456.GA6177@openwall.com> (Solar Designer's message of
	"Wed, 23 Sep 2020 11:14:57 +0200")
Message-ID: <87wo0ko8v0.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

* Solar Designer:

> While I share my opinion here, I don't mean that to block Madhavan's
> work.  I'd rather defer to people more knowledgeable in current userland
> and ABI issues/limitations and plans on dealing with those, especially
> to Florian Weimer.  I haven't seen Florian say anything specific for or
> against Madhavan's proposal, and I'd like to.  (Have I missed that?)

There was a previous discussion, where I provided feedback (not much
different from the feedback here, given that the mechanism is mostly the
same).

I think it's unnecessary for the libffi use case.  Precompiled code can
be loaded from disk because the libffi trampolines are so regular.  On
most architectures, it's not even the code that's patched, but some of
the data driving it, which happens to be located on the same page due to
a libffi quirk.

The libffi use case is a bit strange anyway: its trampolines are
type-generic, and the per-call adjustment is data-driven.  This means
that once you have libffi in the process, you have a generic
data-to-function-call mechanism available that can be abused (it's even
fully CET compatible in recent versions).  And then you need to look at
the processes that use libffi.  A lot of them contain bytecode
interpreters, and those enable data-driven arbitrary code execution as
well.  I know that there are efforts under way to harden Python, but
it's going to be tough to get to the point where things are still
difficult for an attacker once they have the ability to make mprotect
calls.

It was pointed out to me that libffi is doing things wrong, and the
trampolines should not be type-generic, but generated so that they match
the function being called.  That is, the marshal/unmarshal code would be
open-coded in the trampoline, rather than using some generic mechanism
plus run-time dispatch on data tables describing the function type.
That is a very different design (and typically used by compilers (JIT or
not JIT) to implement native calls).  Mapping some code page with a
repeating pattern would no longer work to defeat anti-JIT measures
because it's closer to real JIT.  I don't know if kernel support could
make sense in this context, but it would be a completely different
patch.

Thanks,
Florian
-- 
Red Hat GmbH, https://de.redhat.com/ , Registered seat: Grasbrunn,
Commercial register: Amtsgericht Muenchen, HRB 153243,
Managing Directors: Charles Cachera, Brian Klemm, Laurie Krebs, Michael O'Neill

