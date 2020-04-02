Return-Path: <SRS0=qh0b=5S=lists.openwall.com=kernel-hardening-return-18401-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1485C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 21:03:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 480912064A
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 21:03:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="daDolYs7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 480912064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18401-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16350 invoked by uid 550); 2 Apr 2020 21:03:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16314 invoked from network); 2 Apr 2020 21:03:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sVjs2DH9m9fKgjs6n5kVRWIE0vGLsA/x3K/6uNiKORs=;
        b=daDolYs7NP3AZpiXGh8vMaDcVivAzxdICdi7a5NF4eji04bA84T747X4wiXOZfMH1J
         PNU/6IAUp2gnrVx3HcfMPiEYj3DWHUs4qsHQMDo/8VyrnqhbyL/TsfFtFZWlJkCad0tt
         364Ci6j98+J/faVYlvmIY+4UIDBWba5IvRCj9/RzlsszImRrZkEPx5xpJoA96RtuDcPb
         YpDWiyEPusaB0pnVTjDtQuAJhB74DWBcXrYhxOttkXswGEBqQ1KJ4gAnQEbiUNvm757G
         u2ylGGb36YA0ZpNX0UESKPW8vKTbUxfLeK/O0MdLC+bZkDXzMOVECnHORTppQ3y3WU1j
         T9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sVjs2DH9m9fKgjs6n5kVRWIE0vGLsA/x3K/6uNiKORs=;
        b=hVrECEhR6Vt/svUbHOuYJIFTw+n5SvVV6b2rPoPivputHfJ/klUHC0EeVgPotqxHJk
         /zVA0YPz9t7IvFTAUct5l90Psnr9znY8S8RG94UeOx6yIY6wXUbrw4AWCvQZM+uXeWTd
         xy/gP3ysR9cCdT1/TQO2W3TXZeei+9BL3FNM4cLC6rUus6ktDg32oVkxVZ6fnh/XymBW
         S2J8xeHUPRF+YeZMRfqV7C3mR9NDO8nrRAsbEIhrQFUNEk7TcF1Kf+ymtTPGtVfwNkZH
         SH4kCuG+fhwPU/cNee7iBjyWypSsMmA/KgwdTdbzXopwkHojW+3J0ZHJQt3XhgrEV595
         zBvg==
X-Gm-Message-State: AGi0PuZPHiShgrpvOGb+WKxwXYvKmt0n2XBbLndOcalSM5N4x2JX/uFF
	O2kJ5DbCSBMvu9wQ1+gOEY6wel0O2O5oqZ8lfNU=
X-Google-Smtp-Source: APiQypI9U0BrOKkyTjQVQejiiAYGIbOCtFil/m6mRrtSQalLPzDZZy1MMaWsZIdOvgwQjFiGvhPG+t9P95gmvP0Beew=
X-Received: by 2002:a37:6411:: with SMTP id y17mr5760875qkb.437.1585861388455;
 Thu, 02 Apr 2020 14:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <202004021328.E6161480@keescook> <20200402204138.408021-1-slava@bacher09.org>
In-Reply-To: <20200402204138.408021-1-slava@bacher09.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 2 Apr 2020 14:02:57 -0700
Message-ID: <CAEf4BzZxWTDCtcov5_TvGLR0Qp4p-JANh29WoZKEQ6FvmWrr9A@mail.gmail.com>
Subject: Re: [PATCH v5 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
To: Slava Bacherikov <slava@bacher09.org>
Cc: Andrii Nakryiko <andriin@fb.com>, Kees Cook <keescook@chromium.org>, bpf <bpf@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Liu Yiding <liuyd.fnst@cn.fujitsu.com>, KP Singh <kpsingh@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 2, 2020 at 1:44 PM Slava Bacherikov <slava@bacher09.org> wrote:
>
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
> Acked-by: KP Singh <kpsingh@google.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
> ---
>  lib/Kconfig.debug | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index f61d834e02fe..6118d99117da 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -223,6 +223,8 @@ config DEBUG_INFO_DWARF4
>  config DEBUG_INFO_BTF
>         bool "Generate BTF typeinfo"
>         depends on DEBUG_INFO
> +       depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
> +       depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST

Given what Kees explained, I think this looks good. Thanks!

>         help
>           Generate deduplicated BTF type information from DWARF debug info.
>           Turning this on expects presence of pahole tool, which will convert
