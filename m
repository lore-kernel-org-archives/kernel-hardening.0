Return-Path: <SRS0=2FoX=YW=lists.openwall.com=kernel-hardening-return-17153-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0343CA9EAE
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 21:30:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 41C8321734
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Oct 2019 21:30:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bK/S1BlN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 41C8321734
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17153-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7801 invoked by uid 550); 29 Oct 2019 21:30:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7775 invoked from network); 29 Oct 2019 21:30:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zjXTK8wqc+micfhU3PtaSFSd9eN2mP8dCcEeCTySNXs=;
        b=bK/S1BlNrTZX7xIW1sXhw8Fva50fgp2jCLXmx0dNxNdaHjwy5/0nsVOn2M3e4zMndS
         ylG17btxpUvCOnh3po1QOsl4zYyVzclox07WqLhIhzoEUjWE0jPgbGjIoMpMt+4hzaxz
         xphwlkYHW3IuOdu+kxcOFdy/GMp5nH05i8uOU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zjXTK8wqc+micfhU3PtaSFSd9eN2mP8dCcEeCTySNXs=;
        b=VZ7ZOryfRPvYJs6QS6VO6QjpwCMnV5p7X/F2wpZNGX0HYX0iyQtyebF78GVWkF32z4
         IOvCzR/d8d+CmBiGgcebGWz9k+LEt9A/jCAIigpexcbo4QyAKnNA9aO2j+9wOQa4d2y/
         oOf9gtocSfN4L9pbwrsGk5xJqW/TJ/ZSzMxZhNPf+O/gb+l1rPNkdB5l5yffaPZ+Csw0
         lNfnYCP4g35td4glrGjL8ddPJUJpaByqsf3rjV3CglRxNhXtTnHscQ2+n1vl/FXGKpyX
         oB9GO6SJCckJzhFyVFv29VL2qov+3FHuXIm3XwhztSB0b0WqfP0uU4oCfqSqS1dLmmcf
         sbsg==
X-Gm-Message-State: APjAAAW6Q+JM8RZ95OCq79HF4OCVGjoqkT5Jj4+dJh/ha7l8+przA9gc
	bAFyu/xVgb4KpEupHzPUKdtgZwQABY8=
X-Google-Smtp-Source: APXvYqyELgNbpRvEnc8IGvoT5AHDr+2u0/JFd4cfW+078wvroCn4X8fdrozyNG5RH6fqcoO8wdqHmA==
X-Received: by 2002:a17:906:5907:: with SMTP id h7mr5487722ejq.328.1572384628928;
        Tue, 29 Oct 2019 14:30:28 -0700 (PDT)
X-Received: by 2002:a05:600c:1150:: with SMTP id z16mr6173967wmz.153.1572384627393;
 Tue, 29 Oct 2019 14:30:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-11-thgarnie@chromium.org> <20190731125306.GU31381@hirez.programming.kicks-ass.net>
 <20190812125540.GD23772@zn.tnic>
In-Reply-To: <20190812125540.GD23772@zn.tnic>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Tue, 29 Oct 2019 14:30:15 -0700
X-Gmail-Original-Message-ID: <CAJcbSZG-JhBC9b1JMv1zq2r5uRQipYLtkNjM67sd7=eqy_iOaA@mail.gmail.com>
Message-ID: <CAJcbSZG-JhBC9b1JMv1zq2r5uRQipYLtkNjM67sd7=eqy_iOaA@mail.gmail.com>
Subject: Re: [PATCH v9 10/11] x86/paravirt: Adapt assembly for PIE support
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Kees Cook <keescook@chromium.org>, 
	Juergen Gross <jgross@suse.com>, Thomas Hellstrom <thellstrom@vmware.com>, 
	"VMware, Inc." <pv-drivers@vmware.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, virtualization@lists.linux-foundation.org, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 12, 2019 at 5:54 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Jul 31, 2019 at 02:53:06PM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 30, 2019 at 12:12:54PM -0700, Thomas Garnier wrote:
> > > if PIE is enabled, switch the paravirt assembly constraints to be
> > > compatible. The %c/i constrains generate smaller code so is kept by
> > > default.
> > >
> > > Position Independent Executable (PIE) support will allow to extend the
> > > KASLR randomization range below 0xffffffff80000000.
> > >
> > > Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
> > > Acked-by: Juergen Gross <jgross@suse.com>
> > > ---
> > >  arch/x86/include/asm/paravirt_types.h | 25 +++++++++++++++++++++----
> > >  1 file changed, 21 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> > > index 70b654f3ffe5..fd7dc37d0010 100644
> > > --- a/arch/x86/include/asm/paravirt_types.h
> > > +++ b/arch/x86/include/asm/paravirt_types.h
> > > @@ -338,9 +338,25 @@ extern struct paravirt_patch_template pv_ops;
> > >  #define PARAVIRT_PATCH(x)                                  \
> > >     (offsetof(struct paravirt_patch_template, x) / sizeof(void *))
> > >
> > > +#ifdef CONFIG_X86_PIE
> > > +#define paravirt_opptr_call "a"
> > > +#define paravirt_opptr_type "p"
> > > +
> > > +/*
> > > + * Alternative patching requires a maximum of 7 bytes but the relative call is
> > > + * only 6 bytes. If PIE is enabled, add an additional nop to the call
> > > + * instruction to ensure patching is possible.
> > > + */
> > > +#define PARAVIRT_CALL_POST  "nop;"
> >
> > I'm confused; where does the 7 come from? The relative call is 6 bytes,
>
> Well, before it, the relative CALL is a CALL reg/mem64, i.e. the target
> is mem64. For example:
>
>
> ffffffff81025c45:       ff 14 25 68 37 02 82    callq  *0xffffffff82023768
>
> That address there is practically pv_ops + offset.
>
> Now, in the opcode bytes you have 0xff opcode, ModRM byte 0x14 and SIB
> byte 0x25, and 4 bytes imm32 offset. And this is 7 bytes.
>
> What it becomes is:
>
> ffffffff81025cd0:       ff 15 fa d9 ff 00       callq  *0xffd9fa(%rip)        # ffffffff820236d0 <pv_ops+0x30>
> ffffffff81025cd6:       90                      nop
>
> which is a RIP-relative, i.e., opcode 0xff, ModRM byte 0x15 and imm32.
> And this is 6 bytes.
>
> And since the paravirt patching doesn't do NOP padding like the
> alternatives patching does, you need to pad with a byte.
>
> Thomas, please add the gist of this to the comments because this
> incomprehensible machinery better be documented as detailed as possible.

Sorry for the late reply, busy couple months. Will add it.

>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> Good mailing practices for 400: avoid top-posting and trim the reply.
