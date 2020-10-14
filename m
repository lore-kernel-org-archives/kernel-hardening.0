Return-Path: <SRS0=1vIO=DV=lists.openwall.com=kernel-hardening-return-20211-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8289BC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 22:58:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6947820797
	for <kernel-hardening@archiver.kernel.org>; Wed, 14 Oct 2020 22:58:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="R63EBTH6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6947820797
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20211-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15741 invoked by uid 550); 14 Oct 2020 22:58:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15704 invoked from network); 14 Oct 2020 22:58:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WUVth3Yi/0Gf6s7eybXLKtt4uMjJ4xi70yGGSwDkLw0=;
        b=R63EBTH6+0dTkzS267+O24BYdxnurWecDwGpDuhGH5wyKY0Pg8ynHUH/iEecP4Gnho
         RfNGPWH3YDit4Wmb0luYZWOyRplddz6hFIgmHH4CLhIZt4IyCFh8a/BvWIZDZQnBcGoK
         FZBeYg7LPlk+kUu4N8sYcxncY/8J8OqwbusLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WUVth3Yi/0Gf6s7eybXLKtt4uMjJ4xi70yGGSwDkLw0=;
        b=qwxHJbP+v4NChrvOxYxgCHxaiCRATt2XK1BYi2TiTL12XBvPYVnmqNd7DEdgj9hazR
         NPzdiXVfjAW5feeM77RHljMgK8OW7SrisL4CdiXL+jBYAKO7FTfFohPHtnnnG+heX3aL
         fp3LMXgOjpLRtSY9Ks7KKCWTjjQ9we8mwkBacGFSq4L6/V/2m5gwBCyTzxASenQYXgLS
         ILuChPUv7ozQ5dt56FntuoQ3ZwqpYQHKmj3DH16HGHyHjQjgueR6kuWjkUdQLM7GkgyB
         GgI043zl3z0CuSnwwTKykMU1R+84IN5oyz08pcQYlDDLZjWLkU3SYkjFuht93g9RhKB2
         bnBQ==
X-Gm-Message-State: AOAM5329D7cTiXg/kbq+d6JaOWu7HHHDWzpdMalio8h9zcJe6bkQvsy5
	7g9nBQOZPfgbU6aVXguFWXI08gEMDrq9pg==
X-Google-Smtp-Source: ABdhPJzHdqdE46WrFZlw8R7S7F1x+3bND/WLRTw47I4euXQao8J+1ZC4KoSJiwuZcz/FXnt7OEBn6A==
X-Received: by 2002:a17:902:59da:b029:d4:c71a:357a with SMTP id d26-20020a17090259dab02900d4c71a357amr1496188plj.38.1602716293981;
        Wed, 14 Oct 2020 15:58:13 -0700 (PDT)
Date: Wed, 14 Oct 2020 15:58:12 -0700
From: Kees Cook <keescook@chromium.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v6 17/25] PCI: Fix PREL32 relocations for LTO
Message-ID: <202010141556.DC58D913@keescook>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-18-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201013003203.4168817-18-samitolvanen@google.com>

On Mon, Oct 12, 2020 at 05:31:55PM -0700, Sami Tolvanen wrote:
> With Clang's Link Time Optimization (LTO), the compiler can rename
> static functions to avoid global naming collisions. As PCI fixup
> functions are typically static, renaming can break references
> to them in inline assembly. This change adds a global stub to
> DECLARE_PCI_FIXUP_SECTION to fix the issue when PREL32 relocations
> are used.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Another independent patch! :) Bjorn, since you've already Acked this
patch, would be be willing to pick it up for your tree?

-Kees

> ---
>  include/linux/pci.h | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 835530605c0d..4e64421981c7 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1909,19 +1909,28 @@ enum pci_fixup_pass {
>  };
>  
>  #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
> -#define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
> -				    class_shift, hook)			\
> -	__ADDRESSABLE(hook)						\
> +#define ___DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
> +				    class_shift, hook, stub)		\
> +	void stub(struct pci_dev *dev);					\
> +	void stub(struct pci_dev *dev)					\
> +	{ 								\
> +		hook(dev); 						\
> +	}								\
>  	asm(".section "	#sec ", \"a\"				\n"	\
>  	    ".balign	16					\n"	\
>  	    ".short "	#vendor ", " #device "			\n"	\
>  	    ".long "	#class ", " #class_shift "		\n"	\
> -	    ".long "	#hook " - .				\n"	\
> +	    ".long "	#stub " - .				\n"	\
>  	    ".previous						\n");
> +
> +#define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
> +				  class_shift, hook, stub)		\
> +	___DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
> +				  class_shift, hook, stub)
>  #define DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
>  				  class_shift, hook)			\
>  	__DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
> -				  class_shift, hook)
> +				  class_shift, hook, __UNIQUE_ID(hook))
>  #else
>  /* Anonymous variables would be nice... */
>  #define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, class,	\
> -- 
> 2.28.0.1011.ga647a8990f-goog
> 

-- 
Kees Cook
