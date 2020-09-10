Return-Path: <SRS0=IbRI=CT=lists.openwall.com=kernel-hardening-return-19840-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D10E7C43461
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 15:07:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CB3EA2087C
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 15:07:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eS8Omoyt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB3EA2087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19840-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11708 invoked by uid 550); 10 Sep 2020 15:07:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11673 invoked from network); 10 Sep 2020 15:07:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CkdZTgPQtli4HqKjoybGJC69i/K2eo+/Y/ueOVTU/uQ=;
        b=eS8OmoytThC7KUY/Rbjn9+OdhHCTAxZHZhtO9Ll397opaMxtZwThboa+C2O8ZFCyZO
         3yO7BFlQAHn+yHQOjTkSFxrGQT55I8zRk+ACqC8mUlAGEgaJBYVxdtDOeJYvRXY7OjD1
         qoTqm7lymwBPWk5HvlxgcsMnJSmrWwc/CDEf5vU234aNsYZC/feumKaSOaVQM1oeg2rp
         5mn5icPj2L2oVd+okglM+aUogVgHmTvRe+DoweL0N0v4d2/lpxJ7oBj1ZuDkqyJtw+x2
         MyX0f8gzheaFJLMAEkWsyGR+2G8QUbr85wv/70bydcasoZ+1oXcDIR0JEbGlmuon6m7C
         zqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CkdZTgPQtli4HqKjoybGJC69i/K2eo+/Y/ueOVTU/uQ=;
        b=rECYtMBl98jeuXVZQ1EzyLNy96WfWA+Y0GZoF1432QFP16st+M0JSEHVYDqSFi4u4N
         RzHR+Q8jRfj4AgMcaZKVO4/3WI6i8YXTGg/SdbVSYJx/yMyzzzGyU6bx0OjQ8aJILEx+
         n7mrEoysrui4PWJNWx6JDV4MM8VtzajFjSndieryKF8SgDCkJj5mIdD8APUVicz+EcB/
         0bVmdQKopyUx6urNdopJtn6sXSoGsqeTdMlGu0Qq1ClFzm1Z+oMKXj5E2W7qdP27bKk2
         +BIuu070c+PTiukQeuupCqrH+7g/LOvCFuUo5+LPIi0MryFRaR8d9WkcAAgm7qeF9aHj
         DrxQ==
X-Gm-Message-State: AOAM5327aLyCqjA94mbwImSYQv5haSM47XDrzPVWvDj+C2ddHiN9qQ+N
	l9/2id9mQP5qU5KRQZXb1yG/aQ==
X-Google-Smtp-Source: ABdhPJzgkkNJGQRPeFg7lZtu3UZBjQBkf2nGy3Om/c9n+Dj7KFkAAjDpg1xpd04kYgbe9qjhwsW3RQ==
X-Received: by 2002:a17:902:82c1:: with SMTP id u1mr6062512plz.38.1599750430560;
        Thu, 10 Sep 2020 08:07:10 -0700 (PDT)
Date: Thu, 10 Sep 2020 08:07:04 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 15/28] init: lto: ensure initcall ordering
Message-ID: <20200910150704.GA2041735@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-16-samitolvanen@google.com>
 <5f45f55340cf54f5506a50adf61e49b27b904322.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f45f55340cf54f5506a50adf61e49b27b904322.camel@infradead.org>

On Thu, Sep 10, 2020 at 10:25:40AM +0100, David Woodhouse wrote:
> On Thu, 2020-09-03 at 13:30 -0700, Sami Tolvanen wrote:
> > With LTO, the compiler doesn't necessarily obey the link order for
> > initcalls, and initcall variables need globally unique names to avoid
> > collisions at link time.
> > 
> > This change exports __KBUILD_MODNAME and adds the initcall_id() macro,
> > which uses it together with __COUNTER__ and __LINE__ to help ensure
> > these variables have unique names, and moves each variable to its own
> > section when LTO is enabled, so the correct order can be specified using
> > a linker script.
> > 
> > The generate_initcall_ordering.pl script uses nm to find initcalls from
> > the object files passed to the linker, and generates a linker script
> > that specifies the intended order. With LTO, the script is called in
> > link-vmlinux.sh.
> 
> Is this guaranteed to give you the *same* initcall ordering with LTO as
> without?

Yes. It follows the link order, just like the linker without LTO, and
also preserves the order within each file.

Sami
