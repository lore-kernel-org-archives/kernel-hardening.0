Return-Path: <SRS0=6G0X=32=lists.openwall.com=kernel-hardening-return-17721-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE36C33CAC
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 17:43:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C086020659
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 17:43:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C086020659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17721-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11899 invoked by uid 550); 6 Feb 2020 17:43:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11879 invoked from network); 6 Feb 2020 17:43:33 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="379136126"
Message-ID: <a5ef8954d7f9148f0909ae8a94f66f2ae72ed08d.camel@linux.intel.com>
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, tglx@linutronix.de, mingo@redhat.com,
  bp@alien8.de, hpa@zytor.com, arjan@linux.intel.com,
 rick.p.edgecombe@intel.com,  x86@kernel.org, linux-kernel@vger.kernel.org, 
 kernel-hardening@lists.openwall.com
Date: Thu, 06 Feb 2020 09:43:21 -0800
In-Reply-To: <20200206173538.GY14914@hirez.programming.kicks-ass.net>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
	 <20200205223950.1212394-9-kristen@linux.intel.com>
	 <20200206103830.GW14879@hirez.programming.kicks-ass.net>
	 <202002060356.BDFEEEFB6C@keescook>
	 <20200206145253.GT14914@hirez.programming.kicks-ass.net>
	 <9f337efdf226e51e3f5699243623e5de7505ac94.camel@linux.intel.com>
	 <20200206173538.GY14914@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2020-02-06 at 18:35 +0100, Peter Zijlstra wrote:
> On Thu, Feb 06, 2020 at 09:25:01AM -0800, Kristen Carlson Accardi
> wrote:
> 
> > That's right - all of these tables that you mention had relocs and
> > thus
> > I did not have to do anything special for them. The orc_unwind_ip
> > tables get sorted during unwind_init(). 
> 
> No they're not:
> 
>   f14bf6a350df ("x86/unwind/orc: Remove boot-time ORC unwind tables
> sorting")
> 
> Or rather, it might be you're working on an old tree.

Doh! Ok, I can make a patch to add it back based on CONFIG_FG_KASLR, or
just do yet another resort at boot time.


