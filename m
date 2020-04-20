Return-Path: <SRS0=b+4Y=6E=lists.openwall.com=kernel-hardening-return-18581-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B72C54FCC
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 22:35:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9180920857
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Apr 2020 22:35:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="WaKFtBNj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9180920857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18581-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7898 invoked by uid 550); 20 Apr 2020 22:35:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7862 invoked from network); 20 Apr 2020 22:35:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gHx7qgEhMfCeRi4LwRcBINau80f3lsbADPFxDRDnQX8=;
        b=WaKFtBNjxAG6922c9M7PS6Sr9GtIoZi+Bab8wtI8WphnYmTcq8s4ZSzd4luipXOLU4
         jf4QK74nyiAcI85rmEUYpbI/hBAhRHU50KzAVjDVdJlDL1gU+m4RHq55dCtYvfJ4lxlT
         nAFclQvexr0WpO9w144f4pIlUT9r5MqSnjeTI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gHx7qgEhMfCeRi4LwRcBINau80f3lsbADPFxDRDnQX8=;
        b=Jj4VEbvKNbSlp1rxPDMhOGsU/thLs+DN5wpBCl7uBYVvaMfcQJUNgK5cqa/Shlolbe
         OOmOcYo3p66npR41GApCwZTy6TDcgWSUAlvItJXReKa/cZnQ6ZhtHLotphmh1Fx3OJps
         97S+HLaBR3Yh5RBgS8yE/GyTz0IAvyTCbth/iqh3/zmXF1jov9FFPcFwG5o2+mxF0mDg
         dqa4NF1gr3yqnQNAS+6emmpsvDoythyk7KHB6K7USopjjSxWXYeIy1L3A6A3ul/rjOmf
         KP7xriyWrSVbgvaOJbNhO+/Q/h5edl1TZ2UN0Y/tPIxdIGpukfsJKCd/Osiiz0WZpnZO
         gG0g==
X-Gm-Message-State: AGi0Pub2rV7fpLTnarRgFBXuNrS7iJ2GJ3/ydf09/PmIR/GE3HzF3RH/
	7U8a4FlzN3hvM49tJ2wO/mYEzA==
X-Google-Smtp-Source: APiQypKAcbw6yPUzbM4nMMNMJKcG2W4526Isd/VpAs6Bq80MioCbLHvZ9ufOTrlBeRJfVRW8JpiX/g==
X-Received: by 2002:a63:602:: with SMTP id 2mr18621933pgg.383.1587422099130;
        Mon, 20 Apr 2020 15:34:59 -0700 (PDT)
Date: Mon, 20 Apr 2020 15:34:57 -0700
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] arm64: entry: Enable random_kstack_offset support
Message-ID: <202004201529.BB787BB@keescook>
References: <20200324203231.64324-1-keescook@chromium.org>
 <20200324203231.64324-6-keescook@chromium.org>
 <20200420205458.GC29998@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420205458.GC29998@willie-the-truck>

On Mon, Apr 20, 2020 at 09:54:58PM +0100, Will Deacon wrote:
> On Tue, Mar 24, 2020 at 01:32:31PM -0700, Kees Cook wrote:
> > +	/*
> > +	 * Since the compiler chooses a 4 bit alignment for the stack,
> > +	 * let's save one additional bit (9 total), which gets us up
> > +	 * near 5 bits of entropy.
> > +	 */
> > +	choose_random_kstack_offset(get_random_int() & 0x1FF);
> 
> Hmm, this comment doesn't make any sense to me. I mean, I get that 0x1ff
> is 9 bits, and that is 4+5 but so what?

Er, well, yes. I guess I was just trying to explain why there were 9
bits saved here and to document what I was seeing the compiler actually
doing with the values. (And it serves as a comparison to the x86 comment
which is explaining similar calculations in the face of x86_64 vs ia32.)

Would something like this be better?

/*
 * Since the compiler uses 4 bit alignment for the stack (1 more than
 * x86_64), let's try to match the 5ish-bit entropy seen in x86_64,
 * instead of having needlessly lower entropy. As a result, keep the
 * low 9 bits.
 */

-- 
Kees Cook
