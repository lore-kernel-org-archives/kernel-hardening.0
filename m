Return-Path: <SRS0=gYmX=GM=lists.openwall.com=kernel-hardening-return-20615-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B572BC433DB
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 15:37:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B9B7B23372
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 15:37:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9B7B23372
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20615-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20016 invoked by uid 550); 9 Jan 2021 15:37:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19996 invoked from network); 9 Jan 2021 15:37:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610206617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a2MU/nqWLE/JGSkdP0kIS5IkD9QMgYVvccKJFswQ5ZI=;
	b=E5KysLLKcEamZKCdr7Y6Grs8uHCajHaDkzYE2hvFw7EfTRkdZoAotlz8GFHNT6ga2NI6jH
	ihWAEEcIKOpg+nQ/D048+nYyhc6d9r7+KNpE0CtXagzakinsSmlrD4eFcC1dXHfhrKkJgB
	RHjmjN9nSa/f+OgUvk1gC1Kse+oLOHw=
X-MC-Unique: VeFGfpw6MSCN1ixeCjF0BQ-1
Date: Sat, 9 Jan 2021 09:36:46 -0600
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
Message-ID: <20210109153646.zrmglpvr27f5zd7m@treble>
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <CA+icZUWYxO1hHW-_vrJid7EstqQRYQphjO3Xn6pj6qfEYEONbA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+icZUWYxO1hHW-_vrJid7EstqQRYQphjO3Xn6pj6qfEYEONbA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

On Sat, Jan 09, 2021 at 03:54:20PM +0100, Sedat Dilek wrote:
> I am interested in having Clang LTO (Clang-CFI) for x86-64 working and
> help with testing.
> 
> I tried the Git tree mentioned in [3] <jpoimboe.git#objtool-vmlinux>
> (together with changes from <peterz.git#x86/urgent>).
> 
> I only see in my build-log...
> 
> drivers/gpu/drm/i915/gem/i915_gem_execbuffer.o: warning: objtool:
> eb_relocate_parse_slow()+0x3d0: stack state mismatch: cfa1=7+120
> cfa2=-1+0
> drivers/gpu/drm/i915/gem/i915_gem_execbuffer.o: warning: objtool:
> eb_copy_relocations()+0x229: stack state mismatch: cfa1=7+120
> cfa2=-1+0
> 
> ...which was reported and worked on in [1].
> 
> This is with Clang-IAS version 11.0.1.
> 
> Unfortunately, the recent changes in <samitolvanen.github#clang-cfi>
> do not cleanly apply with Josh stuff.
> My intention/wish was to report this combination of patchsets "heals"
> a lot of objtool-warnings for vmlinux.o I observed with Clang-CFI.
> 
> Is it possible to have a Git branch where Josh's objtool-vmlinux is
> working together with Clang-LTO?
> For testing purposes.

I updated my branch with my most recent work from before the holidays,
can you try it now?  It still doesn't fix any of the crypto warnings,
but I'll do that in a separate set after posting these next week.

-- 
Josh

