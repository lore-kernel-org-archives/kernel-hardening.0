Return-Path: <SRS0=sM43=BJ=lists.openwall.com=kernel-hardening-return-19503-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BF6C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 20:54:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B9FFA20829
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 20:54:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="o9dMLI7V"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9FFA20829
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19503-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3931 invoked by uid 550); 30 Jul 2020 20:54:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3908 invoked from network); 30 Jul 2020 20:54:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596142458;
	bh=kjsUMa7W/2716/E66O9BRcoDTvK1hMoraL3jFZhSbhQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=o9dMLI7V7xLay/4FEvc5ZBCLpWIPaCqr6MXAhd3v41abR8skQqLAzbrq08+887reU
	 wRySApjBQKeQ5VZq/RrsOM5e6cbno9eOfSVO8kC1+jgM4mvZwzHMUrYvd4E6R5+giP
	 WaOsgZjN1HyUHoKP9cFT3MNatWBEDqakktTzyWTE=
X-Gm-Message-State: AOAM530QYdiHQdScgTZzW05noJH0gGEgYeTn9/yV6dhPtinvlgT9q8VE
	0sYVJWzQ310JQM7VK4Mi5ExjWUy/ixDmplMVGLhBww==
X-Google-Smtp-Source: ABdhPJzKLFb8fOLe7ajuISL9Za2Aj4/QcGOi3NXA9PDpcRSYfLFS4b/xrq0MWMJYlHADmhXcVVN9ubUqp0AHIqmO1Bk=
X-Received: by 2002:adf:fa85:: with SMTP id h5mr509001wrr.18.1596142456738;
 Thu, 30 Jul 2020 13:54:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com> <6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
In-Reply-To: <6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 30 Jul 2020 13:54:03 -0700
X-Gmail-Original-Message-ID: <CALCETrWnNR5v3ZCLfBVQGYK8M0jAvQMaAc9uuO05kfZuh-4d6w@mail.gmail.com>
Message-ID: <CALCETrWnNR5v3ZCLfBVQGYK8M0jAvQMaAc9uuO05kfZuh-4d6w@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux API <linux-api@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	linux-integrity <linux-integrity@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	LSM List <linux-security-module@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2020 at 7:24 AM Madhavan T. Venkataraman
<madvenka@linux.microsoft.com> wrote:
>
> Sorry for the delay. I just wanted to think about this a little.
> In this email, I will respond to your first suggestion. I will
> respond to the rest in separate emails if that is alright with
> you.
>
> On 7/28/20 12:31 PM, Andy Lutomirski wrote:
>
> On Jul 28, 2020, at 6:11 AM, madvenka@linux.microsoft.com wrote:
>
> =EF=BB=BFFrom: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>
> The kernel creates the trampoline mapping without any permissions. When
> the trampoline is executed by user code, a page fault happens and the
> kernel gets control. The kernel recognizes that this is a trampoline
> invocation. It sets up the user registers based on the specified
> register context, and/or pushes values on the user stack based on the
> specified stack context, and sets the user PC to the requested target
> PC. When the kernel returns, execution continues at the target PC.
> So, the kernel does the work of the trampoline on behalf of the
> application.
>
> This is quite clever, but now I=E2=80=99m wondering just how much kernel =
help
> is really needed. In your series, the trampoline is an non-executable
> page.  I can think of at least two alternative approaches, and I'd
> like to know the pros and cons.
>
> 1. Entirely userspace: a return trampoline would be something like:
>
> 1:
> pushq %rax
> pushq %rbc
> pushq %rcx
> ...
> pushq %r15
> movq %rsp, %rdi # pointer to saved regs
> leaq 1b(%rip), %rsi # pointer to the trampoline itself
> callq trampoline_handler # see below
>
> You would fill a page with a bunch of these, possibly compacted to get
> more per page, and then you would remap as many copies as needed.  The
> 'callq trampoline_handler' part would need to be a bit clever to make
> it continue to work despite this remapping.  This will be *much*
> faster than trampfd. How much of your use case would it cover?  For
> the inverse, it's not too hard to write a bit of asm to set all
> registers and jump somewhere.
>
> Let me state what I have understood about this suggestion. Correct me if
> I get anything wrong. If you don't mind, I will also take the liberty
> of generalizing and paraphrasing your suggestion.
>
> The goal is to create two page mappings that are adjacent to each other:
>
> - a code page that contains template code for a trampoline. Since the
>  template code would tend to be small in size, pack as many of them
>  as possible within a page to conserve memory. In other words, create
>  an array of the template code fragments. Each element in the array
>  would be used for one trampoline instance.
>
> - a data page that contains an array of data elements. Corresponding
>  to each code element in the code page, there would be a data element
>  in the data page that would contain data that is specific to a
>  trampoline instance.
>
> - Code will access data using PC-relative addressing.
>
> The management of the code pages and allocation for each trampoline
> instance would all be done in user space.
>
> Is this the general idea?

Yes.

>
> Creating a code page
> --------------------
>
> We can do this in one of the following ways:
>
> - Allocate a writable page at run time, write the template code into
>   the page and have execute permissions on the page.
>
> - Allocate a writable page at run time, write the template code into
>   the page and remap the page with just execute permissions.
>
> - Allocate a writable page at run time, write the template code into
>   the page, write the page into a temporary file and map the file with
>   execute permissions.
>
> - Include the template code in a code page at build time itself and
>   just remap the code page each time you need a code page.

This latter part shouldn't need any special permissions as far as I know.

>
> Pros and Cons
> -------------
>
> As long as the OS provides the functionality to do this and the security
> subsystem in the OS allows the actions, this is totally feasible. If not,
> we need something like trampfd.
>
> As Floren mentioned, libffi does implement something like this for MACH.
>
> In fact, in my libffi changes, I use trampfd only after all the other met=
hods
> have failed because of security settings.
>
> But the above approach only solves the problem for this simple type of
> trampoline. It does not provide a framework for addressing more complex t=
ypes
> or even other forms of dynamic code.
>
> Also, each application would need to implement this solution for itself
> as opposed to relying on one implementation provided by the kernel.

I would argue this is a benefit.  If the whole implementation is in
userspace, there is no ABI compatibility issue.  The user program
contains the trampoline code and the code that uses it.

>
> Trampfd-based solution
> ----------------------
>
> I outlined an enhancement to trampfd in a response to David Laight. In th=
is
> enhancement, the kernel is the one that would set up the code page.
>
> The kernel would call an arch-specific support function to generate the
> code required to load registers, push values on the stack and jump to a P=
C
> for a trampoline instance based on its current context. The trampoline
> instance data could be baked into the code.
>
> My initial idea was to only have one trampoline instance per page. But I
> think I can implement multiple instances per page. I just have to manage
> the trampfd file private data and VMA private data accordingly to map an
> element in a code page to its trampoline object.
>
> The two approaches are similar except for the detail about who sets up
> and manages the trampoline pages. In both approaches, the performance pro=
blem
> is addressed. But trampfd can be used even when security settings are
> restrictive.
>
> Is my solution acceptable?

Perhaps.  In general, before adding a new ABI to the kernel, it's nice
to understand how it's better than doing the same thing in userspace.
Saying that it's easier for user code to work with if it's in the
kernel isn't necessarily an adequate justification.

Why would remapping two pages of actual application text ever fail?
