Return-Path: <SRS0=6aAH=5Q=lists.openwall.com=kernel-hardening-return-18343-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DEAC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 22:40:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A5F7220787
	for <kernel-hardening@archiver.kernel.org>; Tue, 31 Mar 2020 22:40:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VDiCMTXy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5F7220787
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18343-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13684 invoked by uid 550); 31 Mar 2020 22:40:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13652 invoked from network); 31 Mar 2020 22:40:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jY5b0DeIGw0kq+dmH/vJgCrU2SOoRk0fZBuTs/xmVo0=;
        b=VDiCMTXyKUNt4iheUBH8m+6xsiIx/rgJTGicdZ/BWJF7GmTfsrCY7g+447EMzve3aq
         Y+ldUezP4BlAWoR5IQfLpc6iFnWWr1G6v9bb02zEQLrKSg4qsJ4HrBuw7+exNKd9bAfU
         jdqJY5s8D3nIc5Tz5vqTofy5j8BNQJ7duYeCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jY5b0DeIGw0kq+dmH/vJgCrU2SOoRk0fZBuTs/xmVo0=;
        b=GN+SB8ANlMXjstvi7jNAZytz4byhzctbuPE80dM3WmO0KAalqxLhzYc8R9HBXz+1CT
         Iuz1wgQY9cExdyPgZzjzFOO1RHsHgS6i/6oQi2v4lMiTXJUhRDc2FhDWTTjMej4flzO3
         o4YvCntgl0Xh1LsyenzzAHHad9AmVeJgxJc78KuHXqz+u1uDxAPhcb3QyYmMcdt/WmAN
         +8z7C/ZiNwmraKxmN4Ob1ZKopyLBUMw0ixHLbamE+TLrdanGbZPxLYjnGGcGOQyENkHs
         zWC5inPYifyHglEI13b+5H2mqc7d8f6IPMxoELYZjeMtvotzZXePNadEKY7DQwQLy1Nd
         +lzw==
X-Gm-Message-State: AGi0PuYv4TqwnF2bDEZSdqs/R+OwpPp5LP0gQ/3LJgWTbi4U/wyDQQM5
	s+rGXuOA9Ou9Y/4uetRj23xL5Q==
X-Google-Smtp-Source: APiQypLOGvUileQhr35EVvXv/b90kFXVu0uzau9TlILC3ZUR48htnauWq/BaHsz4upygp1gntHv0QA==
X-Received: by 2002:adf:fe52:: with SMTP id m18mr976140wrs.162.1585694424872;
        Tue, 31 Mar 2020 15:40:24 -0700 (PDT)
From: KP Singh <kpsingh@chromium.org>
X-Google-Original-From: KP Singh <kpsingh>
Date: Wed, 1 Apr 2020 00:40:22 +0200
To: Slava Bacherikov <slava@bacher09.org>
Cc: andriin@fb.com, keescook@chromium.org, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org, jannh@google.com,
	alexei.starovoitov@gmail.com, daniel@iogearbox.net,
	kernel-hardening@lists.openwall.com,
	Liu Yiding <liuyd.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v2 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
Message-ID: <20200331224022.GA23586@google.com>
References: <20200331215536.34162-1-slava@bacher09.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331215536.34162-1-slava@bacher09.org>

On 01-Apr 00:55, Slava Bacherikov wrote:
> Currently turning on DEBUG_INFO_SPLIT when DEBUG_INFO_BTF is also
> enabled will produce invalid btf file, since gen_btf function in
> link-vmlinux.sh script doesn't handle *.dwo files.
> 
> Enabling DEBUG_INFO_REDUCED will also produce invalid btf file, and
> using GCC_PLUGIN_RANDSTRUCT with BTF makes no sense.
> 
> Signed-off-by: Slava Bacherikov <slava@bacher09.org>
> Reported-by: Jann Horn <jannh@google.com>
> Reported-by: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
> Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")

I can say that I also got invalid BTF when I tried using
DEBUG_INFO_REDUCED.

So here's a first one from of these from me :)

Acked-by: KP Singh <kpsingh@google.com>

> ---
>  lib/Kconfig.debug | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index f61d834e02fe..9ae288e2a6c0 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -223,6 +223,7 @@ config DEBUG_INFO_DWARF4
>  config DEBUG_INFO_BTF
>  	bool "Generate BTF typeinfo"
>  	depends on DEBUG_INFO
> +	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED && !GCC_PLUGIN_RANDSTRUCT
>  	help
>  	  Generate deduplicated BTF type information from DWARF debug info.
>  	  Turning this on expects presence of pahole tool, which will convert
> -- 
> 2.24.1
> 
