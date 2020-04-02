Return-Path: <SRS0=9blu=5S=lists.openwall.com=kernel-hardening-return-18398-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CBE7C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 20:34:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5986620678
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 20:34:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="KM2DmTOw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5986620678
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18398-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1265 invoked by uid 550); 2 Apr 2020 20:34:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1232 invoked from network); 2 Apr 2020 20:34:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yY13RK0cKLrRjyvVBZully+r67kfxos978vIN0ruhpk=;
        b=KM2DmTOwPos0F7tLttvMAVY1LIa4ppIAmoFp2MqTGkdJDILQMA+dZFGoZUczJkP06n
         tIY11T4DiaYxZ3XpYIcaUADijDTLfmnhM6w5KLWiXD/U/5E644jQ7tBWEtkWTvI15PEr
         VVKHw3OqKjW7vcSabDsfT8G6FUxq86I+tgWHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yY13RK0cKLrRjyvVBZully+r67kfxos978vIN0ruhpk=;
        b=meNScW3CJMUlHHwuRETTsDOPO3+qHjphf8WX/EI/TaPSFR5zFLaNWrFq84jLmwIZrl
         XvCj2L+VL5EPz40xgPhFxK7S2OZlT9tJoFhwuHQsydyIRHYB9wbtP/CiXcv0PQQTss2N
         jIx218T/qfHq6yZwgs8kif9Nqpi3yMFhGnVX4eoklRcFJn6rm1EqzUdPfnrJHLwxGIa+
         eiUJZYDTaOnyUpf1dL5+uylBimc1n0wYxc0VGS957J95zVkBZLLn6nMSQF8+mEvbv+yj
         SWGv/lwKSIBkSSLWgGluQyvzV23Owk/MfGGEoadHLu7g154lW/wjvZEyaBappS5lq9GP
         OUVQ==
X-Gm-Message-State: AGi0PuYxsGRM+E1UfxanTm9wL6lUOddkofWwW0OfJtBtVycxtw1+HVwM
	FUgkJHzYHma8CPZsXEPqWKDgcw==
X-Google-Smtp-Source: APiQypIs5T+kRG38bpYFVlAfcbXCyZRjGu+qpBmjvk/e/tatzFR3rVbYNciSAuDjjUc5Jz4/iCXxsA==
X-Received: by 2002:a63:8f17:: with SMTP id n23mr5078110pgd.417.1585859673922;
        Thu, 02 Apr 2020 13:34:33 -0700 (PDT)
Date: Thu, 2 Apr 2020 13:34:32 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Slava Bacherikov <slava@bacher09.org>, Andrii Nakryiko <andriin@fb.com>,
	bpf <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
	Jann Horn <jannh@google.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Liu Yiding <liuyd.fnst@cn.fujitsu.com>, kpsingh@google.com
Subject: Re: [PATCH v4 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
Message-ID: <202004021328.E6161480@keescook>
References: <202004010849.CC7E9412@keescook>
 <20200402153335.38447-1-slava@bacher09.org>
 <f43f4e17-f496-9ee1-7d89-c8f742720a5f@bacher09.org>
 <CAEf4Bzb2mgDPcdNGWnBgoqsuWYqDiv39U2irn4iCp=7B3kx1nA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb2mgDPcdNGWnBgoqsuWYqDiv39U2irn4iCp=7B3kx1nA@mail.gmail.com>

On Thu, Apr 02, 2020 at 12:31:36PM -0700, Andrii Nakryiko wrote:
> On Thu, Apr 2, 2020 at 8:40 AM Slava Bacherikov <slava@bacher09.org> wrote:
> >
> >
> >
> > 02.04.2020 18:33, Slava Bacherikov wrote:
> > > +     depends on DEBUG_INFO || COMPILE_TEST
> >
> > Andrii are you fine by this ?
> 
> I think it needs a good comment explaining this weirdness, at least.
> As I said, if there is no DEBUG_INFO, there is not point in doing
> DWARF-to-BTF conversion, even more -- it actually might fail, I
> haven't checked what pahole does in that case. So I'd rather drop
> GCC_PLUGIN_RANDSTRUCT is that's the issue here. DEBUG_INFO_SPLIT and
> DEBUG_INFO_REDUCED look good.

The DEBUG_INFO is separate, AIUI -- it sounds like BTF may entirely
break on a compile with weird DWARF configs.

The GCC_PLUGIN_RANDSTRUCT issue is separate: it doesn't make sense to
run a kernel built with BTF and GCC_PLUGIN_RANDSTRUCT. But they should
have nothing to do with each other with regard to compilation. So, to
keep GCC_PLUGIN_RANDSTRUCT disable for "real" builds but leave it on for
all*config, randconfig, etc, I'd like to keep the || COMPILE_TEST,
otherwise GCC_PLUGIN_RANDSTRUCT won't be part of the many CIs doing
compilation testing.

And FWIW, I'm fine to let GCC_PLUGIN_RANDSTRUCT and BTF build together.
But if they want to be depends-conflicted, I wanted to keep the test
compile trap door.

-- 
Kees Cook
