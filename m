Return-Path: <SRS0=9T97=U2=lists.openwall.com=kernel-hardening-return-16301-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14970C48BD9
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 17:26:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 633832064A
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Jun 2019 17:26:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="M4aPeAy3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 633832064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16301-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22307 invoked by uid 550); 27 Jun 2019 17:26:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22286 invoked from network); 27 Jun 2019 17:26:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yC2k06ZrEbrPsihnFyfnuoaYxoQZIAB/UpnmdloBBeM=;
        b=M4aPeAy351r9m7DiPtmkWbyW8Ee0+gq/RD1Lg9wqwC8OOoQUCONycYei3PscpDyOhk
         OkKPaUedgsFtCO1shdwjpN4h163e76jNh/Co8Wn7gl19QplRZcMrhqfV5KsibtyZlnn4
         hPQtpynZ7mgK5bBWvSUIRosOTKb186+XC2IUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yC2k06ZrEbrPsihnFyfnuoaYxoQZIAB/UpnmdloBBeM=;
        b=sLJQjQQlY/33LQHcwtuBHPMrFA8u82+rt4eMaEzUjwBm6piJmVIy2TDZYsmFcJH4Zx
         4Vssg/cludH4zNlHg9TMG0zYqv27Wti7dEifrER4+GeMs4eeRMY0p+BWWRjrvFEGRr/3
         IrMylgvHBhLYslHWLS6LRQY/xkLMkUXgaYZFud+FJV8SlKV2zyx1J5z32QuCYZKrZ8N6
         LjFQHZtYoiDR1F97Jmn8wqc+27vTHZJyi5yx+d5UmWHRRm8V0sHmtWGAq29fnCgRPvL/
         FqIO/BZwZsenDuZCd2TLGaRJ+20p29Kl8fDgpMMPdWiI0HkYYxDkJWBd2aPcbiWyyDv0
         c/Bg==
X-Gm-Message-State: APjAAAV8shuVCUyd+E1zjxOyKN16Gt1VdKLp7vhk29ViYvSAqHWspVkN
	6L8Xhsj8goy2tRX5RgQ7Yz1HRQ==
X-Google-Smtp-Source: APXvYqwf1jdzj0nrLT8fzBbcq9r+JxRpv7xWxbAyaYhGiAa9jeVaHMzeWiFPuJE8tePBzv+dt30lhA==
X-Received: by 2002:a17:90a:26ef:: with SMTP id m102mr7318879pje.50.1561656372771;
        Thu, 27 Jun 2019 10:26:12 -0700 (PDT)
Date: Thu, 27 Jun 2019 10:26:11 -0700
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>,
	stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 1/8] x86/vsyscall: Remove the vsyscall=native
 documentation
Message-ID: <201906271026.6AB1D9493@keescook>
References: <cover.1561610354.git.luto@kernel.org>
 <d77c7105eb4c57c1a95a95b6a5b8ba194a18e764.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d77c7105eb4c57c1a95a95b6a5b8ba194a18e764.1561610354.git.luto@kernel.org>

On Wed, Jun 26, 2019 at 09:45:02PM -0700, Andy Lutomirski wrote:
> The vsyscall=native feature is gone -- remove the docs.
> 
> Fixes: 076ca272a14c ("x86/vsyscall/64: Drop "native" vsyscalls")
> Cc: stable@vger.kernel.org
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  Documentation/admin-guide/kernel-parameters.txt | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 138f6664b2e2..0082d1e56999 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -5102,12 +5102,6 @@
>  			emulate     [default] Vsyscalls turn into traps and are
>  			            emulated reasonably safely.
>  
> -			native      Vsyscalls are native syscall instructions.
> -			            This is a little bit faster than trapping
> -			            and makes a few dynamic recompilers work
> -			            better than they would in emulation mode.
> -			            It also makes exploits much easier to write.
> -
>  			none        Vsyscalls don't work at all.  This makes
>  			            them quite hard to use for exploits but
>  			            might break your system.
> -- 
> 2.21.0
> 

-- 
Kees Cook
