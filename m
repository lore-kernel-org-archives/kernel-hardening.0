Return-Path: <SRS0=AE7/=D4=lists.openwall.com=kernel-hardening-return-20240-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E275C4363A
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 09:32:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E86B121D6C
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 09:32:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Lre+lL+7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E86B121D6C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20240-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26112 invoked by uid 550); 21 Oct 2020 09:32:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26092 invoked from network); 21 Oct 2020 09:32:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=uqvkvvjoE5FAn6/BMAIUZQ+MmjJn2kzB19jYobhFRX8=; b=Lre+lL+7R9qcHEKT2oKPmuoix0
	8+LXkYHtQYHrO2Pz7aEHI7sV1vgZDrWHN+UyPxRTwXoL2QHKC6LZhqZ0NLRXOEfVpKRikeCq40Q5C
	atnuKL+sNqu+svyLk2dv9s9MF8hscvTiRHtwomK8MzcM1rFH6ZJKBnDE+ZSgAqeuI+PMs2YMEPsV9
	F+nrQvS9EGm7Co6vldjFlpa2BGab+OdtnGdrjyA8CbXLVbHMYEE+FY6dei4gPfLLcwu8JSKoRahxO
	uWnNBiAUOcWVy7viO9vcOo04lqSFPTD5SV3h441hcw1wOfJEretWPf/kkS656dTUVyPvbeRhsUUun
	wZ1xFJ3Q==;
Date: Wed, 21 Oct 2020 11:32:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jannh@google.com>,
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
Message-ID: <20201021093213.GV2651@hirez.programming.kicks-ass.net>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com>
 <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net>
 <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble>
 <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201021085606.GZ2628@hirez.programming.kicks-ass.net>

On Wed, Oct 21, 2020 at 10:56:06AM +0200, Peter Zijlstra wrote:

> I do not see these in particular, although I do see a lot of:
> 
>   "sibling call from callable instruction with modified stack frame"

defconfig-build/vmlinux.o: warning: objtool: msr_write()+0x10a: sibling call from callable instruction with modified stack frame
defconfig-build/vmlinux.o: warning: objtool:   msr_write()+0x99: (branch)
defconfig-build/vmlinux.o: warning: objtool:   msr_write()+0x3e: (branch)
defconfig-build/vmlinux.o: warning: objtool:   msr_write()+0x0: <=== (sym)

$ nm defconfig-build/vmlinux.o | grep msr_write
0000000000043250 t msr_write
00000000004289c0 T msr_write
0000000000003056 t msr_write.cold

Below 'fixes' it. So this is also caused by duplicate symbols.

---
diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index 3bd905e10ee2..e36331f8f217 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -48,17 +48,6 @@ int msr_read(u32 msr, struct msr *m)
 	return err;
 }
 
-/**
- * Write an MSR with error handling
- *
- * @msr: MSR to write
- * @m: value to write
- */
-int msr_write(u32 msr, struct msr *m)
-{
-	return wrmsrl_safe(msr, m->q);
-}
-
 static inline int __flip_bit(u32 msr, u8 bit, bool set)
 {
 	struct msr m, m1;
@@ -80,7 +69,7 @@ static inline int __flip_bit(u32 msr, u8 bit, bool set)
 	if (m1.q == m.q)
 		return 0;
 
-	err = msr_write(msr, &m1);
+	err = wrmsr_safe(msr, m1.q);
 	if (err)
 		return err;
 
