Return-Path: <SRS0=k0rV=DA=lists.openwall.com=kernel-hardening-return-19962-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 456D8C4363D
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 01:46:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 23C3E238A1
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 01:46:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uhilotA2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 23C3E238A1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19962-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26232 invoked by uid 550); 23 Sep 2020 01:46:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26203 invoked from network); 23 Sep 2020 01:46:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ssYhrlHCw7Ub9xPyJrNfDQfuZKnG7yNmanf9qk5D/30=;
        b=uhilotA2RIu/i3TSt6riD62hHewNX0HCYmMAm6Yecx7s6wLqAfVdwPC94TV27TBtq4
         +0q0YajK8JyGTHcprchBDFv2ayV59vk0oXGyJlBiFXIqPW4j7qGv0v4IRsopqpngRSr1
         Sy4HfLiaqVt6AkHeytLRBjGlCNtInHzH2aFM4TGr3Pn3QrgB/tRSBLBkE+o0ihGxfUiX
         dhbC8CXns3F1amdB7aenJ/Cxc4yWDSvifq4ZHXkuT03S+tFjT5yxE/eAMet3CHs3A7Hk
         OXdUPZQvllLZfjnidcNs42c0LsQ0538v8PzsgpNJMClW1XGO0YSC62irz5h/fviXUgUI
         YbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ssYhrlHCw7Ub9xPyJrNfDQfuZKnG7yNmanf9qk5D/30=;
        b=tgkvzpYSpPhBioJwK0YHlH8e2ieuI53iGMAMVVkIONxPbxah1KFR5EB39nLo0G/3VQ
         kLnHXlu3rv6spiW7aN7Xpm85P6empdASRRKmTEc4t7BcrNLpHiEW8wAM8Qj9LJ9mcZ0J
         pOf8DWfnGReMhB4D16QeXhZfDRjcWmaUvHVEk0Ku9jgRWh5Q97jQLY4dnfYlQaXhlnhf
         1ZCVOFTiJy7qkxOp43ZW9Lztwb+jd5N81yjkErVjaUDY/Fa0FWH/1lQlEZuLwiwTVWJb
         r5LF41gmQplkoAfoN+DPcQ5s8eZOCCQ0inv/T1UEtC4ixRqjiBo5t6Q5ytDFKLlK5oNp
         d9HA==
X-Gm-Message-State: AOAM530u8mFL5CGZ/MyABoGK7QJX2KFxMtdmW+l3JTBmZj3TyI0ME0AM
	AluGFZIcKpeo6cWgLwWlOmI=
X-Google-Smtp-Source: ABdhPJx+f5G7LH8pGHaNrTcMRrb4zK95unM48fxm9EqaXus2Z/Ijl+3SuFhTwPqbe2UA1MqvfJS/1Q==
X-Received: by 2002:a0c:cdc4:: with SMTP id a4mr9110819qvn.31.1600825579406;
        Tue, 22 Sep 2020 18:46:19 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Tue, 22 Sep 2020 21:46:16 -0400
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Florian Weimer <fw@deneb.enyo.de>, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	oleg@redhat.com, x86@kernel.org, libffi-discuss@sourceware.org,
	luto@kernel.org, David.Laight@ACULAB.COM, mark.rutland@arm.com,
	mic@digikod.net, pavel@ucw.cz
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200923014616.GA1216401@rani.riverdale.lan>
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
 <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>

On Thu, Sep 17, 2020 at 10:36:02AM -0500, Madhavan T. Venkataraman wrote:
> 
> 
> On 9/16/20 8:04 PM, Florian Weimer wrote:
> > * madvenka:
> > 
> >> Examples of trampolines
> >> =======================
> >>
> >> libffi (A Portable Foreign Function Interface Library):
> >>
> >> libffi allows a user to define functions with an arbitrary list of
> >> arguments and return value through a feature called "Closures".
> >> Closures use trampolines to jump to ABI handlers that handle calling
> >> conventions and call a target function. libffi is used by a lot
> >> of different applications. To name a few:
> >>
> >> 	- Python
> >> 	- Java
> >> 	- Javascript
> >> 	- Ruby FFI
> >> 	- Lisp
> >> 	- Objective C
> > 
> > libffi does not actually need this.  It currently collocates
> > trampolines and the data they need on the same page, but that's
> > actually unecessary.  It's possible to avoid doing this just by
> > changing libffi, without any kernel changes.
> > 
> > I think this has already been done for the iOS port.
> > 
> 
> The trampoline table that has been implemented for the iOS port (MACH)
> is based on PC-relative data referencing. That is, the code and data
> are placed in adjacent pages so that the code can access the data using
> an address relative to the current PC.
> 
> This is an ISA feature that is not supported on all architectures.
> 
> Now, if it is a performance feature, we can include some architectures
> and exclude others. But this is a security feature. IMO, we cannot
> exclude any architecture even if it is a legacy one as long as Linux
> is running on the architecture. So, we need a solution that does
> not assume any specific ISA feature.

Which ISA does not support PIC objects? You mentioned i386 below, but
i386 does support them, it just needs to copy the PC into a GPR first
(see below).

> 
> >> The code for trampoline X in the trampoline table is:
> >>
> >> 	load	&code_table[X], code_reg
> >> 	load	(code_reg), code_reg
> >> 	load	&data_table[X], data_reg
> >> 	load	(data_reg), data_reg
> >> 	jump	code_reg
> >>
> >> The addresses &code_table[X] and &data_table[X] are baked into the
> >> trampoline code. So, PC-relative data references are not needed. The user
> >> can modify code_table[X] and data_table[X] dynamically.
> > 
> > You can put this code into the libffi shared object and map it from
> > there, just like the rest of the libffi code.  To get more
> > trampolines, you can map the page containing the trampolines multiple
> > times, each instance preceded by a separate data page with the control
> > information.
> > 
> 
> If you put the code in the libffi shared object, how do you pass data to
> the code at runtime? If the code we are talking about is a function, then
> there is an ABI defined way to pass data to the function. But if the
> code we are talking about is some arbitrary code such as a trampoline,
> there is no ABI defined way to pass data to it except in a couple of
> platforms such as HP PA-RISC that have support for function descriptors
> in the ABI itself.
> 
> As mentioned before, if the ISA supports PC-relative data references
> (e.g., X86 64-bit platforms support RIP-relative data references)
> then we can pass data to that code by placing the code and data in
> adjacent pages. So, you can implement the trampoline table for X64.
> i386 does not support it.
> 

i386 just needs a tiny bit of code to copy the PC into a GPR first, i.e.
the trampoline would be:

	call	1f
1:	pop	%data_reg
	movl	(code_table + X - 1b)(%data_reg), %code_reg
	movl	(data_table + X - 1b)(%data_reg), %data_reg
	jmp	*(%code_reg)

I do not understand the point about passing data at runtime. This
trampoline is to achieve exactly that, no? 

Thanks.
