Return-Path: <SRS0=ZA9m=II=lists.openwall.com=kernel-hardening-return-20921-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A32C433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 23:56:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1E9F864FC5
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Mar 2021 23:56:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E9F864FC5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20921-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15769 invoked by uid 550); 10 Mar 2021 23:56:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15749 invoked from network); 10 Mar 2021 23:56:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1615420564;
	bh=UVXuRCiWw34IqJcMP9Uv9Jas9cv4G39lAIuBiEicriY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=emLhvYekhyBaZ2AfJJbUlNuRJXxCMIRvvMmTGCMfmtu3W4qCwgfn4RGHsYAbmvtml
	 Fupl3RPBbQ9Wx7pIbmVfJT+Tavgxx7GGU17KfvQKSGsA5QPUffBps21tzjTWiNUUnC
	 eA9ut0KtOpOisfHMMlTqywPwMQWyn8dim1tOd3TE=
Date: Wed, 10 Mar 2021 15:56:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org, Elena
 Reshetova <elena.reshetova@intel.com>, x86@kernel.org, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Alexander Potapenko <glider@google.com>, Alexander
 Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Jann Horn <jannh@google.com>, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vlastimil Babka
 <vbabka@suse.cz>, David Hildenbrand <david@redhat.com>, Mike Rapoport
 <rppt@linux.ibm.com>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap
 <rdunlap@infradead.org>
Subject: Re: [PATCH v5 1/7] mm: Restore init_on_* static branch defaults
Message-Id: <20210310155602.e005171dbecbc0be442f8aad@linux-foundation.org>
In-Reply-To: <20210309214301.678739-2-keescook@chromium.org>
References: <20210309214301.678739-1-keescook@chromium.org>
	<20210309214301.678739-2-keescook@chromium.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  9 Mar 2021 13:42:55 -0800 Kees Cook <keescook@chromium.org> wrote:

> Choosing the initial state of static branches changes the assembly layout
> (if the condition is expected to be likely, inline, or unlikely, out of
> line via a jump). The _TRUE/_FALSE defines for CONFIG_INIT_ON_*_DEFAULT_ON
> were accidentally removed. These need to stay so that the CONFIG controls
> the pessimization of the resulting static branch NOP/JMP locations.

Changelog doesn't really explain why anyone would want to apply this
patch.  This is especially important for -stable patches.

IOW, what is the user visible effect of the bug?
