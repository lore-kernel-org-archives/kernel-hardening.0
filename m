Return-Path: <SRS0=GTVj=GM=lists.openwall.com=kernel-hardening-return-20617-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 703E7C433DB
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 16:07:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 814AB23A04
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 16:07:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 814AB23A04
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20617-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8015 invoked by uid 550); 9 Jan 2021 16:07:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7995 invoked from network); 9 Jan 2021 16:07:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1610208448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/4tZTudWMHL9XHsahjxKGAOBjt0qYTZ11jrT8O8TLnA=;
	b=aDE2r7+Yko7OcKgq832KjC+4bSKckr5S2XeNUktMywHpMq4J3uegw6B0wNaVT+Y91RCpEf
	jbnwih1pbd50S4mRaMnPTYs0Ehfiiw1tPs/BQ9FE/3OTCdthGZTB45NH/1Y+6co0Xt1CFY
	MBLDay0BZmiXRBt79qRoonkH5SK87xs=
X-MC-Unique: ZQW85TisMNyB3WjeOrGOXw-1
Date: Sat, 9 Jan 2021 10:07:09 -0600
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
Message-ID: <20210109160709.kqqpf64klflajarl@treble>
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <CA+icZUWYxO1hHW-_vrJid7EstqQRYQphjO3Xn6pj6qfEYEONbA@mail.gmail.com>
 <20210109153646.zrmglpvr27f5zd7m@treble>
 <CA+icZUUiucbsQZtJKYdD7Y7Cq8hJZdBwsF0U0BFbaBtnLY3Nsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+icZUUiucbsQZtJKYdD7Y7Cq8hJZdBwsF0U0BFbaBtnLY3Nsw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22

On Sat, Jan 09, 2021 at 04:46:21PM +0100, Sedat Dilek wrote:
> On Sat, Jan 9, 2021 at 4:36 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >
> > On Sat, Jan 09, 2021 at 03:54:20PM +0100, Sedat Dilek wrote:
> > > I am interested in having Clang LTO (Clang-CFI) for x86-64 working and
> > > help with testing.
> > >
> > > I tried the Git tree mentioned in [3] <jpoimboe.git#objtool-vmlinux>
> > > (together with changes from <peterz.git#x86/urgent>).
> > >
> > > I only see in my build-log...
> > >
> > > drivers/gpu/drm/i915/gem/i915_gem_execbuffer.o: warning: objtool:
> > > eb_relocate_parse_slow()+0x3d0: stack state mismatch: cfa1=7+120
> > > cfa2=-1+0
> > > drivers/gpu/drm/i915/gem/i915_gem_execbuffer.o: warning: objtool:
> > > eb_copy_relocations()+0x229: stack state mismatch: cfa1=7+120
> > > cfa2=-1+0
> > >
> > > ...which was reported and worked on in [1].
> > >
> > > This is with Clang-IAS version 11.0.1.
> > >
> > > Unfortunately, the recent changes in <samitolvanen.github#clang-cfi>
> > > do not cleanly apply with Josh stuff.
> > > My intention/wish was to report this combination of patchsets "heals"
> > > a lot of objtool-warnings for vmlinux.o I observed with Clang-CFI.
> > >
> > > Is it possible to have a Git branch where Josh's objtool-vmlinux is
> > > working together with Clang-LTO?
> > > For testing purposes.
> >
> > I updated my branch with my most recent work from before the holidays,
> > can you try it now?  It still doesn't fix any of the crypto warnings,
> > but I'll do that in a separate set after posting these next week.
> >
> 
> Thanks, Josh.
> 
> Did you push it (oh ah push it push it really really really good...)
> to your remote Git please :-).

I thought I already pushed it pretty good ;-) do you not see it?

git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git objtool-vmlinux

d6baee244f2d — objtool: Alphabetize usage option list (3 weeks ago)
c0b2a6a625ac — objtool: Separate vmlinux/noinstr validation config options (3 weeks ago)
84c53551ad17 — objtool: Enable full vmlinux validation (3 weeks ago)
e518ac0801cd — x86/power: Support objtool validation in hibernate_asm_64.S (3 weeks ago)
d0ac4c7301c1 — x86/power: Move restore_registers() to top of the file (3 weeks ago)
d3389bc83538 — x86/power: Convert indirect jumps to retpolines (3 weeks ago)
7a974d90aa40 — x86/acpi: Support objtool validation in wakeup_64.S (3 weeks ago)
6693e26cd6cc — x86/acpi: Convert indirect jump to retpoline (3 weeks ago)
0dfb760c74d1 — x86/ftrace: Support objtool vmlinux.o validation in ftrace_64.S (3 weeks ago)
89a4febfd7bf — x86/xen/pvh: Convert indirect jump to retpoline (3 weeks ago)
b62837092140 — x86/xen: Support objtool vmlinux.o validation in xen-head.S (3 weeks ago)
705e18481ed9 — x86/xen: Support objtool validation in xen-asm.S (3 weeks ago)
3548319e21b9 — objtool: Add xen_start_kernel() to noreturn list (3 weeks ago)
6016e8da8c3d — objtool: Combine UNWIND_HINT_RET_OFFSET and UNWIND_HINT_FUNC (3 weeks ago)
56d6a7aee8b1 — objtool: Add asm version of STACK_FRAME_NON_STANDARD (3 weeks ago)
68259d951f1a — objtool: Assume only ELF functions do sibling calls (3 weeks ago)
0d6c8816cf91 — x86/ftrace: Add UNWIND_HINT_FUNC annotation for ftrace_stub (3 weeks ago)
24d6ce8cd8f6 — objtool: Support retpoline jump detection for vmlinux.o (3 weeks ago)
8145ea268f16 — objtool: Fix ".cold" section suffix check for newer versions of GCC (3 weeks ago)
b3dfca472514 — objtool: Fix retpoline detection in asm code (3 weeks ago)
b82402fa5211 — objtool: Fix error handling for STD/CLD warnings (3 weeks ago)
1f02defb4b79 — objtool: Fix seg fault in BT_FUNC() with fake jump (3 weeks ago)
2c85ebc57b3e — Linux 5.10 (4 weeks ago)

-- 
Josh

