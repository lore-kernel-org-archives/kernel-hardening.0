Return-Path: <SRS0=N2T4=7W=lists.openwall.com=kernel-hardening-return-18940-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A91C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 18:47:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 32BCA20734
	for <kernel-hardening@archiver.kernel.org>; Tue,  9 Jun 2020 18:47:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="U99j7Jwk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32BCA20734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18940-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15551 invoked by uid 550); 9 Jun 2020 18:46:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15529 invoked from network); 9 Jun 2020 18:46:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7dtLX6XP7HnlQbHJsaggWu4QmeqwjrddfqDvUbVDx4s=;
        b=U99j7JwkXu9xDjTaNwOqMNsfY/1JGbl0JiVGPVKaBXgK5sILh3SCCo6eu1pc4epTXg
         OFJZw9ln4TBPmUC0pW0XxrKMH3JsdoIHM3vcI+UatnP+BjixVR5jhLwwCKfajn4CK89/
         LsKyztUzZULA3YetUMhR5C2itWjI8K5031e9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7dtLX6XP7HnlQbHJsaggWu4QmeqwjrddfqDvUbVDx4s=;
        b=blBkz70kgJKAn1Wl456e+urcQdtUG0YW2zeNMdilonpadp7FCqfpqSKuere38BbpVa
         DJSn5GuX3nVzmXaAmU1gUepcfA1oOly9EpjvHAYvPsw6ecFeFgD90kGvY3Hv6aJ0JDDq
         Ap6G7jDt+3RcD/+P+wQ0+w5ekfThzbDo7IHBCFtpFbCxl50a+KzMODeUrboj0bhwDaHh
         dzTptaXQJAuAMk8D+ELBh4iabZvoMlL3jI34aEETbgC98UNVzFov+SHuG9qCaf2Dh0i+
         KNltsAZSmsuHjizrEqaT7z5AWSbp/m+7MKUCDcYbqngj7/i4Vc6kcia/bHK/G9VV096I
         cUig==
X-Gm-Message-State: AOAM531VlPd+48G02Gt7hc0Uqc0yutQ8gmH+W1pkmTj3hJ5XtryMhTlf
	P/59/B9atjrKkHJul465Ad6pmg==
X-Google-Smtp-Source: ABdhPJwL5HN0U2KSWusdzlMqd2urfWL8t6YS0AxExIzAB1X6VceO1GflzGC9ecX1Ma+jdmYtMYrhFQ==
X-Received: by 2002:a17:90a:3489:: with SMTP id p9mr6357379pjb.56.1591728402460;
        Tue, 09 Jun 2020 11:46:42 -0700 (PDT)
Date: Tue, 9 Jun 2020 11:46:40 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: Emese Revfy <re.emese@gmail.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Thiago Jung Bauermann <bauerman@linux.ibm.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>,
	Sven Schnelle <svens@stackframe.org>,
	Iurii Zaikin <yzaikin@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Collingbourne <pcc@google.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Alexander Monakov <amonakov@ispras.ru>,
	Mathias Krause <minipli@googlemail.com>,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>,
	Laura Abbott <labbott@redhat.com>,
	Florian Weimer <fweimer@redhat.com>,
	kernel-hardening@lists.openwall.com, linux-kbuild@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, gcc@gcc.gnu.org, notify@kernel.org
Subject: Re: [PATCH 2/5] gcc-plugins/stackleak: Use asm instrumentation to
 avoid useless register saving
Message-ID: <202006091143.AD1A662@keescook>
References: <20200604134957.505389-1-alex.popov@linux.com>
 <20200604134957.505389-3-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604134957.505389-3-alex.popov@linux.com>

On Thu, Jun 04, 2020 at 04:49:54PM +0300, Alexander Popov wrote:
> Let's improve the instrumentation to avoid this:
> 
> 1. Make stackleak_track_stack() save all register that it works with.
> Use no_caller_saved_registers attribute for that function. This attribute
> is available for x86_64 and i386 starting from gcc-7.
> 
> 2. Insert calling stackleak_track_stack() in asm:
>   asm volatile("call stackleak_track_stack" :: "r" (current_stack_pointer))
> Here we use ASM_CALL_CONSTRAINT trick from arch/x86/include/asm/asm.h.
> The input constraint is taken into account during gcc shrink-wrapping
> optimization. It is needed to be sure that stackleak_track_stack() call is
> inserted after the prologue of the containing function, when the stack
> frame is prepared.

Very cool; nice work!

> +static void add_stack_tracking(gimple_stmt_iterator *gsi)
> +{
> +	/*
> +	 * The 'no_caller_saved_registers' attribute is used for
> +	 * stackleak_track_stack(). If the compiler supports this attribute for
> +	 * the target arch, we can add calling stackleak_track_stack() in asm.
> +	 * That improves performance: we avoid useless operations with the
> +	 * caller-saved registers in the functions from which we will remove
> +	 * stackleak_track_stack() call during the stackleak_cleanup pass.
> +	 */
> +	if (lookup_attribute_spec(get_identifier("no_caller_saved_registers")))
> +		add_stack_tracking_gasm(gsi);
> +	else
> +		add_stack_tracking_gcall(gsi);
> +}

The build_for_x86 flag is only ever used as an assert() test against
no_caller_saved_registers, but we're able to test for that separately.
Why does the architecture need to be tested? (i.e. when this flag
becomes supported o other architectures, why must it still be x86-only?)

-- 
Kees Cook
