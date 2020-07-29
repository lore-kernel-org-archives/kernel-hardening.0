Return-Path: <SRS0=N3jC=BI=lists.openwall.com=kernel-hardening-return-19490-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA82C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Jul 2020 21:18:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1722D206D4
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Jul 2020 21:18:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ov00EPcp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1722D206D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19490-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5802 invoked by uid 550); 29 Jul 2020 21:18:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5768 invoked from network); 29 Jul 2020 21:18:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g0KUC06W8wfVDa5/aZnaCNDXj9N7Ln444BL6AjoPMxY=;
        b=Ov00EPcpcds4iXOLfFieegwR7hRlUtJeKUY5QQkoF0Jh9tZT4y47ON4fxaZEsShZVi
         fUtVBaFg6UI206ysebvZU7XlJKrNCGUtO3b3dYfZbBpeEv2+k58TFlsv9W2l+H5RlU/x
         xMnrIcH5vYD2zHkhisMgP8KYicUzt69+3EeaY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g0KUC06W8wfVDa5/aZnaCNDXj9N7Ln444BL6AjoPMxY=;
        b=GRhNSHAw5INZmIMfhO05j+sl3hj7P2KU4rN4ewj3LDHZU4TWTMIwMUz5JCV/ot6XGY
         E8uOf6i4gyNwF0ac3IOaSdxoslqfhURMTbG1U6zrraEz7VEpjsj2/nVdEZf+XIIjxEtf
         9Uk1fyj01TdQ/YUVYUTgVssV7RftzG2NS/k5DHkhBV/DxpOkT+01Y7o7H77gPu2ysKi0
         9ufCVtl1l5KXI+1/VhOvAYobSzqKhA00b0ZqclmJQadIgNnMlfdbyNywEmvjJy+/+JLI
         gdv+/c7s21q/AGzcdr3+ZPVxS4m6mwuo9ZzF912D3fHmQV7IrYyn0qeB3ALLSzgUwpip
         ZBrQ==
X-Gm-Message-State: AOAM530xmviiIct7VScUJcJ11cDhZ6wgp/1YdkCWm1bJMNx9BWeqvLVd
	UJoORYC+/x0VH6MGe/4rvbCscw==
X-Google-Smtp-Source: ABdhPJwi4J+xm/nvozPDUCQnat7NJCVcTCoGI36EfCZlyYLjp9/7AClfhzP1RAFLsh2ytY1lCy1vVg==
X-Received: by 2002:a17:90a:3488:: with SMTP id p8mr12222748pjb.211.1596057499443;
        Wed, 29 Jul 2020 14:18:19 -0700 (PDT)
Date: Wed, 29 Jul 2020 14:18:17 -0700
From: Kees Cook <keescook@chromium.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org, Emese Revfy <re.emese@gmail.com>,
	Michal Marek <michal.lkml@markovi.net>,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kbuild: move shared library build rules to
 scripts/gcc-plugins/Makefile
Message-ID: <202007291401.A50E25BB@keescook>
References: <20200729031537.37926-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729031537.37926-1-masahiroy@kernel.org>

On Wed, Jul 29, 2020 at 12:15:36PM +0900, Masahiro Yamada wrote:
> The shared library build rules are currently implemented in
> scripts/Makefile.host, but actually GCC-plugin is the only user of
> them. Hence, they do not need to be treewide available.

Are none of the VDSOs intending to use these rules?

> Move all the relevant build rules to scripts/gcc-plugins/Makefile.
> 
> I also optimized the build steps so *.so is directly built from .c
> because every upstream plugin is compiled from a single source file.
> 
> I am still keeping the infrastructure to build a plugin from multiple
> files because Kees suggested to do so in my previous attempt.
> (https://lkml.org/lkml/2019/1/11/1107)
> 
> If the plugin, foo.so, is compiled from two files foo.c and foo2.c,
> then you can do like follows:
> 
>   foo-objs := foo.o foo2.o
> 
> Single-file plugins do not need the *-objs notation.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

But, yeah, sure!

Acked-by: Kees Cook <keescook@chromium.org>

Unrelated, but I do note that objtool maybe has the wrong indentation,
path name reporting, and tool names (HOSTLD vs CC)?

...
  HOSTCC  scripts/asn1_compiler
  HOSTCC  scripts/extract-cert
  HOSTCC  scripts/genksyms/genksyms.o
  YACC    scripts/genksyms/parse.tab.[ch]
  LEX     scripts/genksyms/lex.lex.c
  DESCEND  objtool
  HOSTCXX scripts/gcc-plugins/cyc_complexity_plugin.so
  HOSTCXX scripts/gcc-plugins/latent_entropy_plugin.so
  HOSTCXX scripts/gcc-plugins/structleak_plugin.so
  GENSEED scripts/gcc-plugins/randomize_layout_seed.h
  HOSTCXX scripts/gcc-plugins/stackleak_plugin.so
  HOSTCC  scripts/genksyms/parse.tab.o
  HOSTCC  scripts/genksyms/lex.lex.o
  HOSTCC   /home/kees/src/linux-build/plugins/tools/objtool/fixdep.o
  HOSTLD  arch/x86/tools/relocs
  HOSTLD   /home/kees/src/linux-build/plugins/tools/objtool/fixdep-in.o
  LINK     /home/kees/src/linux-build/plugins/tools/objtool/fixdep
  CC       /home/kees/src/linux-build/plugins/tools/objtool/exec-cmd.o
  CC       /home/kees/src/linux-build/plugins/tools/objtool/help.o
  CC       /home/kees/src/linux-build/plugins/tools/objtool/weak.o
...

-- 
Kees Cook
