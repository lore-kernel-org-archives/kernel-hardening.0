Return-Path: <SRS0=hW59=GM=lists.openwall.com=kernel-hardening-return-20619-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB9CC433DB
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 16:33:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 42777227C3
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 16:33:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42777227C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20619-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19742 invoked by uid 550); 9 Jan 2021 16:33:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19719 invoked from network); 9 Jan 2021 16:33:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610209986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N4LWfpJc6jpinLV5977gRkGzupeL+O5/UzxgtGo5uQo=;
	b=bcEnqCVPqo2Chj6Zz1vfHrLCQNoe7blFrsniT4viER7huwOlTQ3UeKqum8EJQbh8Sqx15T
	BJ0qCQYivI0Mo0Fcut/SMx/j4iaweoeXVNk7/yCG59vYHywLpVuceTe+RyDS/Wn4k8Fm9E
	GGZwu488eUA/4scywF9pY0jg13vcspg=
X-MC-Unique: rKKz2IqhPGaW8lF3ScipBQ-1
Date: Sat, 9 Jan 2021 10:32:56 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v9 00/16] Add support for Clang LTO
Message-ID: <20210109163256.3sv3wbgrshbj72ik@treble>
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <CA+icZUWYxO1hHW-_vrJid7EstqQRYQphjO3Xn6pj6qfEYEONbA@mail.gmail.com>
 <20210109153646.zrmglpvr27f5zd7m@treble>
 <CA+icZUUiucbsQZtJKYdD7Y7Cq8hJZdBwsF0U0BFbaBtnLY3Nsw@mail.gmail.com>
 <20210109160709.kqqpf64klflajarl@treble>
 <CA+icZUU=sS2xfzo9qTUTPQ0prbbQcj29tpDt1qK5cYZxarXuxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+icZUU=sS2xfzo9qTUTPQ0prbbQcj29tpDt1qK5cYZxarXuxg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

> > > Did you push it (oh ah push it push it really really really good...)
> > > to your remote Git please :-).
> >
> > I thought I already pushed it pretty good ;-) do you not see it?
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git objtool-vmlinux
> >
> > d6baee244f2d — objtool: Alphabetize usage option list (3 weeks ago)
> > c0b2a6a625ac — objtool: Separate vmlinux/noinstr validation config options (3 weeks ago)
> > 84c53551ad17 — objtool: Enable full vmlinux validation (3 weeks ago)
> > e518ac0801cd — x86/power: Support objtool validation in hibernate_asm_64.S (3 weeks ago)
> > d0ac4c7301c1 — x86/power: Move restore_registers() to top of the file (3 weeks ago)
> > d3389bc83538 — x86/power: Convert indirect jumps to retpolines (3 weeks ago)
> > 7a974d90aa40 — x86/acpi: Support objtool validation in wakeup_64.S (3 weeks ago)
> > 6693e26cd6cc — x86/acpi: Convert indirect jump to retpoline (3 weeks ago)
> > 0dfb760c74d1 — x86/ftrace: Support objtool vmlinux.o validation in ftrace_64.S (3 weeks ago)
> > 89a4febfd7bf — x86/xen/pvh: Convert indirect jump to retpoline (3 weeks ago)
> > b62837092140 — x86/xen: Support objtool vmlinux.o validation in xen-head.S (3 weeks ago)
> > 705e18481ed9 — x86/xen: Support objtool validation in xen-asm.S (3 weeks ago)
> > 3548319e21b9 — objtool: Add xen_start_kernel() to noreturn list (3 weeks ago)
> > 6016e8da8c3d — objtool: Combine UNWIND_HINT_RET_OFFSET and UNWIND_HINT_FUNC (3 weeks ago)
> > 56d6a7aee8b1 — objtool: Add asm version of STACK_FRAME_NON_STANDARD (3 weeks ago)
> > 68259d951f1a — objtool: Assume only ELF functions do sibling calls (3 weeks ago)
> > 0d6c8816cf91 — x86/ftrace: Add UNWIND_HINT_FUNC annotation for ftrace_stub (3 weeks ago)
> > 24d6ce8cd8f6 — objtool: Support retpoline jump detection for vmlinux.o (3 weeks ago)
> > 8145ea268f16 — objtool: Fix ".cold" section suffix check for newer versions of GCC (3 weeks ago)
> > b3dfca472514 — objtool: Fix retpoline detection in asm code (3 weeks ago)
> > b82402fa5211 — objtool: Fix error handling for STD/CLD warnings (3 weeks ago)
> > 1f02defb4b79 — objtool: Fix seg fault in BT_FUNC() with fake jump (3 weeks ago)
> > 2c85ebc57b3e — Linux 5.10 (4 weeks ago)
> >
> 
> I already have this one in my patch-series - I hoped you pushed
> something new to your objtool-vmlinux Git branch.
> That is what I mean by shortened... <jpoimboe.git#objtool-vmlinux>.
> 
> Hey, it's based on Linux v5.10 - I can test this with Linux v5.10.6 :-).

This is the most recent version of the patches.  I only pushed them this
morning since you said the prior version wasn't applying on Sami's
clang-cfi branch.  This version rebases fine on 'clang-cfi'.

-- 
Josh

