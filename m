Return-Path: <SRS0=pBvy=5S=lists.openwall.com=kernel-hardening-return-18397-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B40CC43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 19:32:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BC2992077D
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 19:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qtiL8TpB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC2992077D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18397-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13658 invoked by uid 550); 2 Apr 2020 19:31:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13625 invoked from network); 2 Apr 2020 19:31:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7I6mCCWO0NI2W9Hv1j2ODnDFaCT13IrYKH20fIeShyM=;
        b=qtiL8TpB80vLSxlF06cwi699QC+hLcU4dTsjnFf39v34jsBq6n0YTbCvrIiysheT5e
         0iDCSMRVYq48fkYuwf7bD68+pxz7nQ74cvtLS3nYaJvZ/0obYVA+yCpyTHkq7mg+SMkQ
         8f1FSy+tnNukU5h6Ew2OMmoz4LRVMG1Hy91BKk6TaIta7EWlN7Im+cdyphWu6CHElvxQ
         DI6YuEBFoXYi0/2CuK1IpIDQrK2TiGauWUnjjcXO3tbCTNXIgzwz0uY+weQQYLLwH4qV
         HMR0Up/BJT+QPMlycRANAHWJQePSQ3f0ZrLLcHFbcQdmKZVoe2t3s0mBEG/syw612Eko
         iu4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7I6mCCWO0NI2W9Hv1j2ODnDFaCT13IrYKH20fIeShyM=;
        b=c6xZqjXMagfbJFrUxfP6hotGrnXzt96vVX8GTfynBcjWwfDYlua95d60RlfqUV43yE
         WHluMfnvHCfgx4jfzkr9VRTjoVGssUchONyGRazL+mXq7oikRqnfm1zUNatc5ShAn0e7
         4OqaA0V+6Iq5/tntbG8q+dm4dGTlISHjQwe4GaeyNrxH8ktEmrM4rRQIXXSUePxhCzmz
         hDP+5pfrggPY/OQoxuF0T55+gI+NFjEqlDIoV4aN5dNHuApXaCjiXkbSqNbQWPhRxeS6
         ICXaDjxg4NYtHeTzrrRosAiHTqnbOIOqe8entvCGDe3NAhnGVypEwFiti6Xk396dRwmR
         5AZw==
X-Gm-Message-State: AGi0PuYpxao2NMzahVhqPvFS1lyeIEhnkuNjniWg5qwz9YQ3PxWO4Sdj
	/t5RU+/HYqtj62ZouaYAGY0JMLdOpHmPG4pkGqA=
X-Google-Smtp-Source: APiQypK/ZbpMk9Dj0Hosok9jPEo30Su45nhINvZzVFcgTSuckkMrLuD8FT88jQlIP1pGI5Y6rlhHf2KJzp2UlipKQtA=
X-Received: by 2002:a37:6411:: with SMTP id y17mr5397810qkb.437.1585855906945;
 Thu, 02 Apr 2020 12:31:46 -0700 (PDT)
MIME-Version: 1.0
References: <202004010849.CC7E9412@keescook> <20200402153335.38447-1-slava@bacher09.org>
 <f43f4e17-f496-9ee1-7d89-c8f742720a5f@bacher09.org>
In-Reply-To: <f43f4e17-f496-9ee1-7d89-c8f742720a5f@bacher09.org>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 2 Apr 2020 12:31:36 -0700
Message-ID: <CAEf4Bzb2mgDPcdNGWnBgoqsuWYqDiv39U2irn4iCp=7B3kx1nA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
To: Slava Bacherikov <slava@bacher09.org>
Cc: Andrii Nakryiko <andriin@fb.com>, Kees Cook <keescook@chromium.org>, bpf <bpf@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, Jann Horn <jannh@google.com>, 
	Alexei Starovoitov <alexei.starovoitov@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Liu Yiding <liuyd.fnst@cn.fujitsu.com>, kpsingh@google.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 2, 2020 at 8:40 AM Slava Bacherikov <slava@bacher09.org> wrote:
>
>
>
> 02.04.2020 18:33, Slava Bacherikov wrote:
> > +     depends on DEBUG_INFO || COMPILE_TEST
>
> Andrii are you fine by this ?

I think it needs a good comment explaining this weirdness, at least.
As I said, if there is no DEBUG_INFO, there is not point in doing
DWARF-to-BTF conversion, even more -- it actually might fail, I
haven't checked what pahole does in that case. So I'd rather drop
GCC_PLUGIN_RANDSTRUCT is that's the issue here. DEBUG_INFO_SPLIT and
DEBUG_INFO_REDUCED look good.
