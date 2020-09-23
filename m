Return-Path: <SRS0=3+Zz=DA=lists.openwall.com=kernel-hardening-return-19992-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14DE0C2D0A8
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 19:52:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CDFAA2193E
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 19:52:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YDuXTVEP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDFAA2193E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19992-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19788 invoked by uid 550); 23 Sep 2020 19:52:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19763 invoked from network); 23 Sep 2020 19:52:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K/pUtqEAd6FaTDCf00ujMgUqqETSXfPhUeGuKchWXUs=;
        b=YDuXTVEPUbAJafRqh/dypmyCmOtqDZ2dqQKZplay/eHegdSKIEI9B7GFZydCeewdM1
         F4y82sJPZZrXoXdu89i+v9LgMLfLO5dWf9qfjvTSJyJaARNyPQcUnI/xdfnZWaIeip+4
         IuGNV9+2rBKAd87bd/oKTVle2Y16/7RrJZgWLHmEvSY4vKB5y+il7B34hPUS0X/6OpZd
         gOmpExT9thdKpwF+eJKIOgmu/jncp8hF7T//iMWu+dOFW7m+WSZH5yMLDv/wBjTEAMW1
         XU3qN/29UsHna8AFr4iVe8VMhv03zG+KI/2MhWWWHNBqTHY70yRtXnOJOsK722s1fruS
         +O3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=K/pUtqEAd6FaTDCf00ujMgUqqETSXfPhUeGuKchWXUs=;
        b=CMU3lMS0QRqIgwBLETGt7ByUEpCctrf79rsGzsA//GuximPJVKQtKwy3R2IZu/La74
         iQY8RPRtAuuIq4mMdKP3VOiEO97KdYIIXIU8L0rIbDUpFyr/mAwidmSPJrzLXTEbG8T2
         fnNTUpC6Yx/YanUqST9AMXqjXP4nuH+Sh7GjN6ydB3SX3HJUg/WGNbdUL5WffMBYdcgf
         Rxj48+Bs9iJoquzgoCdKLeU3A3gFgZDPsIfYGaM8HzKcIGsl10k+KPfAHu3jsBjeqBSS
         HDpss7PoOVqaWMICZthcCNOiwoKJpHz5VsfDm8zkMJUH4FNPAYQj0l79BDmoIsbrH+Oj
         Uyzg==
X-Gm-Message-State: AOAM530dm9syeTxuTki6AzCcp0jqJu4obGavvaDjv1OTGYee50Vd5bW6
	+ZQLjmpZK5lv4F+HnUniAK8=
X-Google-Smtp-Source: ABdhPJzjUTxogU34ItSMJ0OdmM63Q03/ic99kwSF7ETgPXeMzfaQhO5sAjfKzolXALvtzOWcxGlwDw==
X-Received: by 2002:ac8:5d43:: with SMTP id g3mr1813055qtx.295.1600890710351;
        Wed, 23 Sep 2020 12:51:50 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Wed, 23 Sep 2020 15:51:47 -0400
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Arvind Sankar <nivedita@alum.mit.edu>,
	Florian Weimer <fw@deneb.enyo.de>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org, libffi-discuss@sourceware.org, luto@kernel.org,
	David.Laight@ACULAB.COM, mark.rutland@arm.com, mic@digikod.net,
	pavel@ucw.cz
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200923195147.GA1358246@rani.riverdale.lan>
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
 <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
 <20200923014616.GA1216401@rani.riverdale.lan>
 <20200923091125.GB1240819@rani.riverdale.lan>
 <a742b9cd-4ffb-60e0-63b8-894800009700@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a742b9cd-4ffb-60e0-63b8-894800009700@linux.microsoft.com>

On Wed, Sep 23, 2020 at 02:17:30PM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> On 9/23/20 4:11 AM, Arvind Sankar wrote:
> > For libffi, I think the proposed standard trampoline won't actually
> > work, because not all ABIs have two scratch registers available to use
> > as code_reg and data_reg. Eg i386 fastcall only has one, and register
> > has zero scratch registers. I believe 32-bit ARM only has one scratch
> > register as well.
> 
> The trampoline is invoked as a function call in the libffi case. Any
> caller saved register can be used as code_reg, can it not? And the
> scratch register is needed only to jump to the code. After that, it
> can be reused for any other purpose.
> 
> However, for ARM, you are quite correct. There is only one scratch
> register. This means that I have to provide two types of trampolines:
> 
> 	- If an architecture has enough scratch registers, use the currently
> 	  defined trampoline.
> 
> 	- If the architecture has only one scratch register, but has PC-relative
> 	  data references, then embed the code address at the bottom of the
> 	  trampoline and access it using PC-relative addressing.
> 
> Thanks for pointing this out.
> 
> Madhavan

libffi is trying to provide closures with non-standard ABIs as well: the
actual user function is standard ABI, but the closure can be called with
a different ABI. If the closure was created with FFI_REGISTER abi, there
are no registers available for the trampoline to use: EAX, EDX and ECX
contain the first three arguments of the function, and every other
register is callee-save.

I provided a sample of the kind of trampoline that would be needed in
this case -- it's position-independent and doesn't clobber any registers
at all, and you get 255 trampolines per page. If I take another 16-byte
slot out of the page for the end trampoline that does the actual work,
I'm sure I could even come up with one that can just call a normal C
function, only the return might need special handling depending on the
return type.

And again, do you actually have any example of an architecture that
cannot run position-independent code? PC-relative addressing is an
implementation detail: the fact that it's available for x86_64 but not
for i386 just makes position-independent code more cumbersome on i386,
but it doesn't make it impossible. For the tiny trampolines here, it
makes almost no difference.
