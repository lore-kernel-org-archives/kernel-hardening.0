Return-Path: <SRS0=+yv9=7D=lists.openwall.com=kernel-hardening-return-18853-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECAAC433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 22:27:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5B551206F6
	for <kernel-hardening@archiver.kernel.org>; Thu, 21 May 2020 22:27:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B551206F6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linutronix.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18853-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9685 invoked by uid 550); 21 May 2020 22:26:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9664 invoked from network); 21 May 2020 22:26:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Kristen Carlson Accardi <kristen@linux.intel.com>, keescook@chromium.org, mingo@redhat.com, bp@alien8.de
Cc: arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com, Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: Re: [PATCH v2 0/9] Function Granular KASLR
In-Reply-To: <20200521165641.15940-1-kristen@linux.intel.com>
References: <20200521165641.15940-1-kristen@linux.intel.com>
Date: Fri, 22 May 2020 00:26:30 +0200
Message-ID: <87367sudpl.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001

Kristen,

Kristen Carlson Accardi <kristen@linux.intel.com> writes:

sorry for not following this work and a maybe stupid question.

> Proposed Improvement
> --------------------
> This patch set proposes adding function reordering on top of the existing
> KASLR base address randomization. The over-arching objective is incremental
> improvement over what we already have. It is designed to work in combination
> with the existing solution. The implementation is really pretty simple, and
> there are 2 main area where changes occur:
>
> * Build time
>
> GCC has had an option to place functions into individual .text sections for
> many years now. This option can be used to implement function reordering at
> load time. The final compiled vmlinux retains all the section headers, which
> can be used to help find the address ranges of each function. Using this
> information and an expanded table of relocation addresses, individual text
> sections can be suffled immediately after decompression. Some data tables
> inside the kernel that have assumptions about order require re-sorting
> after being updated when applying relocations. In order to modify these tables,
> a few key symbols are excluded from the objcopy symbol stripping process for
> use after shuffling the text segments.

I understand how this is supposed to work, but I fail to find an
explanation how all of this is preserving the text subsections we have,
i.e. .kprobes.text, .entry.text ...?

I assume that the functions in these subsections are reshuffled within
their own randomized address space so that __xxx_text_start and
__xxx_text_end markers still make sense, right?

I'm surely too tired to figure it out from the patches, but you really
want to explain that very detailed for mere mortals who are not deep
into this magic as you are.

Thanks,

        tglx
