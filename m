Return-Path: <SRS0=uz0/=EQ=lists.openwall.com=kernel-hardening-return-20374-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF10C388F7
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 04:48:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ED9B4206D8
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 04:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="efHLQUtV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED9B4206D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20374-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11944 invoked by uid 550); 10 Nov 2020 04:48:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11924 invoked from network); 10 Nov 2020 04:48:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1LG6AI05ymINBvkr43QJrWhW6+Oh0OuOMO1LRwJumoQ=;
        b=efHLQUtVvktbFbKV0dRhcMiDZ6CiF/nI8yogKkQkXNzkMFEKE5odhT1f13Q4gPJXAu
         wN0hB9BkQq58Ja7rNMPt1NZVdynEexfdbYBnP6P1V9zpSI+DJlZlVHIYRtDLOuDybsKK
         SBxayzR/8WM3Q2prP7nQi2dCRyo/MR20sOg6N/LmD6SDjillgAvfoYjFLd2lgcKBMzWH
         STTrkAhehecfpfomXSDFfie9rZLcKj9V2nN+Xx5m1srFv2/b/ayMzlhJB+vG6YJrW6md
         +YUyQc+RbXeRLi4+1JZo48a5U5H0fYHqd3kOi7vj283pPMdGH774liDFv7DcOCzqsBmW
         a6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1LG6AI05ymINBvkr43QJrWhW6+Oh0OuOMO1LRwJumoQ=;
        b=linHyvuBxrrJCpY1eAfD7xofLOtg8tsIAv5c6WT34ZL1ayaShQ8trCNPzoC651yVA9
         KQH7SQ2DFDhtYvd/IHGTclqZtp6ZHmryU1+LX+pgclCgGj7O9kTDA/e6LhkaZXINVtKb
         JpnugIFRxEFPyyOtRxHpzMNPSCCptsN+8YcK3jEBOw/vw4i6r7hHFucPiT/NE7wlHFOo
         R0Ydn54gRG1cOn+G0AVliTSp7LnFWq76U7jnZvYE1853m29p5GRd7WzXWrPI/9mjDHDG
         z22keIUNEpKSoku0KM9rH5ZQ2Ljcon7tUicYICaVHAZXvQ1ZWvIRZY0rViBkshMvY2A/
         qKwg==
X-Gm-Message-State: AOAM532JXH6wP2VbjMGya+ur3Sg7YyrBJHDN5FMRnl//jF3VVlaHbNWu
	VxKpU21WWfi3/GgXyXZQMDAhy3pFIosUUBdHqKzJlw==
X-Google-Smtp-Source: ABdhPJxkDi0IYzwTD9/NuW8drJgZEjV2OxRwIJgfYZxoJw/2It4YGoA7cCSoDZ10V3gQPihhY7p+XtZ3gEYyqR4paw4=
X-Received: by 2002:ab0:424:: with SMTP id 33mr8354135uav.33.1604983692991;
 Mon, 09 Nov 2020 20:48:12 -0800 (PST)
MIME-Version: 1.0
References: <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net> <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble> <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net> <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
 <20201023173617.GA3021099@google.com> <CABCJKuee7hUQSiksdRMYNNx05bW7pWaDm4fQ__znGQ99z9-dEw@mail.gmail.com>
 <20201110022924.tekltjo25wtrao7z@treble>
In-Reply-To: <20201110022924.tekltjo25wtrao7z@treble>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 9 Nov 2020 20:48:01 -0800
Message-ID: <CABCJKuc_-Sxj8HLajx4pKuBpU3AUdBtPv4uzQfMWqVHWwHS1iQ@mail.gmail.com>
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 9, 2020 at 6:29 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> How would I recreate all these warnings?

You can reproduce all of these using a normal gcc build without any of
the LTO patches by running objtool check -arfld vmlinux.o. However,
with gcc you'll see even more warnings due to duplicate symbol names,
as Peter pointed out elsewhere in the thread, so I looked at only the
warnings that objtool also prints with LTO.

Note that the LTO series contains a patch to split noinstr validation
from --vmlinux, as we need to run objtool here even if
CONFIG_VMLINUX_VALIDATION isn't selected, so I have not looked at the
noinstr warnings. The latest LTO tree is available here:

https://github.com/samitolvanen/linux/commits/clang-lto

> Here's the patch for hopefully making the warnings more helpful:

Thanks, I'll give it a try.

Sami
