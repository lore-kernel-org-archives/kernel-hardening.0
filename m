Return-Path: <SRS0=A33P=DH=lists.openwall.com=kernel-hardening-return-20068-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4579AC47420
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 16:06:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3535B2087D
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 16:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FdREMa9Y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3535B2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20068-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26400 invoked by uid 550); 30 Sep 2020 16:06:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26365 invoked from network); 30 Sep 2020 16:06:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4nf8e6hIaPbRqntvQjCiPI17gKDQL3g6MdR3siKHn30=;
        b=FdREMa9YQ4gNRdQHURf/x/R8SmYVJ5gIkH9KpmlqeEAlOLeXAhaYjSC7VB4Y8/uoLl
         NpSU9flOBZMB2LnlrWowvIpCnct6WksL48hJ6hEvbeije9viNCjBJLNglsVPmK17McTE
         bQR932o1ftCv5I/jccydLYq37ELOk8HLaS5waUMw2Sl4+mDrlXBlbynVNtazEd8rcTZn
         oCfVkT2gQBFoWgRMv35xCS9XqXQ6DAZwYypy9P5mdyuszGukdvxnnn/AnzhUUV4OJTG3
         jalYoYIzQjQOW6W2UeOKJ1wH4ANi3gdiXC8IiXeG+7KUsH9D9cVc5b9Ynx38GiIxo6v5
         fQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4nf8e6hIaPbRqntvQjCiPI17gKDQL3g6MdR3siKHn30=;
        b=Kdcz816JHH5luyFY6Gc9yztfH/jLrlj+hXpgt8z4PmtWg0bbW7H/CV7ud+0NJarO3y
         5SzU0jVBnJJIYpgcEuKD7fgkgcnLvb/gQ9aEzgmfNymXhow5JKzsYWXiFL0l9GAnpEmx
         gUrGfOfV+VXgY90HZAYyNhCxEp/Zeyh7bu84UVRD82g/ZNBzHKSfCSrkl9ESCm+/dNe9
         gys36uIBTIJMxX+mJAI2rPpm8sWH3ICKqukW/vSw3Xsq7uXYlf6Qbw0ABDEq4TclZXg6
         2s3O5tQDCVWIvjJS1hA/3BZdAxGS6H66z1fgjfkj4aMPi+XoaFTrgpz9EmYDm39H2qTG
         +bow==
X-Gm-Message-State: AOAM532mSUiCx6ZMu2H8/mNsHt27s1dt6DWAp7owYnNjGlIhvIIj9NHJ
	WUk5+tFw+c01uOvAaTPXPr0k12fb5eJn6VmNVhfx+w==
X-Google-Smtp-Source: ABdhPJzYVdbm3fjbvWcAsssxdkKlp1Qf8hBl3VmZLS0706h18aYEVSeaUqFy3XkT6TY1fv56XT82VdDVYI9SZJ5H+mA=
X-Received: by 2002:a17:906:a256:: with SMTP id bi22mr3464394ejb.375.1601481949457;
 Wed, 30 Sep 2020 09:05:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
 <20200929214631.3516445-7-samitolvanen@google.com> <20200929201257.1570aadd@oasis.local.home>
In-Reply-To: <20200929201257.1570aadd@oasis.local.home>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 30 Sep 2020 09:05:38 -0700
Message-ID: <CABCJKud3S7pn8Ap3AkNRUUC4v8nMwOzM2_EwEB6+NFzDp5gppA@mail.gmail.com>
Subject: Re: [PATCH v4 06/29] tracing: move function tracer options to Kconfig
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 29, 2020 at 5:13 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 29 Sep 2020 14:46:08 -0700
> Sami Tolvanen <samitolvanen@google.com> wrote:
>
> > +++ b/kernel/trace/Kconfig
> > @@ -595,6 +595,22 @@ config FTRACE_MCOUNT_RECORD
> >       depends on DYNAMIC_FTRACE
> >       depends on HAVE_FTRACE_MCOUNT_RECORD
> >
> > +config FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY
> > +     bool
> > +     depends on FTRACE_MCOUNT_RECORD
> > +
> > +config FTRACE_MCOUNT_USE_CC
> > +     def_bool y
> > +     depends on $(cc-option,-mrecord-mcount)
>
> Does the above get executed at every build? Or does a make *config need
> to be done? If someone were to pass a .config to someone else that had
> a compiler that didn't support this, would it be changed if the person
> just did a make?

Yes, it's updated if you copy a .config and just run make. For
example, here's what happens when I create a config with gcc and then
build it with Clang:

$ make defconfig
...
$ ./scripts/config -e FUNCTION_TRACER -e DYNAMIC_FTRACE
$ make olddefconfig
...
$ grep MCOUNT_USE .config
CONFIG_FTRACE_MCOUNT_USE_CC=y
$ make CC=clang
scripts/kconfig/conf  --syncconfig Kconfig
...
^C
$ grep MCOUNT_USE .config
CONFIG_FTRACE_MCOUNT_USE_OBJTOOL=y

Sami
