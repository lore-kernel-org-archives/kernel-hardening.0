Return-Path: <SRS0=eGka=CR=lists.openwall.com=kernel-hardening-return-19828-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703CEC433E2
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 21:23:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AC9772145D
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 21:23:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W3Pr3Jck"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC9772145D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19828-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17708 invoked by uid 550); 8 Sep 2020 21:23:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17674 invoked from network); 8 Sep 2020 21:23:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ih6QbdC2BlMXbYNA/XrG1Rz+rSEU4l2iSukj1ZYcfcE=;
        b=W3Pr3JckrBkhsvVBPRqyalyPCHmDdjwsO8lMz82fl3992mSkJBCa/ynKYFlOpa29KS
         YrQvjiSk8Gsj+2F0XyIFg6bT/TX3bdtqIzg+X9zApTyghMxBvgeVK7VjGnj0Xvez1x1T
         vtDDvMHWVF2Q9VElpy4Et4CUBV2fAGlDpuHSIHxSfO2vTMGl2CEODJDA3aVOsYuSr2rb
         54oZUVIzZ6F0vJ0E2vHEj9aGY9uEozAJoPE35B9/ZkY30GF+FwBSaPHMJZxUW1Gwmrih
         hraJxCrNOD15xVsyVUJ11S0Z4yNK+aS0/3uKyQbwkUQtxQoq+M+Ub2vQlfRLbEhbUoo0
         TnTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ih6QbdC2BlMXbYNA/XrG1Rz+rSEU4l2iSukj1ZYcfcE=;
        b=X8qKzqb5Fzmk7Cvpoqm8wtQ0erDJGCLH+47UiO8zrVkbdkPfYk67ikNc8ci/n2+Sy1
         Zf1zAlAimTATuZqHqQHm9sYIwLtwuSp7VrHAM3LaVsMc3bjwsHrOOZgRyHDxBljKp2aY
         KL4ZDIkDsS3atF0/ZH/Q0IJDPpXuv4U3duhqPttiemdhBilq+KmnMKNuH9IKf+mtYQ9V
         5XUcNiZEopjNv7vd/WEXPkPveu4LcALcDOVkCTL7JcUx23GGOxgTFwBy1wZQ8PJsU+MD
         WRHp3fNaCv7JeYK8a/mzG/EArDhSTvPNsONbVfe6bYoDGwpIC8hLY58KQfV9xF7esSRC
         rv1g==
X-Gm-Message-State: AOAM531GzZnP87NEXaz7Px1DFrhBoOTcKbwVg7QWH/rjrTFrxpFfmLGc
	HhLfR0thdG4MiTrZwBvqJd7Jqg==
X-Google-Smtp-Source: ABdhPJxZtQ6suAAYIvComwJnL/d5p58yR7wkXLgcU+gM/W/qIhxDDa8Jsi9la7BgYDO45OUXHd5G6Q==
X-Received: by 2002:a05:6a00:1356:b029:13e:d13d:a084 with SMTP id k22-20020a056a001356b029013ed13da084mr947839pfu.27.1599600189879;
        Tue, 08 Sep 2020 14:23:09 -0700 (PDT)
Date: Tue, 8 Sep 2020 14:23:02 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 22/28] arm64: export CC_USING_PATCHABLE_FUNCTION_ENTRY
Message-ID: <20200908212302.GD1060586@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-23-samitolvanen@google.com>
 <202009031544.D66F02D407@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009031544.D66F02D407@keescook>

On Thu, Sep 03, 2020 at 03:44:18PM -0700, Kees Cook wrote:
> On Thu, Sep 03, 2020 at 01:30:47PM -0700, Sami Tolvanen wrote:
> > Since arm64 does not use -pg in CC_FLAGS_FTRACE with
> > DYNAMIC_FTRACE_WITH_REGS, skip running recordmcount by
> > exporting CC_USING_PATCHABLE_FUNCTION_ENTRY.
> > 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> 
> How stand-alone is this? Does it depend on the earlier mcount fixes?

It does, because exporting CC_USING_PATCHABLE_FUNCTION_ENTRY doesn't
change anything without the earlier mcount changes.

Sami
