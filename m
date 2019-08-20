Return-Path: <SRS0=yMIb=WQ=lists.openwall.com=kernel-hardening-return-16795-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D56C3A589
	for <kernel-hardening@archiver.kernel.org>; Tue, 20 Aug 2019 15:24:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ADC0D20578
	for <kernel-hardening@archiver.kernel.org>; Tue, 20 Aug 2019 15:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="iyOgfv01"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADC0D20578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16795-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19612 invoked by uid 550); 20 Aug 2019 15:24:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19577 invoked from network); 20 Aug 2019 15:24:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=++ldOWojY8tDblUmXaoTKzVbX2yyyV+AIuIL9k4MT0M=;
        b=iyOgfv01FWVaNPSphQUxGgdrUG0cFag6Bty/LONMX7qcJMaLUcrejJmdtabLZdnhMv
         ULa6i53R0ueGr0Lyz2PuB35KETkYkokC+YukjW/Vb5Gv3zi4ASqkZjFDMORnyHFzyXvh
         PWr93TuY6I3GLoXBmZCBWgm+eZDU5w/SwERmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=++ldOWojY8tDblUmXaoTKzVbX2yyyV+AIuIL9k4MT0M=;
        b=qb+HojjzXwwwHifhkr1nirzUJi2jcuem/WTa3TBwMKR/PjNQEHGpCRjBtykQDMCzAk
         1w1viod0dMIh6NY9DPDAnRxNPlRJoEnQmNAiCCgMNALDBx62H4u9QKZFjjUsm0R2nBrn
         sFZ48f97vomiTGciWZIRLUqjfqxW8Fry6v2xhsqzeA9sQ23LJVvHBzsVWjPRpAgLiXvZ
         4KHvd1xw70/1oHn1WUXAI2f8c1lP1Xq2TtqOsI4cSjbUXPX1/cZsCcYC5R2hn6EJLb3q
         5tE8QgEVkrqiuSugUcF8v+AEejGqJsuMDmJjrKvHA2FS9HCC6Z+LJQ5W8Qy1wDlCCIFQ
         16bA==
X-Gm-Message-State: APjAAAXKo/MVz4dkNAJt/bK3xodXsu47oHtXxjjDX0Fc9+XHKX41hmgb
	yxmvdUb3rh9Jg4KoEXsRTc8V+A==
X-Google-Smtp-Source: APXvYqxuFIfetQp7VxPM4ftH2rnitO7Vr0ULMcpNvCHKoqV+9DyiZB5mnKsiwiQtgbWgavqAbsp5tQ==
X-Received: by 2002:a17:902:246:: with SMTP id 64mr23320136plc.112.1566314640713;
        Tue, 20 Aug 2019 08:24:00 -0700 (PDT)
Date: Tue, 20 Aug 2019 08:23:57 -0700
From: Kees Cook <keescook@chromium.org>
To: kpark3469@gmail.com
Cc: kernel-hardening@lists.openwall.com, re.emese@gmail.com,
	keun-o.park@darkmatter.ae
Subject: Re: [PATCH] latent_entropy: make builtin_frame_address implicit
Message-ID: <201908200823.FC9E4D26B@keescook>
References: <1566276458-6233-1-git-send-email-kpark3469@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566276458-6233-1-git-send-email-kpark3469@gmail.com>

On Tue, Aug 20, 2019 at 08:47:38AM +0400, kpark3469@gmail.com wrote:
> From: Sahara <keun-o.park@darkmatter.ae>
> 
> When Android toolchain for aarch64 is used to build this plugin,
> builtin_decl_implicit(BUILT_IN_FRAME_ADDRESS) returns NULL_TREE.
> Due to this issue, the returned NULL_TREE from builtin_decl_implicit
> causes compiler's unexpected fault in the next gimple_build_call.
> To avoid this problem, let's make it implicit before calling
> builtin_decl_implicit() for the frame address.
> 
> Signed-off-by: Sahara <keun-o.park@darkmatter.ae>
> ---
>  scripts/gcc-plugins/latent_entropy_plugin.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
> index cbe1d6c..7571990 100644
> --- a/scripts/gcc-plugins/latent_entropy_plugin.c
> +++ b/scripts/gcc-plugins/latent_entropy_plugin.c
> @@ -446,6 +446,8 @@ static void init_local_entropy(basic_block bb, tree local_entropy)
>  	frame_addr = create_var(ptr_type_node, "local_entropy_frameaddr");
>  
>  	/* 2. local_entropy_frameaddr = __builtin_frame_address() */
> +	if (!builtin_decl_implicit_p(BUILT_IN_FRAME_ADDRESS))
> +		set_builtin_decl_implicit_p(BUILT_IN_FRAME_ADDRESS, true);

Interesting! Is this aarch64-specific or something that has changed in
more recent GCC versions?

Thanks!

-Kees

>  	fndecl = builtin_decl_implicit(BUILT_IN_FRAME_ADDRESS);
>  	call = gimple_build_call(fndecl, 1, integer_zero_node);
>  	gimple_call_set_lhs(call, frame_addr);
> -- 
> 2.7.4
> 

-- 
Kees Cook
