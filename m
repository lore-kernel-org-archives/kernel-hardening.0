Return-Path: <kernel-hardening-return-21558-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 79308C433EF
	for <kernel-hardening@archiver.kernel.org>; Wed, 13 Apr 2022 00:17:21 +0000 (UTC)
Received: (qmail 20288 invoked by uid 550); 13 Apr 2022 00:17:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20256 invoked from network); 13 Apr 2022 00:17:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ra1hyrM7dwc+HV+WV1/rwukQPah2FvcX8EqBZ0W48RQ=;
        b=JPfUYGrDJ9dMferliAZeeTe3JyohCqjUHCUtuGWdlz2D+4eu9s7+2mSoyG/fxPXp8a
         ZMRItjzELwfA31xbYO50TmFSqamawHAYHalHJQe/9Gi9ao/jIsPn0k0WxFLeSDTvBmmg
         Yg6VolMRO4tyILYAAFA4c89HhaoEBBQ7Ke7gI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ra1hyrM7dwc+HV+WV1/rwukQPah2FvcX8EqBZ0W48RQ=;
        b=Oa8isNUnrfFJqbwac9CvPiH0ckZKbjPGtt/nQYM1g7V5tVdVmk2s/ZnIQnB7e27BzU
         jPEcJJ9aW7xPAPkzRIWKLKBb2vqL6YQ1jZchdCM10bu1v5HTq0k7lMM6dfYDXgbrg0J4
         BpiAS0x9n0J2SLGGHz7pM2QzIEubXU7LrRt/GpZ0YfxS86Zd3wdB/JX1LPWLNcrBTmdU
         N/2bDLXu/Ux03ACCNnZAW5Q/IYm3iKdFTdyS6HYPqcxAB3YmHKJc7dKnJlpxphGMMylA
         /tNIXDptnc3lTtqnA7c+GYsIrzipD4uqbVTFolVIoQQuHQD+X0NtPIPwC7i+RSvtg4y3
         NDmg==
X-Gm-Message-State: AOAM530jluE1f7gBBxwjipPWjbk2tv2lPxi5afo38W2i5xURyn3rpYCV
	7cLs47XfVgVJUqQA7zrwj+XYsQ==
X-Google-Smtp-Source: ABdhPJynCJDS+RMZ1E+iWKwEnlqFSP81aNU3xTq4xQBQUu6mRlg8ddPevixz/SWhb1DNXv7jHuHW+A==
X-Received: by 2002:a17:90b:384b:b0:1c7:41fd:9991 with SMTP id nl11-20020a17090b384b00b001c741fd9991mr7849938pjb.199.1649809017140;
        Tue, 12 Apr 2022 17:16:57 -0700 (PDT)
Date: Tue, 12 Apr 2022 17:16:56 -0700
From: Kees Cook <keescook@chromium.org>
To: Peter Gerber <peter@arbtirary.ch>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Kernel Self Protection Project: slub_debug=ZF
Message-ID: <202204121715.11B2CA80@keescook>
References: <6b039403-b46e-e186-63d0-91362dfe18a1@arbtirary.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b039403-b46e-e186-63d0-91362dfe18a1@arbtirary.ch>

On Sun, Apr 10, 2022 at 09:34:17PM +0200, Peter Gerber wrote:
> Hello,
> 
> The Kernel Self Protection Project, on their Recommended Settings [1] page,
> suggests the following:
> 
> # Enable SLUB redzoning and sanity checking (slow; requires
> CONFIG_SLUB_DEBUG=y above).
> slub_debug=ZF
> 
> On recent kernels, I see the following in dmesg when this option is set:
> 
> **********************************************************
> **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> **                                                      **
> ** This system shows unhashed kernel memory addresses   **
> ** via the console, logs, and other interfaces. This    **
> ** might reduce the security of your system.            **
> **                                                      **
> ** If you see this message and you are not debugging    **
> ** the kernel, report this immediately to your system   **
> ** administrator!                                       **
> **                                                      **
> **   NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE NOTICE   **
> **********************************************************
> 
> A bit of digging tells me that this is caused by "slub: force on
> no_hash_pointers when slub_debug is enabled" [2]. Assuming the performance
> impact is acceptable, is this option still recommend? Should there perhaps
> be a way to explicitly disable no_hash_pointers (e.g. via
> no_hash_pointers=off)?

Eww, that's not good at all. Would you be willing to write a patch to
decouple this again?

I think the primary issue is that these "debug" modes aren't exclusively
used for debugging, and exposing the unhashed pointer is directly in
conflict with the non-debug use case. :P

-Kees

> 
> Regards,
> 
> Peter
> 
> [1]: https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings
> [2]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=792702911f581f7793962fbeb99d5c3a1b28f4c3

-- 
Kees Cook
