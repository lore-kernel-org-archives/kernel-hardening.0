Return-Path: <SRS0=gsQX=CM=lists.openwall.com=kernel-hardening-return-19759-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72089C43461
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:12:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B39DF20722
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:12:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bCIKEXnT"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B39DF20722
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19759-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3875 invoked by uid 550); 3 Sep 2020 22:12:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3840 invoked from network); 3 Sep 2020 22:12:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BwuEtmyXe7F2cR0q4/BzPn1A0ke23BiGgvDQhdo0WMU=;
        b=bCIKEXnTf0ca1JmAwAE+LZOTcE2dN/TiK90vOBcdOhHh/Eb1NLoFw7SGFvV4u1q4yd
         NSCanRXVgtM0tLCAM/3prxemS1L+tmFwrVZgjePvUDD44B5oCHIVMnvMHwsYfaBSh/Yc
         ffmoIuI333/SJsY+DmYpMd9pJN4WUM6UZUH4iyAU5CMWkI/ub98PWyrdm/IgFhN66cyb
         KAJCdgJvjtjPtzH0nHOK8Q44XszFzrAF+OGkeCpJsCVm4vUIQ5GYCIXnLOQe2wb/sK6A
         t28MQcHuz/Eyk+V8/eVV05WMiL8r79f3UOiZYAKgfKK5uep6TWKRy9tUGQI9YxjCiAu1
         jxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BwuEtmyXe7F2cR0q4/BzPn1A0ke23BiGgvDQhdo0WMU=;
        b=aZYgUmIfB4cjFYaKICswa4u5BgrqbI2wuRoae8dMR/GdVtturyI7TPRM+CRPUFgJ8I
         k1McBdnTl7Qd55/5Hi87CwhUcO8W4C8VWRcABrJ/JEuc1oUpehOpL/B0roxRwNxDvFzQ
         PoOzMr9wLTcFcNBWR8Vr+S+tBOA9hlwcUCJpJqsNPL1xuuZHAfbzZIi9/gXPuvIRA/R+
         kmaQrKzHVAdOCjALvLXrmShll+1hctEZABSv4JKCcLlVERYlgk9u60409tIEU6gbfdoL
         rM6bzjo35lxSD1hbkq45dEUEh1mkTODg1VBvmHRLM9y+mCqxq02gBNzMt7EGfK1KpI1G
         7YSA==
X-Gm-Message-State: AOAM531OquGolZXhSTUL5cmGKdzWkgw7LHcxJWBUKX+I2NppvSP31h+k
	A1089HEATA3odQySwFR548rK4kzw9345s4uTmJkZeQ==
X-Google-Smtp-Source: ABdhPJzTTihf74kYnNBBzSlXexZpmKM7vZMRAKfIQLzvqwFNAx6uvnwDBIQzEJ98cMtCA2J/JaapvP+XgOC8JK4Jyhw=
X-Received: by 2002:a17:906:7492:: with SMTP id e18mr4301672ejl.375.1599171125797;
 Thu, 03 Sep 2020 15:12:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com> <20200903203053.3411268-9-samitolvanen@google.com>
 <202009031456.C058EC4@keescook>
In-Reply-To: <202009031456.C058EC4@keescook>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 3 Sep 2020 15:11:54 -0700
Message-ID: <CABCJKufxq2b0854MBA_Kkb0B1k5D1Z431a=m=w2zoOVUh2c==Q@mail.gmail.com>
Subject: Re: [PATCH v2 08/28] x86, build: use objtool mcount
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Sep 3, 2020 at 2:58 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Sep 03, 2020 at 01:30:33PM -0700, Sami Tolvanen wrote:
> > Select HAVE_OBJTOOL_MCOUNT if STACK_VALIDATION is selected to use
> > objtool to generate __mcount_loc sections for dynamic ftrace with
> > Clang and gcc <5.
> >
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
>
> Am I right to understand that this fixes mcount for Clang generally
> (i.e. it's not _strictly_ related to LTO, though LTO depends on this
> change)?

No, this works fine with Clang when LTO is disabled, because
recordmcount ignores files named "ftrace.o". However, with LTO, we
process vmlinux.o instead, so we need a different method of ignoring
__fentry__ relocations that are not calls.

In v1, I used a function attribute to whitelist functions that refer
to __fentry__, but as Peter pointed out back then, objtool already
knows where the call sites are, so using it to generate __mcount_loc
is cleaner.

> And does this mean mcount was working for gcc < 5?

Yes. I should have been clearer in the commit message. The reason I
mentioned gcc <5 is that later gcc versions support -mrecord-mcount,
which means they don't need an external tool for generating
__mcount_loc anymore.

Sami
