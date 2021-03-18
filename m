Return-Path: <SRS0=VcVi=IQ=lists.openwall.com=kernel-hardening-return-20981-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C7E2C433DB
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Mar 2021 12:47:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4ED9164F04
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Mar 2021 12:47:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4ED9164F04
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20981-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17514 invoked by uid 550); 18 Mar 2021 12:46:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17494 invoked from network); 18 Mar 2021 12:46:56 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Subject: Re: [PATCH v6 2/6] init_on_alloc: Optimize static branches
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Alexander Potapenko <glider@google.com>,
 Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Alexander Popov <alex.popov@linux.com>,
 Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jann Horn <jannh@google.com>,
 David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Randy Dunlap <rdunlap@infradead.org>, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20210315180229.1224655-1-keescook@chromium.org>
 <20210315180229.1224655-3-keescook@chromium.org>
From: Vlastimil Babka <vbabka@suse.cz>
Message-ID: <5d626b9b-5355-be94-e8e2-1be47f880f30@suse.cz>
Date: Thu, 18 Mar 2021 13:46:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210315180229.1224655-3-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 3/15/21 7:02 PM, Kees Cook wrote:
> The state of CONFIG_INIT_ON_ALLOC_DEFAULT_ON (and ...ON_FREE...) did not
> change the assembly ordering of the static branches: they were always out
> of line. Use the new jump_label macros to check the CONFIG settings to
> default to the "expected" state, which slightly optimizes the resulting
> assembly code.
> 
> Reviewed-by: Alexander Potapenko <glider@google.com>
> Link: https://lore.kernel.org/lkml/CAG_fn=X0DVwqLaHJTO6Jw7TGcMSm77GKHinrd0m_6y0SzWOrFA@mail.gmail.com/
> Signed-off-by: Kees Cook <keescook@chromium.org>

For the fixed version

Acked-by: Vlastimil Babka <vbabka@suse.cz>
