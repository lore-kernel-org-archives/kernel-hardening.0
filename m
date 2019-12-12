Return-Path: <SRS0=B9zJ=2C=lists.openwall.com=kernel-hardening-return-17498-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45EFDC43603
	for <kernel-hardening@archiver.kernel.org>; Thu, 12 Dec 2019 06:43:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6AB1621655
	for <kernel-hardening@archiver.kernel.org>; Thu, 12 Dec 2019 06:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=russell.cc header.i=@russell.cc header.b="HejDlK/1";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Lt8ZKVPt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AB1621655
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=russell.cc
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17498-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22524 invoked by uid 550); 12 Dec 2019 06:43:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22487 invoked from network); 12 Dec 2019 06:43:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:mime-version:content-transfer-encoding; s=fm3; bh=
	KyeWj8I1QMnmG8BRD33xXuY6tRJtAPepF3GJKhvFlro=; b=HejDlK/1SuGGBh2U
	VSzZQ1jtkfDeE1LwGxG4T6rprj8MkGil741naD2w3v+l9+WoE5iOq3MmnmG0hVkV
	2VgGkNsgtIhJ9oAhNQmJBcbmVZhXt37UqxhCnleuto/eRZs5OR5Oi8+WyrMwsMvT
	j4PGwLJflSV5qb3l6BP8BAXSR+67igfV/cB7QEUva8AJKdjl3MdmYaU5xOSDQ9c4
	JIEZiyDp/JbaNr15K7/+y7yw41HI/Q8QEOnalbvvLaeAE5p7X2xqt1kCrJy5Fu34
	Dz5I2lVY5khYoZwAV2hVFQ009Eya8xLKo/VIfF+GhKoPCmVrU6vkdGrA7BXkyuSX
	5JK2DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; bh=KyeWj8I1QMnmG8BRD33xXuY6tRJtAPepF3GJKhvFl
	ro=; b=Lt8ZKVPtexLF/AskJaPBbCVVyQFCb/lgfHRlhEaaQ8lArbKqULD8jOTwF
	pEgEwdIvmy2ZsEZipq/RaD1gRQtUAjGvbVdv9O3tgOT0Jpw0Z4M0pKnC6tBptE9u
	qHWj/OBV+ukIBZHw8N5pLdHDY+rgSEhlepVeDkOBhK6J2yNflo/Q7jA8nfcisTxe
	z6E5DN4ZWg8+fMvEu2NI4nq8K1RdbdJBnDTsD9wqCbHN1G2Pp/HbRx3CXxaD9mgH
	RZYAqI6PuDQbPuGl76osu8Y9tdgOWbNkPcO+Zgh+Buo4oh26TlC0fPPugy3dfkFc
	ESrCQftm3rtbz9fpoeoNCYBxyujVQ==
X-ME-Sender: <xms:feHxXaqRFqJfPBu82gMup8LSdZ-MvkSxJKv1oVEfxVCvW742jmUXAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeliedgleejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefkuf
    fhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpeftuhhsshgvlhhlucevuhhr
    rhgvhicuoehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvvddrleelrd
    ekvddruddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhstghurhesrhhushhsvghl
    lhdrtggtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:feHxXUq_6t_Fvu7O6Z9Tvdq7Mg-ukP6SQuxF_8gDM23_fcZDgmCizQ>
    <xmx:feHxXRY_y0XBFHaDqaJHvdLnnLsaFMT4ZSeyMcv8To-Ewcglvq80Gg>
    <xmx:feHxXa-AM8F54FMjU8DhkOCGEsPKApZtGbyP7RkDYD4G3Ua-WD_-6w>
    <xmx:fuHxXXmI5uEodkUlXZid_KiovUsjzRht4SMGI_va0Jm2RqK3nveZnQ>
Message-ID: <d01de33ebe1fb1e0715878383a68e8e174d048a0.camel@russell.cc>
Subject: Re: [PATCH v5 2/5] powerpc/kprobes: Mark newly allocated probes as
 RO
From: Russell Currey <ruscur@russell.cc>
To: Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Cc: ajd@linux.ibm.com, kernel-hardening@lists.openwall.com,
 npiggin@gmail.com,  joel@jms.id.au, dja@axtens.net
Date: Thu, 12 Dec 2019 17:43:03 +1100
In-Reply-To: <87eexie3nl.fsf@mpe.ellerman.id.au>
References: <20191030073111.140493-1-ruscur@russell.cc>
	 <20191030073111.140493-3-ruscur@russell.cc>
	 <8736f636bl.fsf@mpe.ellerman.id.au> <87eexie3nl.fsf@mpe.ellerman.id.au>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2019-12-06 at 10:47 +1100, Michael Ellerman wrote:
> Michael Ellerman <mpe@ellerman.id.au> writes:
> > Russell Currey <ruscur@russell.cc> writes:
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
> > > Thus mark newly allocated probes as read-only once it's safe to
> > > do so.
> > > 
> > > Signed-off-by: Russell Currey <ruscur@russell.cc>
> > > ---
> > >  arch/powerpc/kernel/kprobes.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/arch/powerpc/kernel/kprobes.c
> > > b/arch/powerpc/kernel/kprobes.c
> > > index 2d27ec4feee4..2610496de7c7 100644
> > > --- a/arch/powerpc/kernel/kprobes.c
> > > +++ b/arch/powerpc/kernel/kprobes.c
> > > @@ -24,6 +24,7 @@
> > >  #include <asm/sstep.h>
> > >  #include <asm/sections.h>
> > >  #include <linux/uaccess.h>
> > > +#include <linux/set_memory.h>
> > >  
> > >  DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
> > >  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> > > @@ -131,6 +132,8 @@ int arch_prepare_kprobe(struct kprobe *p)
> > >  			(unsigned long)p->ainsn.insn +
> > > sizeof(kprobe_opcode_t));
> > >  	}
> > >  
> > > +	set_memory_ro((unsigned long)p->ainsn.insn, 1);
> > > +
> > 
> > That comes from:
> > 	p->ainsn.insn = get_insn_slot();
> > 
> > 
> > Which ends up in __get_insn_slot() I think. And that looks very
> > much
> > like it's going to hand out multiple slots per page, which isn't
> > going
> > to work because you've just marked the whole page RO.
> > 
> > So I would expect this to crash on the 2nd kprobe that's installed.
> > Have
> > you tested it somehow?
> 
> I'm not sure if this is the issue I was talking about, but it doesn't
> survive ftracetest:
> 
>   [ 1139.576047] ------------[ cut here ]------------
>   [ 1139.576322] kernel BUG at mm/memory.c:2036!
>   cpu 0x1f: Vector: 700 (Program Check) at [c000001fd6c675d0]
>       pc: c00000000035d018: apply_to_page_range+0x318/0x610
>       lr: c0000000000900bc: change_memory_attr+0x4c/0x70
>       sp: c000001fd6c67860
>      msr: 9000000000029033
>     current = 0xc000001fa4a47880
>     paca    = 0xc000001ffffe5c80   irqmask: 0x03   irq_happened: 0x01
>       pid   = 7168, comm = ftracetest
>   kernel BUG at mm/memory.c:2036!
>   Linux version 5.4.0-gcc-8.2.0-11694-gf1f9aa266811 (
> michael@Raptor-2.ozlabs.ibm.com) (gcc version 8.2.0 (crosstool-NG
> 1.24.0-rc1.16-9627a04)) #1384 SMP Thu Dec 5 22:11:09 AEDT 2019
>   enter ? for help
>   [c000001fd6c67940] c0000000000900bc change_memory_attr+0x4c/0x70
>   [c000001fd6c67970] c000000000053c48 arch_prepare_kprobe+0xb8/0x120
>   [c000001fd6c679e0] c00000000022f718 register_kprobe+0x608/0x790
>   [c000001fd6c67a40] c00000000022fc50 register_kretprobe+0x230/0x350
>   [c000001fd6c67a80] c0000000002849b4
> __register_trace_kprobe+0xf4/0x1a0
>   [c000001fd6c67af0] c000000000285b18 trace_kprobe_create+0x738/0xf70
>   [c000001fd6c67c30] c000000000286378
> create_or_delete_trace_kprobe+0x28/0x70
>   [c000001fd6c67c50] c00000000025f024 trace_run_command+0xc4/0xe0
>   [c000001fd6c67ca0] c00000000025f128
> trace_parse_run_command+0xe8/0x230
>   [c000001fd6c67d40] c0000000002845d0 probes_write+0x20/0x40
>   [c000001fd6c67d60] c0000000003eef4c __vfs_write+0x3c/0x70
>   [c000001fd6c67d80] c0000000003f26a0 vfs_write+0xd0/0x200
>   [c000001fd6c67dd0] c0000000003f2a3c ksys_write+0x7c/0x140
>   [c000001fd6c67e20] c00000000000b9e0 system_call+0x5c/0x68
>   --- Exception: c01 (System Call) at 00007fff8f06e420
>   SP (7ffff93d6830) is in userspace
>   1f:mon> client_loop: send disconnect: Broken pipe
> 
> 
> Sorry I didn't get any more info on the crash, I lost the console and
> then some CI bot stole the machine 8)
> 
> You should be able to reproduce just by running ftracetest.

The test that blew it up was test.d/kprobe/probepoint.tc for the
record.  It goes away when replacing the memcpy with a
patch_instruction().

> 
> cheers

