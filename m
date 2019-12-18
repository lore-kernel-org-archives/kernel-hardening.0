Return-Path: <SRS0=1/6i=2I=lists.openwall.com=kernel-hardening-return-17506-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D57A2C43603
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Dec 2019 00:08:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 33BB0218AC
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Dec 2019 00:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IHzJ0A0S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33BB0218AC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17506-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20266 invoked by uid 550); 18 Dec 2019 00:08:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20229 invoked from network); 18 Dec 2019 00:08:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=da4hM4UJKgmO9iz3pXI2WshcEvtAp8fX82/geQVC7e0=;
        b=IHzJ0A0SVCJT2wgdRYnqM2827VaTp+bAXqjahUxWIakErH8H4u3BP8b0EC2opmBBP/
         zLgd/VEbimeoyZc9352qbSIanJqf1ICFPxO03lC2eDAprzihhwmC/rgNiFc/JIXuVZ/n
         jLkjlNMeGdOonrQIV5NUsTbwCMGflwi+FBnOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=da4hM4UJKgmO9iz3pXI2WshcEvtAp8fX82/geQVC7e0=;
        b=FcCmwBjbrt7fFFkI+wCoI1lFnMq/5HNxwkLaRwTKDDogeaK+gPfeH2Kshq8qEYlzcD
         M7nQqFyl9nG6LhI8vXiXfC7F6US6vz3KNnLT5OOpl3gvG+wCjnIBMkLcSPyD0+ZJ8RZV
         rmLkDAG5zdBXV/SNRQlOLEqBDNqHCV7YA9uYt2NNyDJlv6dv8aC24MjPWKNHlSs/7oeM
         bV7AquP+TI2Ldy0igussWta2pMIjYmMNOivWkye6cEb12ZwnjzRT4eiTFP/ptkujEqGZ
         xTkN2l2DlDQnGc4LW80JknJxGNGx8luZ1CeROBEdG6ooa+K8RNlkavcrc/G+X+nOhAnh
         YIpA==
X-Gm-Message-State: APjAAAWTuwlSDcWSutG3BRvrt8kb+E9e96aOzR3qnW2UNX98N/Yw5Im6
	UzesLcJ0YxgzAlJ4dTmqHr1PZA==
X-Google-Smtp-Source: APXvYqz8C5J4J9eWBQPXjg7+Paw02BtPeFdFGP5+iOGrZw/IMiECgcViQ8/ErKBABJ5diMLnc2/CaA==
X-Received: by 2002:aa7:98d0:: with SMTP id e16mr457396pfm.77.1576627684350;
        Tue, 17 Dec 2019 16:08:04 -0800 (PST)
Date: Tue, 17 Dec 2019 16:08:02 -0800
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2 1/3] ubsan: Add trap instrumentation option
Message-ID: <201912171607.73EE8133@keescook>
References: <20191121181519.28637-1-keescook@chromium.org>
 <20191121181519.28637-2-keescook@chromium.org>
 <20191216102655.GA11082@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216102655.GA11082@willie-the-truck>

On Mon, Dec 16, 2019 at 10:26:56AM +0000, Will Deacon wrote:
> Hi Kees,
> 
> On Thu, Nov 21, 2019 at 10:15:17AM -0800, Kees Cook wrote:
> > The Undefined Behavior Sanitizer can operate in two modes: warning
> > reporting mode via lib/ubsan.c handler calls, or trap mode, which uses
> > __builtin_trap() as the handler. Using lib/ubsan.c means the kernel
> > image is about 5% larger (due to all the debugging text and reporting
> > structures to capture details about the warning conditions). Using the
> > trap mode, the image size changes are much smaller, though at the loss
> > of the "warning only" mode.
> > 
> > In order to give greater flexibility to system builders that want
> > minimal changes to image size and are prepared to deal with kernel code
> > being aborted and potentially destabilizing the system, this introduces
> > CONFIG_UBSAN_TRAP. The resulting image sizes comparison:
> > 
> >    text    data     bss       dec       hex     filename
> > 19533663   6183037  18554956  44271656  2a38828 vmlinux.stock
> > 19991849   7618513  18874448  46484810  2c54d4a vmlinux.ubsan
> > 19712181   6284181  18366540  44362902  2a4ec96 vmlinux.ubsan-trap
> > 
> > CONFIG_UBSAN=y:      image +4.8% (text +2.3%, data +18.9%)
> > CONFIG_UBSAN_TRAP=y: image +0.2% (text +0.9%, data +1.6%)
> > 
> > Additionally adjusts the CONFIG_UBSAN Kconfig help for clarity and
> > removes the mention of non-existing boot param "ubsan_handle".
> > 
> > Suggested-by: Elena Petrova <lenaptr@google.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  lib/Kconfig.ubsan      | 22 ++++++++++++++++++----
> >  lib/Makefile           |  2 ++
> >  scripts/Makefile.ubsan |  9 +++++++--
> >  3 files changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
> > index 0e04fcb3ab3d..9deb655838b0 100644
> > --- a/lib/Kconfig.ubsan
> > +++ b/lib/Kconfig.ubsan
> > @@ -5,11 +5,25 @@ config ARCH_HAS_UBSAN_SANITIZE_ALL
> >  config UBSAN
> >  	bool "Undefined behaviour sanity checker"
> >  	help
> > -	  This option enables undefined behaviour sanity checker
> > +	  This option enables the Undefined Behaviour sanity checker.
> >  	  Compile-time instrumentation is used to detect various undefined
> > -	  behaviours in runtime. Various types of checks may be enabled
> > -	  via boot parameter ubsan_handle
> > -	  (see: Documentation/dev-tools/ubsan.rst).
> > +	  behaviours at runtime. For more details, see:
> > +	  Documentation/dev-tools/ubsan.rst
> > +
> > +config UBSAN_TRAP
> > +	bool "On Sanitizer warnings, abort the running kernel code"
> > +	depends on UBSAN
> > +	depends on $(cc-option, -fsanitize-undefined-trap-on-error)
> > +	help
> > +	  Building kernels with Sanitizer features enabled tends to grow
> > +	  the kernel size by around 5%, due to adding all the debugging
> > +	  text on failure paths. To avoid this, Sanitizer instrumentation
> > +	  can just issue a trap. This reduces the kernel size overhead but
> > +	  turns all warnings (including potentially harmless conditions)
> > +	  into full exceptions that abort the running kernel code
> > +	  (regardless of context, locks held, etc), which may destabilize
> > +	  the system. For some system builders this is an acceptable
> > +	  trade-off.
> 
> Slight nit, but I wonder if it would make sense to move all this under a
> 'menuconfig UBSAN' entry, so the dependencies can be dropped? Then you could
> have all of the suboptions default to on and basically choose which
> individual compiler options to disable based on your own preferences.

Sure; I can do that. I'll respin the series.

-- 
Kees Cook
