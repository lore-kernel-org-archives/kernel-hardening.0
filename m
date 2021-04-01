Return-Path: <SRS0=DuhZ=I6=lists.openwall.com=kernel-hardening-return-21112-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2585C433ED
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 08:38:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BBE2160190
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Apr 2021 08:38:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBE2160190
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21112-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6083 invoked by uid 550); 1 Apr 2021 08:38:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6061 invoked from network); 1 Apr 2021 08:38:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1617266286;
	bh=pL7zEm/CJ6Uq13TbvMopTgicNXFZzItUs41gFNFs0bo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A3X3lduCFkIuAeuQcqpzhul7wvKwDj5UjZ40gX0BhH6coMkam04N1fMhBXiO1k9fr
	 Qx/8Cp+zmkSw5yt/9WD3OWEBwEdVVUiTgmrKXPktPG5MJhpkzp1IqJLPCbqq2ePs32
	 NzwqEkscV/FJQFSYJe0Z+pA7s1+1j2kz8cRLj9B2ZGRPbxRir0oMbkz4NORBnn08Qw
	 zpEovn8ARnysgKDkNQpa5nWT4UqQLnGUIgZL92lSn8A0CTU6eFdvu51VF/lz3gas5G
	 NbEBSMnsjL1na3BP/51tBCx3wTgdCqXYFtiXlE20KJqh/YGMRt2tzdaxvdOsy5SBYF
	 Da/Tpgqva8b+A==
Date: Thu, 1 Apr 2021 09:37:59 +0100
From: Will Deacon <will@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 0/6] Optionally randomize kernel stack offset each
 syscall
Message-ID: <20210401083758.GA8745@willie-the-truck>
References: <20210331205458.1871746-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331205458.1871746-1-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Kees,

On Wed, Mar 31, 2021 at 01:54:52PM -0700, Kees Cook wrote:
> Hi Will (and Mark and Catalin),
> 
> Can you take this via the arm64 tree for v5.13 please? Thomas has added
> his Reviewed-by, so it only leaves arm64's. :)

Sorry, these got mixed up in my inbox so I just replied to v7 and v8 and
then noticed v9. Argh!

However, I think the comments still apply: namely that the dummy "=m" looks
dangerous to me and I think you're accessing pcpu variables with preemption
enabled for the arm64 part:

https://lore.kernel.org/r/20210401083034.GA8554@willie-the-truck
https://lore.kernel.org/r/20210401083430.GB8554@willie-the-truck

Will
