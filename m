Return-Path: <SRS0=ahYd=E2=lists.openwall.com=kernel-hardening-return-20429-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C92C5519F
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 04:04:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F241E22365
	for <kernel-hardening@archiver.kernel.org>; Fri, 20 Nov 2020 04:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QAJ7dC+j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F241E22365
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20429-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22183 invoked by uid 550); 20 Nov 2020 04:04:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22163 invoked from network); 20 Nov 2020 04:04:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605845077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o2KUuc5wwsBwxaFKsqE+AT6g8ZgQDPHa1BC4D1RcHko=;
	b=QAJ7dC+jIYsdyzBghu3FHiqv+OL8V9WfweQXvabDm0BuyD2fUVodeXv9ZSzivR3XgbNV/9
	zHJUJxTdFwFOenytSIrWixG0LeCLX+vakVbyd9H9RKRHaz7jpzN0vIdQ84bnrJGoWlABzE
	7UQhpSn87Kq+F1ruZxfdoTXRYHzCfsc=
X-MC-Unique: yDf3VGw1POqCQOhtPJpkwQ-1
Date: Thu, 19 Nov 2020 22:04:24 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
Message-ID: <20201120040424.a3wctajzft4ufoiw@treble>
References: <20201118220731.925424-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23

On Wed, Nov 18, 2020 at 02:07:14PM -0800, Sami Tolvanen wrote:
> This patch series adds support for building the kernel with Clang's
> Link Time Optimization (LTO). In addition to performance, the primary
> motivation for LTO is to allow Clang's Control-Flow Integrity (CFI) to
> be used in the kernel. Google has shipped millions of Pixel devices
> running three major kernel versions with LTO+CFI since 2018.
> 
> Most of the patches are build system changes for handling LLVM bitcode,
> which Clang produces with LTO instead of ELF object files, postponing
> ELF processing until a later stage, and ensuring initcall ordering.
> 
> Note that v7 brings back arm64 support as Will has now staged the
> prerequisite memory ordering patches [1], and drops x86_64 while we work
> on fixing the remaining objtool warnings [2].

Sami,

Here are some patches to fix the objtool issues (other than crypto which
I'll work on next).

  https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git objtool-vmlinux

-- 
Josh

