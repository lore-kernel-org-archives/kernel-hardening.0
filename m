Return-Path: <SRS0=O8x9=BK=lists.openwall.com=kernel-hardening-return-19506-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5D7C433DF
	for <kernel-hardening@archiver.kernel.org>; Fri, 31 Jul 2020 14:42:37 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6169F22B3F
	for <kernel-hardening@archiver.kernel.org>; Fri, 31 Jul 2020 14:42:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="Ij+B9IpQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6169F22B3F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19506-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4046 invoked by uid 550); 31 Jul 2020 14:42:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4025 invoked from network); 31 Jul 2020 14:42:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1596206506;
	bh=t5bgTMuS5BA+IAiyPBaCZ9mzPj4FCpss/TD+Q9mI4jc=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ij+B9IpQf742RQuzq1biBzkfDWrKxDtq/J+Q470KF+4WVs/LsIUoDBupvptA1LxQL
	 EMTb4YFYtY8RsCCy3GCYQL3y/N5G9qr9Hr1ml988IEn/jR9UVKGi07lWutW/X8mni2
	 9I7Na2kC6XNp4eLJmuOOaTN0JO9wrgtagcfWCyQ8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 31 Jul 2020 16:41:32 +0200
From: Oscar Carter <oscar.carter@gmx.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, Ingo Molnar <mingo@redhat.com>,
	Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Message-ID: <20200731144132.GA6515@ubuntu>
References: <20200724161921.GA3123@ubuntu>
 <20200724123528.36ea9c9e@oasis.local.home>
 <20200724171418.GB3123@ubuntu>
 <20200724133656.76c75629@oasis.local.home>
 <20200724134020.3160dc7c@oasis.local.home>
 <20200724175500.GD3123@ubuntu>
 <20200724143457.27755412@oasis.local.home>
 <20200725150914.GA3362@ubuntu>
 <20200726155148.GA9341@ubuntu>
 <20200727095306.7f369949@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727095306.7f369949@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Provags-ID: V03:K1:FH/Vf3wNGxtmRHWftMcJXn+JACdkJavvNOQq1HxTrxSYzE/ujQC
 cZykk6K85ZhJdTJWg7D5fMCj4yPrWfZpaGNF58b0VKjiZK5kQRxQ3VYhbTn50buPDSihKQ7
 et3AgisINOma/CX3esappiNiqGugyiePgcdLyRZ+Bf6ljl+5X5SxODxQXT5xzbI8pb6QQlY
 UNuA0ENknllDr+Z7fkh3g==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WTeDmc/l+T4=:g1qWGRSNIIbG8tvjLoiEvb
 a/A7dCLOGBmRJgRkhE3DdfDwP0QKcfBw4WSwKXtxsF0OroG7RybMC9pT0Ps/oYglu7M9gYAcd
 anqRxL3R0tyFFZEXOak29+q4TVn//xsKOAac8pq4x/IdMGxZOSUB0AAJYWZpZOGQUpbbNQbZZ
 G2OfjYdE+dcC5HgZl1TnMrGyfMbF+zPddo/7zRNnGXfbC0C1AuGGF9FtHIcoERUGbzOqfBscJ
 A6/jq+52ufMoBAA/4yWvON4MxmJcjdil0xs3euu7AF6VkSP6vD3KJ7iniylqu7MDOiqAchn1B
 V4h8Ao9j14iJ5e9x/kws5DT2TkhFmOGnnyawt5gg2oKIpDgSz13R8brHyXEEEOKVAlSKPJVMt
 7eF7p3oLLLuB/0z8baR03qVGvsNbIMDULvdICQquOOSYCWcGiss7T9WQA7zlMmHifykW4BtMO
 +iKf9jVqcH5OfMqqJ7O1qBc/FRs6nkGsAhSXnqA9tfgPoxHbLXwd2SFN1rGp+ZoNSh5YANzPL
 04mMPMD5dLA3kr18tOq+v5YSwnp2j/l14OXzykd3G7aLO29ZMvEIia0kGlVerjFv7DxsGf11v
 pClODt39L1rtoq7tToTLFHShP+H87c8YuL3NZctbmzPU0qWBxmuhwtZ+1LRhNd0VzL+7f433D
 K6+E2ithnQ5HNyhKmdotYMmOsyTJlJAIknwNx4MIpSpp/GZQBJJ77MlfE1vkWZ68cFfWFfLL2
 /MBl5ftLx6gE5ussRcWqBexaDxwjUEEgqDYkLbpxC6NiOfndZ/y8hn/6L+3wd3VvtLcgW2nse
 Ad31TQUXnKyCrTGjxvbZDclFdrwW8cYbgm0dr1XAxTah70wuqDlEmv8rqVIu9Eub2BAB8aPGm
 F0urMoZFwg5O6BoX932MjOqu5BkdASVDpa1OMfhOzqauSupgoREbdYc+k5FuMQrm93wGidGZ3
 f7TdiEQi5Hdu1nFotiqV5j70qHkyvLjO/MySLFRsmZSpPEE079BfIjlXTCOcl2DmWrqawJ2C2
 y1sZ3W2J1T6IRv1MsfJslYh3dDip6LwWexoxSM4NhWVBrRiOyh4zYBjgyQhiGB9wF2bklwAKU
 lzb9eRN5GacEroG03qZ44FUxXXPaIBwaOk+xrmQG9XLE6RbM6HwwcFZe4oMxGbxDEQukxcZ6b
 UgUyWjf46ZGaYx2eSSRjdUVn8uXqKBa7qZ1gC3/Q7rW+0IllibbeFl2zqFkUBSM+82nPgJ3+v
 dGop/cgHOKP/+8hdYvveV2IW+c8c645JZO7tfHw==
Content-Transfer-Encoding: quoted-printable

Hi Steven,

On Mon, Jul 27, 2020 at 09:53:06AM -0400, Steven Rostedt wrote:
> On Sun, 26 Jul 2020 17:52:42 +0200
> Oscar Carter <oscar.carter@gmx.com> wrote:
>
> > > If I try to do this I will need some help. Some info that point me t=
o the
> > > right direction would be greatly appreciated. Some advice about what
> > > functions I will need to implement would be really helpfull. Or poin=
t me
> > > to the right piece of code that I can pick as base point.
> >
> > I've been searching and reading the code as much as possible. I've fou=
nd
> > two patches that I think can be useful to guide me. One [1] adds suppo=
rt
> > for ftrace_ops to the riscv architecture. The other one [2] adds suppo=
rt
> > for ftrace_ops to the parisc architecture.
> >
> > [1] commit 71e736a7d655 ("riscv/ftrace: Add ARCH_SUPPORTS_FTRACE_OPS s=
upport")
> > [2] commit d562aca37a54 ("parisc/ftrace: Add ARCH_SUPPORTS_FTRACE_OPS =
support")
> >
> > Due to powerpc arch calls the needed functions from assembly, I based =
my
> > idea on the patch for the RISCV arch.
> >
> > Can something like the following work?
> >
> > diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/=
asm/ftrace.h
> > index bc76970b6ee5..1c51ff5afae1 100644
> > --- a/arch/powerpc/include/asm/ftrace.h
> > +++ b/arch/powerpc/include/asm/ftrace.h
> > @@ -61,9 +61,8 @@ struct dyn_arch_ftrace {
> >  };
> >  #endif /* __ASSEMBLY__ */
> >
> > -#ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
> >  #define ARCH_SUPPORTS_FTRACE_OPS 1
> > -#endif
> > +
> >  #endif /* CONFIG_FUNCTION_TRACER */
> >
> >  #ifndef __ASSEMBLY__
> > diff --git a/arch/powerpc/kernel/trace/ftrace_32.S b/arch/powerpc/kern=
el/trace/ftrace_32.S
> > index e023ae59c429..e69a4e945986 100644
> > --- a/arch/powerpc/kernel/trace/ftrace_32.S
> > +++ b/arch/powerpc/kernel/trace/ftrace_32.S
> > @@ -29,6 +29,10 @@ _GLOBAL(ftrace_caller)
> >         MCOUNT_SAVE_FRAME
> >         /* r3 ends up with link register */
> >         subi    r3, r3, MCOUNT_INSN_SIZE
> > +
> > +       /* Set ftrace_ops (r5) to the global variable function_trace_o=
p */
> > +       /* Set pt_regs (r6) to NULL */
> > +
> >  .globl ftrace_call
> >  ftrace_call:
> >         bl      ftrace_stub
> > diff --git a/arch/powerpc/kernel/trace/ftrace_64_pg.S b/arch/powerpc/k=
ernel/trace/ftrace_64_pg.S
> > index 6708e24db0ab..a741448b1df9 100644
> > --- a/arch/powerpc/kernel/trace/ftrace_64_pg.S
> > +++ b/arch/powerpc/kernel/trace/ftrace_64_pg.S
> > @@ -22,6 +22,10 @@ _GLOBAL_TOC(ftrace_caller)
> >         std     r3, 128(r1)
> >         ld      r4, 16(r11)
> >         subi    r3, r3, MCOUNT_INSN_SIZE
> > +
> > +       /* Set ftrace_ops (r5) to the global variable function_trace_o=
p */
> > +       /* Set pt_regs (r6) to NULL */
>
> I'm guessing you are going to do the above here. If so, this looks corre=
ct.
>
> > +
> >  .globl ftrace_call
> >  ftrace_call:
> >         bl      ftrace_stub
> >
> > To add support for ftrace_ops to the powerpc architecture is only nece=
ssary
> > to fill the r5 and r6 registers before the call to ftrace_stub in all =
the
> > cases. The register r5 is a pointer to ftrace_ops struct and the regis=
ter
> > r6 is a pointer to pt_regs struct. These registers are the third and f=
ourth
> > parameters of a function with the following prototype. The first and s=
econd
> > ones are yet set.
>
> I guess you mean that the first and second ones are already set. But,
> yeah, you are on the correct path here!
>
> >
> > void func(unsigned long ip, unsigned long parent_ip,
> > 	  struct ftrace_ops *ops, struct pt_regs *regs);
> >
> > Am I in the right direction? or am I totally wrong?
>
> No, you don't look wrong. But the true test is to try it out :-)

Of course. I will do the commented work, I will test it and then I will se=
nd
a new patch.

> Don't forget to update ftrace_32.S as well.
>
>
> >
> > Thanks for your time and patience.
>
> My pleasure. Thanks for doing this. The more people that understand all
> this, the better!

Thanks for your guidance and advices.

> -- Steve

Regards,
Oscar Carter
