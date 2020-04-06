Return-Path: <SRS0=u6yP=5W=lists.openwall.com=kernel-hardening-return-18443-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E01E6C2BA17
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 18:23:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4971020672
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Apr 2020 18:23:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UPvVgdH8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4971020672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18443-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23631 invoked by uid 550); 6 Apr 2020 18:23:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23611 invoked from network); 6 Apr 2020 18:23:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t1E7i5Ja/N4v3hN9ILxMO9xPBTPnxiRK5Clfelm4oBw=;
        b=UPvVgdH8M87ZZpVFk710GBac6Ivj+/QhMtWTYlwmRZOj1tj7f2kNEC+ZiI35QZ5dL4
         MGx/U2nXkhynTePhJKF2P/g9mbGDtn5+ErGMSjnhl32QKNOfQYn2U+paYJNipAm3VyAA
         D58HSMWOlbmLBj7Gg5Te2Kpdrw+3StLiF0oh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t1E7i5Ja/N4v3hN9ILxMO9xPBTPnxiRK5Clfelm4oBw=;
        b=SL1WDBeGeM/mfJaFGddH8RSvydANEK55dHV9vdnqQ65ITPMYHTfJkEJEYUeOkprVEp
         WuDWGRD5jjsDpsPNRI+xokrdLrRBqLHUKOnrI/gOclbzjdTS0m0ULaP+U3Ttg1go2sXW
         DmqlxhSGBk4XShgLHlFbdbGNJwAGNXSNOCigjK97U/OfIpsEfneCpFoI20BL5bVWnCBz
         cdo0HX2pzGQXKxC0sKiK8fmaSYySrI6D7j0d6sJ1OJ+biRl90PJa5uGeYWCNQjDN2ksq
         yTF3saDk1mIeHdmXw+9v+O5X7gJVc16PSA/7O4l/kA/tWr7JwGX4IiFgE+XUrMYoJYyX
         LeYA==
X-Gm-Message-State: AGi0PuaxBZk4tyYQLx6cey8/K3xQgrEX8HJ0b+ipH0xduoOqcq6zucyt
	qmQDUdyRlfMbHdL3K97jE2n7PA==
X-Google-Smtp-Source: APiQypIUOtn72OybuMmOpw7ZoRHvYwoqpUGT0d68iEfAhBT8YfgewjV9UGIYBvXQYFb80jItY6ieRQ==
X-Received: by 2002:a17:902:d685:: with SMTP id v5mr22055094ply.256.1586197407139;
        Mon, 06 Apr 2020 11:23:27 -0700 (PDT)
Date: Mon, 6 Apr 2020 11:23:24 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 09/12] arm64: disable SCS for hypervisor code
Message-ID: <202004061123.CE436424@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200406164121.154322-1-samitolvanen@google.com>
 <20200406164121.154322-10-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406164121.154322-10-samitolvanen@google.com>

On Mon, Apr 06, 2020 at 09:41:18AM -0700, Sami Tolvanen wrote:
> Disable SCS for code that runs at a different exception level by
> adding __noscs to __hyp_text.
> 
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> Acked-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_hyp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index fe57f60f06a8..875b106c5d98 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -13,7 +13,7 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/sysreg.h>
>  
> -#define __hyp_text __section(.hyp.text) notrace
> +#define __hyp_text __section(.hyp.text) notrace __noscs
>  
>  #define read_sysreg_elx(r,nvh,vh)					\
>  	({								\
> -- 
> 2.26.0.292.g33ef6b2f38-goog
> 

-- 
Kees Cook
