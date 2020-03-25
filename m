Return-Path: <SRS0=cIUU=5K=lists.openwall.com=kernel-hardening-return-18227-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D366C2D0E5
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 20:22:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6CD5020740
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 20:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="M3COaVcI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6CD5020740
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18227-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 12124 invoked by uid 550); 25 Mar 2020 20:22:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 12086 invoked from network); 25 Mar 2020 20:22:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PdpEIpQ/wKeSgsRAafJKurWryJo4Td2Yn8/4nS7DvLI=;
        b=M3COaVcIwpKVfcCr80swHvdh9xXacj7eY2qC2ds0xZUIr0GOt4mzJLwb1ZwbVI9+Bg
         XQEamHqFR+VeDMQ3FRvP7wohJct4eF4Q0yfFFLHyAiNgQdrXUvp5l3OBfu+dUDGlCeG8
         TwUeNQNwBIaBtP7S7OlSpq0LgGwC0BvmnAp9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PdpEIpQ/wKeSgsRAafJKurWryJo4Td2Yn8/4nS7DvLI=;
        b=N7rjSQsWOCYoB3TTkG6+KyQqM4CUi2tjfSH3BiYCsr3l6nIEi1a4JujBWY6L9iuZp0
         yNStha+PXZDtVs7q5IbCkBnjg9OB6MTXSmEuwgZFRIHYiCytsYycB4Vgdr3PtWc/4394
         cImxQE02LbiOH+PUsvDW9bF4+JS9FspSMnNPJ91SO8iv6OB0M6r86wmRznbMxyRMs1MZ
         vK60/67qrCOsLpbq3PPQhXWLroWgr4Cfj7HQdrXk74d2eVNRjpu8gdB/q6/Cg3FCEpxo
         +YXRtt5Ei4aCewU7yNsOWeK5iKnDnoa7DBrqJ2Fkv1b8hDOKEBw8N2Q9qW3lfl5cU6ix
         9Dtw==
X-Gm-Message-State: ANhLgQ1gEYG377a6qGSEMNePaCIccH2NWmmWL4dSCEWePCmwVVUPHTDj
	CKloUhIVKZG6g7N22CTuIPRAMg==
X-Google-Smtp-Source: ADFU+vs+9qXw30Y/gM8gDtnz4iYFAg0dyECDyKOna2Nf6+mD+qup1rem6mTHJ82584OyB/TSrpCOAg==
X-Received: by 2002:a17:902:9889:: with SMTP id s9mr4491897plp.252.1585167729772;
        Wed, 25 Mar 2020 13:22:09 -0700 (PDT)
Date: Wed, 25 Mar 2020 13:22:07 -0700
From: Kees Cook <keescook@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] arm64: entry: Enable random_kstack_offset support
Message-ID: <202003251319.AECA788D63@keescook>
References: <20200324203231.64324-1-keescook@chromium.org>
 <20200324203231.64324-6-keescook@chromium.org>
 <20200325132127.GB12236@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325132127.GB12236@lakrids.cambridge.arm.com>

On Wed, Mar 25, 2020 at 01:21:27PM +0000, Mark Rutland wrote:
> On Tue, Mar 24, 2020 at 01:32:31PM -0700, Kees Cook wrote:
> > Allow for a randomized stack offset on a per-syscall basis, with roughly
> > 5 bits of entropy.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Just to check, do you have an idea of the impact on arm64? Patch 3 had
> figures for x86 where it reads the TSC, and it's unclear to me how
> get_random_int() compares to that.

I didn't do a measurement on arm64 since I don't have a good bare-metal
test environment. I know Andy Lutomirki has plans for making
get_random_get() as fast as possible, so that's why I used it here. I
couldn't figure out if there was a comparable instruction like rdtsc in
aarch64 (it seems there's a cycle counter, but I found nothing in the
kernel that seemed to actually use it)?

> Otherwise, this looks sound to me; I'd jsut like to know whether the
> overhead is in the same ballpark.

Thanks!

-Kees

-- 
Kees Cook
