Return-Path: <SRS0=Wz+R=5R=lists.openwall.com=kernel-hardening-return-18347-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65416C43331
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 07:32:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B7D0320772
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 07:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eH7GQi4F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7D0320772
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18347-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21964 invoked by uid 550); 1 Apr 2020 07:32:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21931 invoked from network); 1 Apr 2020 07:32:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Q2zlprsjpvbH/CUCgF6/KaFZrKtD3zRPUib4YqmUolQ=;
        b=eH7GQi4Fb+gecHNihtjNMlPCkT58qolygnegnhh5hSJE1vBUBJ66LNnElFLF0DunMT
         FDAwRc5Hey0enMXIuTw8vOI9JR6u+IfleFr/zhPd9/fbIfhyQFu1uS1hiiX8gUWqR+RG
         PBAMcJAeTHpk9Uk9APR8+Vb/7wsuXYEM+S8fs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Q2zlprsjpvbH/CUCgF6/KaFZrKtD3zRPUib4YqmUolQ=;
        b=bVRItl34sd8bX3qGyHO9833eOXj3VjYodo7hwtEinT/q5Lg3xe9CFT59ZiI6HGMA2L
         xzio7kGoUqK38ePefWfpNy4kUwz3FdQV0gsfDPZi4nhAvsnfD7m+i5YyQUXlHN1dmUI/
         YDS3cyo7Zb3dSx92tkqSJjNtszxSGKkc/Tc7N8AohMdIaAZ28ZaoqIftb78YeuDzSmY7
         FdtffSbay200dMxQqn7EW13iaL4Nd+KFISwybcrlhetMyMY4Yn2Ald/uGqX6okISfLR3
         d4/Z8H1h9SgD7Lf0G5Y89pL00PLn4VHZSecoEtdCUWshUNzp7q8cSNbIqRml1R/BFbh6
         Yo0w==
X-Gm-Message-State: AGi0PubKVFMxiy7fwZwNquuw1PjYbO3KU+7rVJKcmeXytI7eSdyi6f1a
	RPx9KdgeVfj/5z++NnnReCYHpg==
X-Google-Smtp-Source: APiQypKmwoN+WlTZJjmydYo5ouItfzTZNL+lOANxC/eXYfxIziyQqxNU1yxknZE8OOqBHFK5Z7Q0QA==
X-Received: by 2002:a17:90b:4396:: with SMTP id in22mr3252194pjb.10.1585726350003;
        Wed, 01 Apr 2020 00:32:30 -0700 (PDT)
Date: Wed, 1 Apr 2020 00:32:28 -0700
From: Kees Cook <keescook@chromium.org>
To: Slava Bacherikov <slava@bacher09.org>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jann Horn <jannh@google.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	bpf <bpf@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: CONFIG_DEBUG_INFO_BTF and CONFIG_GCC_PLUGIN_RANDSTRUCT
Message-ID: <202004010029.167BA4AA1F@keescook>
References: <CAG48ez2sZ58VQ4+LJu39H1M0Y98LhRYR19G_fDAPJPBf7imxuw@mail.gmail.com>
 <CAADnVQ+Ux3-D_7ytRJx_Pz4fStRLS1vkM=-tGZ0paoD7n+JCLQ@mail.gmail.com>
 <CAG48ez0ajun-ujQQqhDRooha1F0BZd3RYKvbJ=8SsRiHAQjUzw@mail.gmail.com>
 <202003301016.D0E239A0@keescook>
 <c332da87-a770-8cf9-c252-5fb64c06c17e@iogearbox.net>
 <202003311110.2B08091E@keescook>
 <CAEf4BzYZsiuQGYVozwB=7nNhVYzCr=fQq6PLgHF3M5AXbhZyig@mail.gmail.com>
 <202003311257.3372EC63@keescook>
 <CAEf4BzYODtQtuO79BAn-m=2n8QwPRLd74UP-rwivHj6uLk3ycA@mail.gmail.com>
 <8962ffa8-69b7-ab6b-3969-3029a95dfcec@bacher09.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8962ffa8-69b7-ab6b-3969-3029a95dfcec@bacher09.org>

On Wed, Apr 01, 2020 at 12:24:46AM +0300, Slava Bacherikov wrote:
> 31.03.2020 23:23, Andrii Nakryiko пишет:
> > On Tue, Mar 31, 2020 at 12:58 PM Kees Cook <keescook@chromium.org> wrote:
> >> Sure! That'd by fine by me. I'd just like it to be a "|| COMPILE_TEST"
> >> for GCC_PLUGIN_RANDSTRUCT. Feel free to CC me for an Ack. :)
> >>
> > 
> > +cc Slava
> > 
> > I'm unsure what COMPILE_TEST dependency (or is it anti-dependency?)
> > has to do with BTF generation and reading description in Kconfig
> > didn't clarify it for me. Can you please elaborate just a bit? Thanks!
> > 
> >> -Kees
> 
> Hi,
> 
> Regarding COMPILE_TEST, DEBUG_INFO has dependency on:
> 
> DEBUG_KERNEL && !COMPILE_TEST
> 
> And DEBUG_INFO_BTF depends on DEBUG_INFO, so enabling COMPILE_TEST
> would block DEBUG_INFO and so DEBUG_INFO_BTF as well. Unless I don't
> understand something and there is some other reason to add it.

I meant that if you're adjusting the depends for GCC_PLUGIN_RANDSTRUCT,
I'd like it to be:

	depends on COMPILE_TEST || !DEBUG_INFO

That way randconfig, all*config, etc, will still select
GCC_PLUGIN_RANDSTRUCT with everything else, regardless of DEBUG_INFO.

-- 
Kees Cook
