Return-Path: <SRS0=Kl7a=5S=lists.openwall.com=kernel-hardening-return-18403-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D345CC43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 23:03:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 29E6B2073B
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 23:03:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="cwU1XyeB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jin3OWCM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29E6B2073B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18403-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28297 invoked by uid 550); 2 Apr 2020 23:03:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28259 invoked from network); 2 Apr 2020 23:03:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:mime-version:content-transfer-encoding; s=fm1; bh=
	M3R5y7LjkKWnRuSDdjCJ6HcWtMsBj3KFa+ujqdG6xug=; b=cwU1XyeBe/K9fVaV
	L6WVGuM8RgATQaOVraJdy7gZXc+0AoW0ZSH+spjQ6945LBOnrSqHD+kcyTvlMWKN
	GuxC4MQr6ewP58+Ys5h/u6LulOZa95ZcA737TgDolgt4ZHdQqTH0nQQGOb9KJRsj
	1YV7+SCkipVNPup3YAUtL8SW5mcVkmzhj0Z2R/vrYmhIjnmCgSjv9W/DDM8vM1wm
	Fz/poSYGl8D/g38aFz1t9otUbVHUi/UPvyT+kT0Y5CDbOcWotVFzKvkqf32NFcaD
	XgtvYX5YanOll9yi7CdSvHz07jqy8XBQtyrjMJuBAwQhoO2xrQstB4mzhX2QrRJD
	IYD38A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm2; bh=M3R5y7LjkKWnRuSDdjCJ6HcWtMsBj3KFa+ujqdG6x
	ug=; b=jin3OWCM4S6UvPS8B5qB0y9gYBFtA4Y8U/JBkHGC2UoTikLhrsisVeTcF
	rJpvLiV9N+uJQ6WB6MPL1ABeivsvnsgXhKmQsT8zThDtbUn3Sdbpq3dNvgnvDagg
	AZtpa+Eu0iyFOTBaxJ181DZbPbA/NRa9XFiwWJWpsyBg9HZrPn0KIX1Orm/QmM5Z
	VNLfhK4tfFdEl/QTis/41/3JDhuVebuoMfGMNVubvPsAQOgWcmK0Fr2JWI3Fvznj
	qq4p9QXxGcYIGEhE0CG3Jq+NhicM1oT0P6MrOoUGwkVGBMLW26p/RtVeJtJB9evA
	BJCzwdPf0GnuUVHFT5GsU8r6tAVEg==
X-ME-Sender: <xms:Fm-GXnxvJQ0GGsT_ePXKnVNLnhxuVq5Ypwosmdo9k-I6Vka_asIuaw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdehgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculddutddmnecujfgurhepkffuhf
    fvffgjfhgtfggggfesthejredttderjeenucfhrhhomheptfhushhsvghllhcuvehurhhr
    vgihuceorhhushgtuhhrsehruhhsshgvlhhlrdgttgeqnecukfhppeduvddurdeghedrvd
    duvddrvdefleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehruhhstghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:Fm-GXkY-sK9s2Vq1rfOpg1aNAXz6j8sAWTYntOPNizRawjTQT0DdHQ>
    <xmx:Fm-GXi0crtWH9hL0QDzfAYnc0mxjxgFRZUpIYYslLLOl4UMUijBEyA>
    <xmx:Fm-GXi6OG-5V77bR0tAJ5ECCLJqcmyL6CHS7Lfoz7qlsMU1l-wsQyw>
    <xmx:F2-GXgQrKT77E88EH4HmWgpXqQzCf6EHgj9K5XH7G7W1n7xE3-j6Ew>
Message-ID: <ecaa9bb115f5673e828a7c4546b22802d8775939.camel@russell.cc>
Subject: Re: [PATCH v8 2/7] powerpc/kprobes: Mark newly allocated probes as
 RO
From: Russell Currey <ruscur@russell.cc>
To: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, 
	linuxppc-dev@lists.ozlabs.org
Cc: ajd@linux.ibm.com, dja@axtens.net, kernel-hardening@lists.openwall.com, 
	npiggin@gmail.com
Date: Fri, 03 Apr 2020 10:02:41 +1100
In-Reply-To: <1585852977.oiikywo1jz.naveen@linux.ibm.com>
References: <20200402084053.188537-1-ruscur@russell.cc>
	 <20200402084053.188537-2-ruscur@russell.cc>
	 <1585844035.o235bvxmq0.naveen@linux.ibm.com>
	 <1585852977.oiikywo1jz.naveen@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2020-04-03 at 00:18 +0530, Naveen N. Rao wrote:
> Naveen N. Rao wrote:
> > Russell Currey wrote:
> > > With CONFIG_STRICT_KERNEL_RWX=y and CONFIG_KPROBES=y, there will
> > > be one
> > > W+X page at boot by default.  This can be tested with
> > > CONFIG_PPC_PTDUMP=y and CONFIG_PPC_DEBUG_WX=y set, and checking
> > > the
> > > kernel log during boot.
> > > 
> > > powerpc doesn't implement its own alloc() for kprobes like other
> > > architectures do, but we couldn't immediately mark RO anyway
> > > since we do
> > > a memcpy to the page we allocate later.  After that, nothing
> > > should be
> > > allowed to modify the page, and write permissions are removed
> > > well
> > > before the kprobe is armed.
> > > 
> > > The memcpy() would fail if >1 probes were allocated, so use
> > > patch_instruction() instead which is safe for RO.
> > > 
> > > Reviewed-by: Daniel Axtens <dja@axtens.net>
> > > Signed-off-by: Russell Currey <ruscur@russell.cc>
> > > Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > > ---
> > >  arch/powerpc/kernel/kprobes.c | 17 +++++++++++++----
> > >  1 file changed, 13 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/powerpc/kernel/kprobes.c
> > > b/arch/powerpc/kernel/kprobes.c
> > > index 81efb605113e..fa4502b4de35 100644
> > > --- a/arch/powerpc/kernel/kprobes.c
> > > +++ b/arch/powerpc/kernel/kprobes.c
> > > @@ -24,6 +24,8 @@
> > >  #include <asm/sstep.h>
> > >  #include <asm/sections.h>
> > >  #include <linux/uaccess.h>
> > > +#include <linux/set_memory.h>
> > > +#include <linux/vmalloc.h>
> > >  
> > >  DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
> > >  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> > > @@ -102,6 +104,16 @@ kprobe_opcode_t *kprobe_lookup_name(const
> > > char *name, unsigned int offset)
> > >  	return addr;
> > >  }
> > >  
> > > +void *alloc_insn_page(void)
> > > +{
> > > +	void *page = vmalloc_exec(PAGE_SIZE);
> > > +
> > > +	if (page)
> > > +		set_memory_ro((unsigned long)page, 1);
> > > +
> > > +	return page;
> > > +}
> > > +
> > 
> > This crashes for me with KPROBES_SANITY_TEST during the kretprobe
> > test.  
> 
> That isn't needed to reproduce this. After bootup, disabling
> optprobes 
> also shows the crash with kretprobes:
> 	sysctl debug.kprobes-optimization=0
> 
> The problem happens to be with patch_instruction() in 
> arch_prepare_kprobe(). During boot, on kprobe init, we register a
> probe 
> on kretprobe_trampoline for use with kretprobes (see 
> arch_init_kprobes()). This results in an instruction slot being 
> allocated, and arch_prepare_kprobe() to be called for copying the 
> instruction (nop) at kretprobe_trampoline. patch_instruction() is 
> failing resulting in corrupt instruction which we try to
> emulate/single 
> step causing the crash.

Thanks a lot for the info Naveen, I'll investigate.

- Russell

> 
> 
> - Naveen
> 

