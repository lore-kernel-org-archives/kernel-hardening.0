Return-Path: <SRS0=j1mR=36=lists.openwall.com=kernel-hardening-return-17748-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B80C352A5
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 16:36:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5950520870
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 16:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ng1G/VSw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5950520870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17748-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32323 invoked by uid 550); 10 Feb 2020 16:36:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32299 invoked from network); 10 Feb 2020 16:36:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B82P8bR5ozDn3yo+U/Bu+4ns+QtyTtYccr3OgXM2Xto=;
        b=ng1G/VSw9LRJOGQ1b6uRbkUgf37UT3j939mOC/5gYT9UUEFV3K9QbsTejURWL01vLe
         rmgHOjhlMXui4fo07OLbG88qSfkSbXMR0ti2l9a/Zu8qAtzhImtWAFOm4E9VCIcyf3ft
         +8VvpSZ7CXcUx/r+OE8G14NpzjP8nvDqR49PbWCEPFRMxE6MejJOT4VGgxdq5qSY31cL
         Tw9kxO4TfQ7bWh0xD9zJRZOpgUJe1D4j9zIxFSa9mHovxIAmZuVAdRfgHicFGiVwi4iU
         OUnL90cliCXC+I9LtanC8Q1JIFuXx5BdlxLeEX9DablDUFMfIS8auz1nJS4qx5bj6BA8
         d3lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=B82P8bR5ozDn3yo+U/Bu+4ns+QtyTtYccr3OgXM2Xto=;
        b=Lw3Bh87hEgMk47ou2gxDG8Ogf+TrFGIry+Y9paFAm7WbwaJHrj6c80I71FeASY91uv
         7rWTW4K5N9orPGwU7i2l6iyjsQAHByG+UqhNiHB+rb325Xf3U7v77DoaPP5/lnPZ3qcS
         NJOvBycjDCiFHc8U7T1tpBB+hSPAJXcXS03paqHhA3LYN5ZmDRhk/M/zjT7egKxbtvZW
         2AUrsHrMH0cNfqjSUihDM6ql5SpnqfHFhXo+4855ZumekPm+w6YUZQaQprFSjToUTlUY
         B6XueUXc/xvq4Y159E1jwUa7fKvio03Fmw3csRmOTs/gYvF1AvFl6+Hinj1iiLfzuxQa
         fegQ==
X-Gm-Message-State: APjAAAWc+z65g0wr6GLyGnfTO7ES5FOHQF7SjcqGQs2w1XRlgTCCdBWf
	wB67o0we0PwmpR3tjj8O/m0=
X-Google-Smtp-Source: APXvYqzcAeFu0IQPSK1BaoWoskfgcIaIoF3n5FvQ9/vQqw2qowCXX07aaHHNTwtuTQh9RE43OOmpHQ==
X-Received: by 2002:aed:234a:: with SMTP id i10mr10644028qtc.155.1581352591251;
        Mon, 10 Feb 2020 08:36:31 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Mon, 10 Feb 2020 11:36:29 -0500
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 06/11] x86: make sure _etext includes function
 sections
Message-ID: <20200210163627.GA1829035@rani.riverdale.lan>
References: <75f0bd0365857ba4442ee69016b63764a8d2ad68.camel@linux.intel.com>
 <B413445A-F1F0-4FB7-AA9F-C5FF4CEFF5F5@amacapital.net>
 <20200207092423.GC14914@hirez.programming.kicks-ass.net>
 <202002091742.7B1E6BF19@keescook>
 <20200210105117.GE14879@hirez.programming.kicks-ass.net>
 <43b7ba31-6dca-488b-8a0e-72d9fdfd1a6b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <43b7ba31-6dca-488b-8a0e-72d9fdfd1a6b@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Feb 10, 2020 at 07:54:58AM -0800, Arjan van de Ven wrote:
> > 
> > I'll leave it to others to figure out the exact details. But afaict it
> > should be possible to have fine-grained-randomization and preserve the
> > workaround in the end.
> > 
> 
> the most obvious "solution" is to compile with an alignment of 4 bytes (so tight packing)
> and then in the randomizer preserve the offset within 32 bytes, no matter what it is
> 
> that would get you an average padding of 16 bytes which is a bit more than now but not too insane
> (queue Kees' argument that tiny bits of padding are actually good)
> 

With the patchset for adding the mbranches-within-32B-boundaries option,
the section alignment gets forced to 32. With function-sections that
means function alignment has to be 32 too.
