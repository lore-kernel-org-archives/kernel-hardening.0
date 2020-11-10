Return-Path: <SRS0=prEd=EQ=lists.openwall.com=kernel-hardening-return-20373-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883B6C388F7
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 03:19:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6AEDC206A4
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 03:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XsFFeqcH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AEDC206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20373-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5734 invoked by uid 550); 10 Nov 2020 03:19:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5706 invoked from network); 10 Nov 2020 03:19:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=27ykW6WMBpdjPMmYk+TEkpv4ofG2LVLk39veK8STtAM=;
        b=XsFFeqcHcwErTDab8bcJJxnRZmdrfwAAmAxnX+0//0jp/RkNoXCmKM8hfyW7U5g8YY
         wehgfKm1eruNJkdwnQxX/6RNlrNe6CP3uC9uMuIcChKg7gmdAwILZVQXBK3QxQME/vGY
         n9bBZbqKsp3rUj7gjL3n2idnQJIzZFT2jQDMtCEsHtuxaEBlgAGdozKhGraOM+DNtPKU
         1TYIu8MdisQa5tafuex26ZLInGgdddCQESLcztFd9caJZ9PszasLRkfq4/Txf1N1n6Z0
         s8KzSi9dTkyd/sKQMAPCsqQUdj936ITZXkP6f+AREgqbuvxOMRr0Qudq4LaTJaYBzxn8
         l8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=27ykW6WMBpdjPMmYk+TEkpv4ofG2LVLk39veK8STtAM=;
        b=ZveqMjyXk/GE97LoWlgU3Ov9P1nT0AR2OrdkyR8heZ6MY9YCrEOfUHPSzYHlSqs94A
         3fw8Ksb71k8ZGXslPO6uImYonAHr67tpXgIqqhgF59vRjmbKkyWef7ZQ4cvUNPRkZnbu
         2auxWWNGHHZ8SBbhHKN1o/+0lTIWd+x3IjXezjVZAiHTmc2QVXJ38KjonDlTu/SoyOIT
         lpgyWeMbH9kOWT3KXBDmweviKrcU1IdskzIKKDcFiDZFbXmb6YGY1Kv+vpI+cRdihNh9
         3XjNt2Ki67iPZHjvu5drgDA+yQbPb3fmS1u5NAGwM+D4XuoR/QX0k7jtmRFFKSqSRRhs
         BYzQ==
X-Gm-Message-State: AOAM533M6ktpgkG5ftiukVUhkyzb7ddW3FAMhrMAo3Fl+bwHBKBSCzQy
	DVr8mJ47IkVgSMK42lcgr+UdeIIEzD/lHqjBmvRGeA==
X-Google-Smtp-Source: ABdhPJw1gHS3sV2n+GuuNrA63YxT/QiulRGIL8Dn09J7EAZtkgIEcv7I2sFS4tI7OV3X2dr4+8t654iME8/HuHneKZ4=
X-Received: by 2002:a17:90a:4881:: with SMTP id b1mr2684359pjh.32.1604978345526;
 Mon, 09 Nov 2020 19:19:05 -0800 (PST)
MIME-Version: 1.0
References: <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net> <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble> <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net> <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
 <20201023173617.GA3021099@google.com> <CABCJKuee7hUQSiksdRMYNNx05bW7pWaDm4fQ__znGQ99z9-dEw@mail.gmail.com>
 <20201110022924.tekltjo25wtrao7z@treble>
In-Reply-To: <20201110022924.tekltjo25wtrao7z@treble>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 9 Nov 2020 19:18:54 -0800
Message-ID: <CAKwvOdnO2tZRcB69yJ+FTj+qGpzCasxecCPQ0c5G9Wwn6Wd12w@mail.gmail.com>
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	Jann Horn <jannh@google.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 9, 2020 at 6:29 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> Also, any details on how to build clang would be appreciated, it's been
> a while since I tried.

$ git clone https://github.com/llvm/llvm-project.git --depth 1
$ mkdir llvm-project/llvm/build
$ cd !$
$ cmake .. -DCMAKE_BUILD_TYPE=Release -G Ninja
-DLLVM_ENABLE_PROJECTS="clang;lld;compiler-rt"
$ ninja
$ export PATH=$(pwd)/bin:$PATH
$ clang --version
-- 
Thanks,
~Nick Desaulniers
