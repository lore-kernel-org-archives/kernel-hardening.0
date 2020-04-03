Return-Path: <SRS0=/Fzc=5T=lists.openwall.com=kernel-hardening-return-18410-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70386C43331
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 09:42:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 98F4F20787
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Apr 2020 09:42:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="jNmKgrCl";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="B9idOihG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98F4F20787
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18410-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21954 invoked by uid 550); 3 Apr 2020 09:42:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21916 invoked from network); 3 Apr 2020 09:42:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:mime-version:content-transfer-encoding; s=fm1; bh=
	Aw/lGDO2hSKhVJiejVXIxntavdsyE84gXBRA8ScJ3us=; b=jNmKgrClXsD1Qk09
	yn7HuU4QCTrnTs0vQeV6hRM6B32NbrD58IXQlMMpt53m+xQDfmRdP6E//+w6Rf20
	2FipxHbSBFiyzbZ1M78KBEhkc2MOS9EMyF3L8uimj+SE0iF1e4lAE+rPJCgUEvXe
	ldhd/d3um8OQ7eKwXFocVbwZCy3TMftFce2D11/Z+mFajW4Q8YWjWWmYzubGE2XR
	ja8xYs4wdqExsoL7uKdpOeKnMREYGKbAXmDVX5cvykzYd74JsuXJNxj1jj30txeY
	2/ENx/VLiXO6dYavgWTYR7O8O7q/qkLRyBrFXsx0TPSh8MPlf1uP/A3q/YxsXsYH
	CuYgXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; bh=Aw/lGDO2hSKhVJiejVXIxntavdsyE84gXBRA8ScJ3
	us=; b=B9idOihGYCVMU/rGJPDZemgIdTnFWA1ZRxO2OFpeRvkRM0mvHM6UNCMn9
	BYHlgzT/y0guRwe8unj3Svd+klV/hIiYyKwmOGar8VEotsRTF/ZHBtX+zeNe5UeO
	/KFl7QzRfWRmmFzNKQ1OqJm8m1nr0QIs9g7KIcPwXstP5fjBl5CLobzeggcYw2pZ
	VSrLoLtHo2Nm3ZqHSRLYIaXS07dXhVntOirAcDWzSYmibHS4/d8YvDCcYKXXdi8c
	qKjeHt6dhxEa7/yXk3Dpl6Fz1EEnyqIQvISZ9MWG9DiNMD9qhZdGr9dkPL0NATUP
	VXbznzv7o/CE+r2ECtCT4rK+7txxw==
X-ME-Sender: <xms:-wSHXpLMGCb-qI-zXH-CcSOZ0RkGy3WQKQ2KfRF0ccDYGxTDGmofvQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeigddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculddutddmnecujfgurhepkffuhf
    fvffgjfhgtfggggfesthejredttderjeenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddurdeghedrvd
    duvddrvdefleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehruhhstghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:-wSHXsk9xGSco3bvij09h5TV-9tCf-je9oaBDnbJ1-rInyBO--vhJw>
    <xmx:-wSHXvHs2q5xZHDwCXV3DkWS4rFJ8RBzl-OKdhoHcLqXCND93fvxpQ>
    <xmx:-wSHXkHsDXkBK9EMKU_m0yctsCIwNkOi9mkncFWYmPgmurRHMToZRA>
    <xmx:_ASHXgXQe2qh3SO_LI2ZN2UzIy3eQvDkccJ-k-9l3hpMIphMVDcIhg>
Message-ID: <02c6c3d0483e217a6d879bb7037f0b549c64ba04.camel@russell.cc>
Subject: Re: [PATCH v8 2/7] powerpc/kprobes: Mark newly allocated probes as
 RO
From: Russell Currey <ruscur@russell.cc>
To: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, 
	linuxppc-dev@lists.ozlabs.org
Cc: ajd@linux.ibm.com, dja@axtens.net, kernel-hardening@lists.openwall.com, 
	npiggin@gmail.com
Date: Fri, 03 Apr 2020 20:42:14 +1100
In-Reply-To: <1585906281.fbqgtc3kpy.naveen@linux.ibm.com>
References: <20200402084053.188537-1-ruscur@russell.cc>
	 <20200402084053.188537-2-ruscur@russell.cc>
	 <1585844035.o235bvxmq0.naveen@linux.ibm.com>
	 <1585852977.oiikywo1jz.naveen@linux.ibm.com>
	 <c336400d5b7765eb72b3090cd9f8a3c57761d0b6.camel@russell.cc>
	 <1585906281.fbqgtc3kpy.naveen@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2020-04-03 at 15:06 +0530, Naveen N. Rao wrote:
> Russell Currey wrote:
> > On Fri, 2020-04-03 at 00:18 +0530, Naveen N. Rao wrote:
> > > Naveen N. Rao wrote:
> > > > Russell Currey wrote:
> > > > > With CONFIG_STRICT_KERNEL_RWX=y and CONFIG_KPROBES=y, there
> > > > > will
> > > > > be one
> > > > > W+X page at boot by default.  This can be tested with
> > > > > CONFIG_PPC_PTDUMP=y and CONFIG_PPC_DEBUG_WX=y set, and
> > > > > checking
> > > > > the
> > > > > kernel log during boot.
> > > > > 
> > > > > powerpc doesn't implement its own alloc() for kprobes like
> > > > > other
> > > > > architectures do, but we couldn't immediately mark RO anyway
> > > > > since we do
> > > > > a memcpy to the page we allocate later.  After that, nothing
> > > > > should be
> > > > > allowed to modify the page, and write permissions are removed
> > > > > well
> > > > > before the kprobe is armed.
> > > > > 
> > > > > The memcpy() would fail if >1 probes were allocated, so use
> > > > > patch_instruction() instead which is safe for RO.
> > > > > 
> > > > > Reviewed-by: Daniel Axtens <dja@axtens.net>
> > > > > Signed-off-by: Russell Currey <ruscur@russell.cc>
> > > > > Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > > > > ---
> > > > >  arch/powerpc/kernel/kprobes.c | 17 +++++++++++++----
> > > > >  1 file changed, 13 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/arch/powerpc/kernel/kprobes.c
> > > > > b/arch/powerpc/kernel/kprobes.c
> > > > > index 81efb605113e..fa4502b4de35 100644
> > > > > --- a/arch/powerpc/kernel/kprobes.c
> > > > > +++ b/arch/powerpc/kernel/kprobes.c
> > > > > @@ -24,6 +24,8 @@
> > > > >  #include <asm/sstep.h>
> > > > >  #include <asm/sections.h>
> > > > >  #include <linux/uaccess.h>
> > > > > +#include <linux/set_memory.h>
> > > > > +#include <linux/vmalloc.h>
> > > > >  
> > > > >  DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
> > > > >  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> > > > > @@ -102,6 +104,16 @@ kprobe_opcode_t
> > > > > *kprobe_lookup_name(const
> > > > > char *name, unsigned int offset)
> > > > >  	return addr;
> > > > >  }
> > > > >  
> > > > > +void *alloc_insn_page(void)
> > > > > +{
> > > > > +	void *page = vmalloc_exec(PAGE_SIZE);
> > > > > +
> > > > > +	if (page)
> > > > > +		set_memory_ro((unsigned long)page, 1);
> > > > > +
> > > > > +	return page;
> > > > > +}
> > > > > +
> > > > 
> > > > This crashes for me with KPROBES_SANITY_TEST during the
> > > > kretprobe
> > > > test.  
> > > 
> > > That isn't needed to reproduce this. After bootup, disabling
> > > optprobes 
> > > also shows the crash with kretprobes:
> > > 	sysctl debug.kprobes-optimization=0
> > > 
> > > The problem happens to be with patch_instruction() in 
> > > arch_prepare_kprobe(). During boot, on kprobe init, we register a
> > > probe 
> > > on kretprobe_trampoline for use with kretprobes (see 
> > > arch_init_kprobes()). This results in an instruction slot being 
> > > allocated, and arch_prepare_kprobe() to be called for copying
> > > the 
> > > instruction (nop) at kretprobe_trampoline. patch_instruction()
> > > is 
> > > failing resulting in corrupt instruction which we try to
> > > emulate/single 
> > > step causing the crash.
> > 
> > OK I think I've fixed it, KPROBES_SANITY_TEST passes too.  I'd
> > appreciate it if you could test v9, and thanks again for finding
> > this -
> > very embarrassing bug on my side.
> 
> Great! Thanks.
> 
> I think I should also add appropriate error checking to kprobes' use
> of 
> patch_instruction() which would have caught this much more easily.

Only kind of!  It turns out that if the initial setup fails for
KPROBES_SANITY_TEST, it silently doesn't run - so you miss the "Kprobe
smoke test" text, but you don't get any kind of error either.  I'll
send a patch so that it fails more loudly later.

> 
> On a related note, I notice that x86 seems to prefer not having any
> RWX 
> pages, and so they continue to do 'module_alloc()' followed by 
> 'set_memory_ro()' and then 'set_memory_x()'. Is that something worth 
> following for powerpc?

I just noticed that too.  arm64 doesn't set theirs executable, as far
as I can tell powerpc doesn't need to.

> 
> - Naveen
> 

