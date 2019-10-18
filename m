Return-Path: <SRS0=Nhbb=YL=lists.openwall.com=kernel-hardening-return-17044-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A99CA9EA9
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:23:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9EA2621897
	for <kernel-hardening@archiver.kernel.org>; Fri, 18 Oct 2019 17:23:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9EA2621897
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17044-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28159 invoked by uid 550); 18 Oct 2019 17:23:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28141 invoked from network); 18 Oct 2019 17:23:45 -0000
Date: Fri, 18 Oct 2019 18:23:09 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Jann Horn <jannh@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel@lists.infradead.org,
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/18] arm64: implement Shadow Call Stack
Message-ID: <20191018172309.GB18838@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-19-samitolvanen@google.com>
 <CAG48ez2Z8=0__eoQ+Ekp=EApawZXR4ec_xd2TVPQExLoyMwtRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2Z8=0__eoQ+Ekp=EApawZXR4ec_xd2TVPQExLoyMwtRQ@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Fri, Oct 18, 2019 at 07:12:52PM +0200, Jann Horn wrote:
> On Fri, Oct 18, 2019 at 6:16 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> > This change implements shadow stack switching, initial SCS set-up,
> > and interrupt shadow stacks for arm64.
> [...]
> > +static inline void scs_save(struct task_struct *tsk)
> > +{
> > +       void *s;
> > +
> > +       asm volatile("mov %0, x18" : "=r" (s));
> > +       task_set_scs(tsk, s);
> > +}
> > +
> > +static inline void scs_load(struct task_struct *tsk)
> > +{
> > +       asm volatile("mov x18, %0" : : "r" (task_scs(tsk)));
> > +       task_set_scs(tsk, NULL);
> > +}
> 
> These things should probably be __always_inline or something like
> that? If the compiler decides not to inline them (e.g. when called
> from scs_thread_switch()), stuff will blow up, right?

I think scs_save() would better live in assembly in cpu_switch_to(),
where we switch the stack and current. It shouldn't matter whether
scs_load() is inlined or not, since the x18 value _should_ be invariant
from the PoV of the task.

We just need to add a TSK_TI_SCS to asm-offsets.c, and then insert a
single LDR at the end:

	mov	sp, x9
	msr	sp_el0, x1
#ifdef CONFIG_SHADOW_CALL_STACK
	ldr	x18, [x1, TSK_TI_SCS]
#endif
	ret

Thanks,
Mark.
