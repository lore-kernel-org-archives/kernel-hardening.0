Return-Path: <SRS0=c52R=4V=lists.openwall.com=kernel-hardening-return-18060-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712DFC3F2CE
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Mar 2020 18:46:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C53D320870
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Mar 2020 18:46:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="KvnKCUYq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C53D320870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zytor.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18060-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12272 invoked by uid 550); 4 Mar 2020 18:46:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12249 invoked from network); 4 Mar 2020 18:46:01 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 024IivPG430134
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2020022001; t=1583347500;
	bh=QUlRbhYXKi9CdoMv3oDgidaagtZkvk5Xf61FHG+n0Uw=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=KvnKCUYqLiZUp2UObBU/tThRYE5Pcbpbj9OH7MRc6EhVU+JkTmvljzcf9g3Iq0bUo
	 9V/tj2EXxvJiUXm7HH1prOmM37wqwJoIIdDzX831hmKb+hmUXMnLz6huKUq6lctiao
	 9yVGb1BWiEcKMdHr7tY+bxx1phc/XYIDy/FPIaZRucMI0ALoh4PforyLWc2i46g4LF
	 9jvPpeb6Wt8rrT/rjPRpA9yATnlktqf18q7Ch9gkjeys788Oa08dWH+Jl0E1vAvCtE
	 7A/rPHzQ/zlvdtJoTGxn717oTmGTxwdSf+uw1OjF/a1K8De68Woo5pz7m6tpEgXSaS
	 wvrehHjq8HzNA==
Subject: Re: [PATCH v11 00/11] x86: PIE support to extend KASLR randomization
To: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
        Thomas Garnier <thgarnie@chromium.org>,
        Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andy Lutomirski
 <luto@kernel.org>, Juergen Gross <jgross@suse.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "Rafael J. Wysocki"
 <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Will Deacon
 <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Cao jin <caoj.fnst@cn.fujitsu.com>,
        Allison Randal <allison@lohutok.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
 <202003022100.54CEEE60F@keescook>
 <20200303095514.GA2596@hirez.programming.kicks-ass.net>
 <CAJcbSZH1oON2VC2U8HjfC-6=M-xn5eU+JxHG2575iMpVoheKdA@mail.gmail.com>
 <6e7e4191612460ba96567c16b4171f2d2f91b296.camel@linux.intel.com>
 <202003031314.1AFFC0E@keescook>
 <20200304092136.GI2596@hirez.programming.kicks-ass.net>
 <202003041019.C6386B2F7@keescook>
From: "H. Peter Anvin" <hpa@zytor.com>
Message-ID: <e60876d0-4f7d-9523-bcec-6d002f717623@zytor.com>
Date: Wed, 4 Mar 2020 10:44:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202003041019.C6386B2F7@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2020-03-04 10:21, Kees Cook wrote:
> On Wed, Mar 04, 2020 at 10:21:36AM +0100, Peter Zijlstra wrote:
>> But at what cost; it does unspeakable ugly to the asm. And didn't a
>> kernel compiled with the extended PIE range produce a measurably slower
>> kernel due to all the ugly?
> 
> Was that true? I thought the final results were a wash and that earlier
> benchmarks weren't accurate for some reason? I can't find the thread
> now. Thomas, do you have numbers on that?
> 
> BTW, I totally agree that fgkaslr is the way to go in the future. I
> am mostly arguing for this under the assumption that it doesn't
> have meaningful performance impact and that it gains the kernel some
> flexibility in the kinds of things it can do in the future. If the former
> is not true, then I'd agree, the benefit needs to be more clear.
> 

"Making the assembly really ugly" by itself is a reason not to do it, in my
Not So Humble Opinion[TM]; but the reason the kernel and small memory models
exist in the first place is because there is a nonzero performance impact of
the small-PIC memory model. Having modules in separate regions would further
add the cost of a GOT references all over the place (PLT is optional, useless
and deprecated for eager binding) *plus* might introduce at least one new
vector of attack: overwrite a random GOT slot, and just wait until it gets hit
by whatever code path it happens to be in; the exact code path doesn't matter.
From an kASLR perspective this is *very* bad, since you only need to guess the
general region of a GOT rather than an exact address.

The huge memory model, required for arbitrary placement, has a very
significant performance impact.

The assembly code is *very* different across memory models.

	-hpa
