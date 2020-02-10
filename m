Return-Path: <SRS0=R3Ke=36=lists.openwall.com=kernel-hardening-return-17732-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02617C2BA83
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 01:44:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 53C5620838
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 01:44:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="OWDasQsz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 53C5620838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17732-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3272 invoked by uid 550); 10 Feb 2020 01:43:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3249 invoked from network); 10 Feb 2020 01:43:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=HdwoUvKACAu13YTpgkcA2GYzOLF4EXKUPzTpSp3Y354=;
        b=OWDasQsz0mzVFR9NAt3/dyP6IIx6MvuQQk/PMLMcNc5J5Q2l/ZX9JlPy3ONAjfV1M+
         sEuBiVbCoGOeWqeDw32+6/YQUu6fznqbJ8ZexyTCMHECPY64+PRjoV1PwfDHfxiuqPig
         m2wz/WYPPexf1OuqvnAwKlwoUCD3O0DULryKA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HdwoUvKACAu13YTpgkcA2GYzOLF4EXKUPzTpSp3Y354=;
        b=ZqL8t/rvvM34wcZ4oi4n6dAUl0W9d4lXtBlfR9nUmxdpouwJDSI7UOYfqr2iL+a6t7
         sm22mxEP85xTohW1S/yo8BMseZY4yDjzyC5sLL4BgJCDYXd5/WLAecQH5w/olGpWN9Xa
         iwpEzeVRqmgw/GR/In6TaHyCCxp5u58clQgCnYpdYsMgenxpVqiRq51Z8jBeRxG6gEVk
         agYsRcuObpeKCH0XgtXPWoPums6Dh0dEGDgS56k4PQ0TB0W23n+PDGcJz/mYLTR4ucsd
         2GKVD9fPGUXFm0pppc9t+BeDCKSEwQxRgBrwhNUfdhyO+rV0ANoochJ/w6b/zfWBpTvs
         AMSA==
X-Gm-Message-State: APjAAAX0bWjUW3QQexxwW9kwX7iX+OseYJUzw/RwBWSlpnCas+eyUFJ4
	JP0U/z2SN/dSoj8WYvzZrLUO9Q==
X-Google-Smtp-Source: APXvYqxJIiGcpGRtLkseu5csk6qVTgBaW3SqsXIHMJ1sQpVYEgldsMB1fM/RGLKTb04sdm8bPtwUSQ==
X-Received: by 2002:a9d:7a89:: with SMTP id l9mr6809190otn.228.1581299023111;
        Sun, 09 Feb 2020 17:43:43 -0800 (PST)
Date: Sun, 9 Feb 2020 17:43:40 -0800
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 06/11] x86: make sure _etext includes function
 sections
Message-ID: <202002091742.7B1E6BF19@keescook>
References: <75f0bd0365857ba4442ee69016b63764a8d2ad68.camel@linux.intel.com>
 <B413445A-F1F0-4FB7-AA9F-C5FF4CEFF5F5@amacapital.net>
 <20200207092423.GC14914@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200207092423.GC14914@hirez.programming.kicks-ass.net>

On Fri, Feb 07, 2020 at 10:24:23AM +0100, Peter Zijlstra wrote:
> On Thu, Feb 06, 2020 at 12:02:36PM -0800, Andy Lutomirski wrote:
> > Also, in the shiny new era of
> > Intel-CPUs-can’t-handle-Jcc-spanning-a-cacheline, function alignment
> > may actually matter.
> 
> *groan*, indeed. I just went and looked that up. I missed this one in
> all the other fuss :/
> 
> So per:
> 
>   https://www.intel.com/content/dam/support/us/en/documents/processors/mitigations-jump-conditional-code-erratum.pdf
> 
> the toolchain mitigations only work if the offset in the ifetch window
> (32 bytes) is preserved. Which seems to suggest we ought to align all
> functions to 32byte before randomizing it, otherwise we're almost
> guaranteed to change this offset by the act of randomizing.

Wheee! This sounds like in needs to be fixed generally, yes? (And I see
"FUNCTION_ALIGN" macro is currently 16 bytes...

-- 
Kees Cook
