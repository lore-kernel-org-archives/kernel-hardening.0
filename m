Return-Path: <SRS0=7zBK=ET=lists.openwall.com=kernel-hardening-return-20396-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48EEC55ABD
	for <kernel-hardening@archiver.kernel.org>; Fri, 13 Nov 2020 20:52:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ADBA82224F
	for <kernel-hardening@archiver.kernel.org>; Fri, 13 Nov 2020 20:52:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vja5qVPN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADBA82224F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20396-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13588 invoked by uid 550); 13 Nov 2020 20:52:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13568 invoked from network); 13 Nov 2020 20:52:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605300754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BjbZK0zeIm65whn17k5UcYS2uZ9Kdra7izOdoHD5fpw=;
	b=Vja5qVPNIORDTOqSTqSA1jcAlfT/9vrn5afRTuLTV2O+YzVDYdQDkZoL37/6A1pzb93pSt
	eb+daRvz6lU/tMbAKzxYhO8jb90f8eR6wDYa+ixONXQWp9/6C6CtIDgp0SGNW3th3CrTwM
	yiZn5KPlfqSCzNaHzf+p9LDCBY+kRcM=
X-MC-Unique: 6NjMwWGtNSa0dWipx0MBdw-1
Date: Fri, 13 Nov 2020 14:52:21 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
Message-ID: <20201113205221.jybsu3himgjqd3tq@treble>
References: <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
 <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
 <20201023173617.GA3021099@google.com>
 <CABCJKuee7hUQSiksdRMYNNx05bW7pWaDm4fQ__znGQ99z9-dEw@mail.gmail.com>
 <20201110022924.tekltjo25wtrao7z@treble>
 <20201110174606.mp5m33lgqksks4mt@treble>
 <CABCJKuf+Ev=hpCUfDpCFR_wBACr-539opJsSFrDcpDA9Ctp7rg@mail.gmail.com>
 <20201113195408.atbpjizijnhuinzy@treble>
 <CABCJKufA-aOcsOqb1NiMQeBGm9Q-JxjoPjsuNpHh0kL4LzfO0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABCJKufA-aOcsOqb1NiMQeBGm9Q-JxjoPjsuNpHh0kL4LzfO0w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

On Fri, Nov 13, 2020 at 12:24:32PM -0800, Sami Tolvanen wrote:
> On Fri, Nov 13, 2020 at 11:54 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >
> > On Tue, Nov 10, 2020 at 10:59:55AM -0800, Sami Tolvanen wrote:
> > > On Tue, Nov 10, 2020 at 9:46 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > >
> > > > On Mon, Nov 09, 2020 at 08:29:24PM -0600, Josh Poimboeuf wrote:
> > > > > On Mon, Nov 09, 2020 at 03:11:41PM -0800, Sami Tolvanen wrote:
> > > > > > CONFIG_XEN
> > > > > >
> > > > > > __switch_to_asm()+0x0: undefined stack state
> > > > > >   xen_hypercall_set_trap_table()+0x0: <=== (sym)
> > > >
> > > > With your branch + GCC 9 I can recreate all the warnings except this
> > > > one.
> > >
> > > In a gcc build this warning is replaced with a different one:
> > >
> > > vmlinux.o: warning: objtool: __startup_secondary_64()+0x7: return with
> > > modified stack frame
> > >
> > > This just seems to depend on which function is placed right after the
> > > code in xen-head.S. With gcc, the disassembly looks like this:
> > >
> > > 0000000000000000 <asm_cpu_bringup_and_idle>:
> > >        0:       e8 00 00 00 00          callq  5 <asm_cpu_bringup_and_idle+0x5>
> > >                         1: R_X86_64_PLT32       cpu_bringup_and_idle-0x4
> > >        5:       e9 f6 0f 00 00          jmpq   1000
> > > <xen_hypercall_set_trap_table>
> > > ...
> > > 0000000000001000 <xen_hypercall_set_trap_table>:
> > >         ...
> > > ...
> > > 0000000000002000 <__startup_secondary_64>:
> > >
> > > With Clang+LTO, we end up with __switch_to_asm here instead of
> > > __startup_secondary_64.
> >
> > I still don't see this warning for some reason.
> 
> Do you have CONFIG_XEN enabled? I can reproduce this on ToT master as follows:
> 
> $ git rev-parse HEAD
> 585e5b17b92dead8a3aca4e3c9876fbca5f7e0ba
> $ make defconfig && \
> ./scripts/config -e HYPERVISOR_GUEST -e PARAVIRT -e XEN && \
> make olddefconfig && \
> make -j110
> ...
> $ ./tools/objtool/objtool check -arfld vmlinux.o 2>&1 | grep secondary
> vmlinux.o: warning: objtool: __startup_secondary_64()+0x2: return with
> modified stack frame

Ok, I see it now on Linus' tree.  I just didn't see it on your clang-lto
branch.

-- 
Josh

