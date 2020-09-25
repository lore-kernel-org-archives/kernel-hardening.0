Return-Path: <SRS0=djQL=DC=lists.openwall.com=kernel-hardening-return-20009-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12423C4363D
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Sep 2020 13:07:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EDD5A22B2D
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Sep 2020 13:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDD5A22B2D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20009-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26302 invoked by uid 550); 25 Sep 2020 13:07:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26279 invoked from network); 25 Sep 2020 13:07:13 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Date: Fri, 25 Sep 2020 15:06:55 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
cc: keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org, 
    kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com, 
    live-patching@vger.kernel.org
Subject: Re: [PATCH v5 00/10] Function Granular KASLR
In-Reply-To: <20200923173905.11219-1-kristen@linux.intel.com>
Message-ID: <alpine.LSU.2.21.2009251450260.13615@pobox.suse.cz>
References: <20200923173905.11219-1-kristen@linux.intel.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Kristen,

On Wed, 23 Sep 2020, Kristen Carlson Accardi wrote:

> Function Granular Kernel Address Space Layout Randomization (fgkaslr)
> ---------------------------------------------------------------------
> 
> This patch set is an implementation of finer grained kernel address space
> randomization. It rearranges your kernel code at load time 
> on a per-function level granularity, with only around a second added to
> boot time.

I ran live patching kernel selftests on the patch set and everything 
passed fine.

However, we also use not-yet-upstream set of tests at SUSE for testing 
live patching [1] and one of them, klp_tc_12.sh, is failing. You should be 
able to run the set on upstream as is.

The test uninterruptedly sleeps in a kretprobed function called by a 
patched one. The current master without fgkaslr patch set reports the 
stack of the sleeping task as unreliable and live patching fails. The 
situation is different with fgkaslr (even with nofgkaslr on the command 
line). The stack is returned as reliable. It looks something like 

[<0>] __schedule+0x465/0xa40
[<0>] schedule+0x55/0xd0
[<0>] orig_do_sleep+0xb1/0x110 [klp_test_support_mod]
[<0>] swap_pages+0x7f/0x7f

where the last entry is not reliable. I've seen 
kretprobe_trampoline+0x0/0x4a and some other symbols there too. Since the 
patched function (orig_sleep_uninterruptible_set) is not on the stack, 
live patching succeeds, which is not intended.

With kprobe setting removed, all works as expected.

So I wonder if there is still some issue with ORC somewhere as you 
mentioned in v4 thread. I'll investigate more next week, but wanted to 
report early.

Regards
Miroslav

[1] https://github.com/lpechacek/qa_test_klp
