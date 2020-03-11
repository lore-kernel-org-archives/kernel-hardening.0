Return-Path: <SRS0=2l6O=44=lists.openwall.com=kernel-hardening-return-18125-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1025C0044D
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Mar 2020 18:47:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2FBE020736
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Mar 2020 18:47:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UQ4e2oDI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FBE020736
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18125-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25707 invoked by uid 550); 11 Mar 2020 18:47:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25685 invoked from network); 11 Mar 2020 18:47:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DPFOjS65aX83dVrMyWpNcqxjpN5VgGgj9i7MicV1YwI=;
        b=UQ4e2oDI5aWe4clgsCfMJn2WuqSNV6MSzIXKTA/MELu5S35/wFnW+P2AKgc2Nb8p5F
         a2eEhF7s8OZB9Xp5XOA90hgpheqmMYDAXt/OqRTdUIbi3rbHC9YcB726dO3vpa/sXh13
         ax8fSrNwK3SN+sYW4HuU0cRGr8nNcAbHgK5eU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DPFOjS65aX83dVrMyWpNcqxjpN5VgGgj9i7MicV1YwI=;
        b=r5pNrw1qICszOIA/DLmSouFeUior5eISGPKAJ5r1VjHs44XR4XUotqD79MfI2nmYE1
         TEeR3GAc/W/B0SZS/geaW47Rdp+tMTwkzXPwUoIgDkuuJWYhGPG4wGmPdggmTpb5L7jb
         pMDmZ6FUe8KHLx8utAzf9xTc5RpR9CQ3t/jGtX1ym2/i6/lvD7xU+p+zvsclOzYfiai+
         G1QjHQeISX7KyPLHwWtNyZyxBJ0mc3mYGxO+Vk9V5S7dfHUBhHiepx2Sml2AxHFBhHa7
         erMjUv7f6Weiilej+EA8xf2WUxtPoNKtQEP2i/x0TTzqyR4y94hMIgwsrIlQ1Gv2ENoZ
         YT6w==
X-Gm-Message-State: ANhLgQ3q5QzKz5PgngHZNIl7OkQz0tWtKGS3u0JLk+P4V0qHMPo/yp6I
	RXzSKhTBpD38rhvzyfH+b68xhA==
X-Google-Smtp-Source: ADFU+vuXIizjdYkDBMb7S0jL33R8WS1F2EGioRvewyWf29WjT0E9VAqV9sIyR+/A6GtPH+xZPd9U8A==
X-Received: by 2002:a62:1d1:: with SMTP id 200mr4318121pfb.8.1583952441770;
        Wed, 11 Mar 2020 11:47:21 -0700 (PDT)
Date: Wed, 11 Mar 2020 11:47:20 -0700
From: Kees Cook <keescook@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@armlinux.org.uk, Emese Revfy <re.emese@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Laura Abbott <labbott@redhat.com>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v3] ARM: smp: add support for per-task stack canaries
Message-ID: <202003111146.E3FC1924@keescook>
References: <20181206083257.9596-1-ard.biesheuvel@linaro.org>
 <20200309164931.GA23889@roeck-us.net>
 <202003111020.D543B4332@keescook>
 <04a8c31a-3c43-3dcf-c9fd-82ba225a19f6@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04a8c31a-3c43-3dcf-c9fd-82ba225a19f6@roeck-us.net>

On Wed, Mar 11, 2020 at 11:31:13AM -0700, Guenter Roeck wrote:
> On 3/11/20 10:21 AM, Kees Cook wrote:
> > On Mon, Mar 09, 2020 at 09:49:31AM -0700, Guenter Roeck wrote:
> >> On Thu, Dec 06, 2018 at 09:32:57AM +0100, Ard Biesheuvel wrote:
> >>> On ARM, we currently only change the value of the stack canary when
> >>> switching tasks if the kernel was built for UP. On SMP kernels, this
> >>> is impossible since the stack canary value is obtained via a global
> >>> symbol reference, which means
> >>> a) all running tasks on all CPUs must use the same value
> >>> b) we can only modify the value when no kernel stack frames are live
> >>>    on any CPU, which is effectively never.
> >>>
> >>> So instead, use a GCC plugin to add a RTL pass that replaces each
> >>> reference to the address of the __stack_chk_guard symbol with an
> >>> expression that produces the address of the 'stack_canary' field
> >>> that is added to struct thread_info. This way, each task will use
> >>> its own randomized value.
> >>>
> >>> Cc: Russell King <linux@armlinux.org.uk>
> >>> Cc: Kees Cook <keescook@chromium.org>
> >>> Cc: Emese Revfy <re.emese@gmail.com>
> >>> Cc: Arnd Bergmann <arnd@arndb.de>
> >>> Cc: Laura Abbott <labbott@redhat.com>
> >>> Cc: kernel-hardening@lists.openwall.com
> >>> Acked-by: Nicolas Pitre <nico@linaro.org>
> >>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >>
> >> Since this patch is in the tree, cc-option no longer works on
> >> the arm architecture if CONFIG_STACKPROTECTOR_PER_TASK is enabled.
> >>
> >> Any idea how to fix that ? 
> > 
> > I thought Arnd sent a patch to fix it and it got picked up?
> > 
> 
> Yes, but the fix is not upstream (it is only in -next), and I missed it.

Ah, yes, I found it again now too; it went through rmk's tree.

For thread posterity:

ARM: 8961/2: Fix Kbuild issue caused by per-task stack protector GCC plugin
https://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=8961/2

-- 
Kees Cook
