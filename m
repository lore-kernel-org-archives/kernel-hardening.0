Return-Path: <SRS0=sZzX=AR=lists.openwall.com=kernel-hardening-return-19222-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0063C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Jul 2020 19:40:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5020A20702
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Jul 2020 19:40:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BeTQRyoG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5020A20702
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19222-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17437 invoked by uid 550); 6 Jul 2020 19:40:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16381 invoked from network); 6 Jul 2020 19:40:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fga2epNTXBelXbYkbTxROQdchUloEASZKoCcJ/iKrWw=; b=BeTQRyoGVX7klkBfy71IhIii42
	JLJVPvYdGVws5AyPO2wATPQh812LcOHjFg8RqbL8QgCaxHK+B103YXboryKFzbnforwfw09tNatE9
	Ijvwo8PiAqBc+pqw5sDe87w5LOI2SYN6KwrLb1mF4UNVYiAxzyYRJj/nUVEy5N9Th6O/tYCF8VpZV
	yC2XlC+u2k195dE9l9ZVM2DO+equSQoon5zhP1iEjupkjTXqD4be/tJ9YsR2I1ClBCDJd+yYpIZXF
	Q6+cIuj+PAzHD6t30ZZbYPyuTxPG3nfJprRPcGf3KxUTK93dlpHy3vdg6mTpTVbfsaduXM8c65F50
	6jIUEBlQ==;
Date: Mon, 6 Jul 2020 21:40:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Marco Elver <elver@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200706194012.GA5523@worktop.programming.kicks-ass.net>
References: <20200701140654.GL9247@paulmck-ThinkPad-P72>
 <20200701150512.GH4817@hirez.programming.kicks-ass.net>
 <20200701160338.GN9247@paulmck-ThinkPad-P72>
 <20200702082040.GB4781@hirez.programming.kicks-ass.net>
 <20200702175948.GV9247@paulmck-ThinkPad-P72>
 <20200703131330.GX4800@hirez.programming.kicks-ass.net>
 <20200703144228.GF9247@paulmck-ThinkPad-P72>
 <20200706162633.GA13288@paulmck-ThinkPad-P72>
 <20200706182926.GH4800@hirez.programming.kicks-ass.net>
 <20200706183933.GE9247@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706183933.GE9247@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 06, 2020 at 11:39:33AM -0700, Paul E. McKenney wrote:
> On Mon, Jul 06, 2020 at 08:29:26PM +0200, Peter Zijlstra wrote:
> > On Mon, Jul 06, 2020 at 09:26:33AM -0700, Paul E. McKenney wrote:

> > If they do not consider their Linux OS running correctly :-)
> 
> Many of them really do not care at all.  In fact, some would consider
> Linux failing to run as an added bonus.

This I think is why we have compiler people in the thread that care a
lot more.

> > > Nevertheless, yes, control dependencies also need attention.
> > 
> > Today I added one more \o/
> 
> Just make sure you continually check to make sure that compilers
> don't break it, along with the others you have added.  ;-)

There's:

kernel/locking/mcs_spinlock.h:  smp_cond_load_acquire(l, VAL);                          \
kernel/sched/core.c:                    smp_cond_load_acquire(&p->on_cpu, !VAL);
kernel/smp.c:   smp_cond_load_acquire(&csd->node.u_flags, !(VAL & CSD_FLAG_LOCK));

arch/x86/kernel/alternative.c:          atomic_cond_read_acquire(&desc.refs, !VAL);
kernel/locking/qrwlock.c:               atomic_cond_read_acquire(&lock->cnts, !(VAL & _QW_LOCKED));
kernel/locking/qrwlock.c:       atomic_cond_read_acquire(&lock->cnts, !(VAL & _QW_LOCKED));
kernel/locking/qrwlock.c:               atomic_cond_read_acquire(&lock->cnts, VAL == _QW_WAITING);
kernel/locking/qspinlock.c:             atomic_cond_read_acquire(&lock->val, !(VAL & _Q_LOCKED_MASK));
kernel/locking/qspinlock.c:     val = atomic_cond_read_acquire(&lock->val, !(VAL & _Q_LOCKED_PENDING_MASK));

include/linux/refcount.h:               smp_acquire__after_ctrl_dep();
ipc/mqueue.c:                   smp_acquire__after_ctrl_dep();
ipc/msg.c:                      smp_acquire__after_ctrl_dep();
ipc/sem.c:                      smp_acquire__after_ctrl_dep();
kernel/locking/rwsem.c:                 smp_acquire__after_ctrl_dep();
kernel/sched/core.c:    smp_acquire__after_ctrl_dep();

kernel/events/ring_buffer.c:__perf_output_begin()

And I'm fairly sure I'm forgetting some... One could argue there's too
many of them to check already.

Both GCC and CLANG had better think about it.
