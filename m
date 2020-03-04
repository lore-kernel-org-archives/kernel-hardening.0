Return-Path: <SRS0=zMI5=4V=lists.openwall.com=kernel-hardening-return-18059-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F31F8C3F2D1
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Mar 2020 18:22:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 494FC2146E
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Mar 2020 18:22:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EtH+RNLz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 494FC2146E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18059-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29845 invoked by uid 550); 4 Mar 2020 18:22:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29815 invoked from network); 4 Mar 2020 18:22:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xF2I7tf+DwxpQhNciBVkWhhaWOLjPvYzGL3E90sj2so=;
        b=EtH+RNLzhqY+QqYdV6X7ap6Xu3EpSaat18+ckZb/mOfySU0ooqa/9cKD/lI/wgqztb
         ZK2Ma6j1qv5DcakHHIlnNCH8JvP6u0Ga6Lxhnp2OX/arBJTY2+8pgH3SNyBm7i2VIJ2k
         nN0QThNn3RyhAFc+q1sXxzjkc/ZdjOgh2+oOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xF2I7tf+DwxpQhNciBVkWhhaWOLjPvYzGL3E90sj2so=;
        b=BZtfLLgkcXHVa9oawoHqjR4iACComjRcsvTC7LZytzGUk22yaplyjdAvNNESRPEHWb
         aSu2yUQQMxOgVtA/dOHfWhhBR+pFFPNPvDLT++ZR6DB8aJ5gk9ItnLyom69hVdy+dZtB
         XJSp/UUXVai13SE1q16tXwVs4QmnEe5Wus2+akLmmcND6Ucrj4ZQOhZjUQ3SWDa83woP
         7pQ9R0t5hVv7BO5l9NuJj3FaKBLHYR9i1qniTORoRqL/mqgaoJSSKQ2fMymkgQ97q4tC
         00H7iPUkedYcGBxXXCYroAzXU8cPuNEejvDE/YEDjwQGw3WeLawflrkrg9gs42SEWeb9
         l5SQ==
X-Gm-Message-State: ANhLgQ3M8DcEuz41aEqt3UudK0l7XZ3xa1GrO74n8Z7DPfgkbGvnLAuJ
	beUWtbedxrf6nJ6dhNNPUG9xpg==
X-Google-Smtp-Source: ADFU+vuGalFADUNS2CsAir9E+YeLAVnzSZsmifwLoGDru8DbnpAUozLyZDUnqEqdqAQL4AUGpiCQNw==
X-Received: by 2002:a63:ed14:: with SMTP id d20mr3606078pgi.267.1583346110401;
        Wed, 04 Mar 2020 10:21:50 -0800 (PST)
Date: Wed, 4 Mar 2020 10:21:48 -0800
From: Kees Cook <keescook@chromium.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>,
	Thomas Hellstrom <thellstrom@vmware.com>,
	"VMware, Inc." <pv-drivers@vmware.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Jiri Slaby <jslaby@suse.cz>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Cao jin <caoj.fnst@cn.fujitsu.com>,
	Allison Randal <allison@lohutok.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	virtualization@lists.linux-foundation.org,
	Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v11 00/11] x86: PIE support to extend KASLR randomization
Message-ID: <202003041019.C6386B2F7@keescook>
References: <20200228000105.165012-1-thgarnie@chromium.org>
 <202003022100.54CEEE60F@keescook>
 <20200303095514.GA2596@hirez.programming.kicks-ass.net>
 <CAJcbSZH1oON2VC2U8HjfC-6=M-xn5eU+JxHG2575iMpVoheKdA@mail.gmail.com>
 <6e7e4191612460ba96567c16b4171f2d2f91b296.camel@linux.intel.com>
 <202003031314.1AFFC0E@keescook>
 <20200304092136.GI2596@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304092136.GI2596@hirez.programming.kicks-ass.net>

On Wed, Mar 04, 2020 at 10:21:36AM +0100, Peter Zijlstra wrote:
> But at what cost; it does unspeakable ugly to the asm. And didn't a
> kernel compiled with the extended PIE range produce a measurably slower
> kernel due to all the ugly?

Was that true? I thought the final results were a wash and that earlier
benchmarks weren't accurate for some reason? I can't find the thread
now. Thomas, do you have numbers on that?

BTW, I totally agree that fgkaslr is the way to go in the future. I
am mostly arguing for this under the assumption that it doesn't
have meaningful performance impact and that it gains the kernel some
flexibility in the kinds of things it can do in the future. If the former
is not true, then I'd agree, the benefit needs to be more clear.

-- 
Kees Cook
