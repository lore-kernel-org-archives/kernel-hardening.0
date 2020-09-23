Return-Path: <SRS0=sHrN=DA=lists.openwall.com=kernel-hardening-return-19966-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 094CFC2D0A8
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 09:11:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EC9BE2137B
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 09:11:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uGmOF57r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC9BE2137B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19966-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17803 invoked by uid 550); 23 Sep 2020 09:11:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17775 invoked from network); 23 Sep 2020 09:11:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vw57DoHZqWXx4xymzlnY2cv6nwjJilOmIUjotMaIXOw=;
        b=uGmOF57rr5ir3wAdlX8DbJUFQYeCyGRLwVLuZTKa/TMGKjwtHBeLRN092fsFJUBqBb
         SuUoCfSgVnnf4GLR7NZk09ipWP0t8tVVjaVv9fHjmkv+JNJNLFoaXROJ3JiqOMI+g7JI
         Cgu3TjFR+V/A2os/3tbtCaxBg8kG7KQuCFnlilzzDSPL2NjtzNsZqzJ694Gm63tCBOwM
         /sxKPIq+AzxrUpe0jfLXVERIDkSsHRDS+7YmD5oIK+G2hQPc0rcBC0JreyEHXYhuGtKs
         +edxK73xkevQqkuE+tXmnoaTeJNLfjsBQzEEG+Qpm98ZPXCiVlYr+n8Uq3H15ZH+f6pw
         noSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Vw57DoHZqWXx4xymzlnY2cv6nwjJilOmIUjotMaIXOw=;
        b=Dm86JJ7BnkbJ/YAzxn3iAOtYkReTDMSmRSJgRzn5SLiQC9AsPTFxmppND4orWbCHbr
         nb3diyIi6T27d61KOAFzYKVcXDZpVljPLptyKL0prJr392EF83WAC+lbrEMcFKMBGPHm
         07t4SM0zFlT35E4TiJ1kefBRnvWPJASQNl12jpPeUkTs4nSngPcLoXDbj/kfDfhOkd2M
         8Q9oVO7ftKOYFV5RCFz1nrLrI4vi6gSzYEXKHRRiuryH+3dVZfU3UmEbq32v6kfUQ8Ik
         YwKM7lQGFkcLMrnDuGJPtASYATNq2+Jaq+wWZy+cjKwbNcIddYPpiL+8R5GU1PWEZeNv
         GI8A==
X-Gm-Message-State: AOAM531BkZ3sMxdOqjRK2EVtEYlgY2WOZ396DBijE2krOlNPA8o/2Pfw
	QssII7uPXOmWlX1eM2fimTo=
X-Google-Smtp-Source: ABdhPJz8KuC6aUCmaAzrq7TnqiwL4nJshKmmil9Y7NRnJ5NrQuLaaXEQ3bxRj/TVJoC2K9hOXX24yQ==
X-Received: by 2002:a05:620a:4fb:: with SMTP id b27mr9342851qkh.120.1600852288175;
        Wed, 23 Sep 2020 02:11:28 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Wed, 23 Sep 2020 05:11:25 -0400
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
	Florian Weimer <fw@deneb.enyo.de>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org, libffi-discuss@sourceware.org, luto@kernel.org,
	David.Laight@ACULAB.COM, mark.rutland@arm.com, mic@digikod.net,
	pavel@ucw.cz
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200923091125.GB1240819@rani.riverdale.lan>
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
 <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
 <20200923014616.GA1216401@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200923014616.GA1216401@rani.riverdale.lan>

On Tue, Sep 22, 2020 at 09:46:16PM -0400, Arvind Sankar wrote:
> On Thu, Sep 17, 2020 at 10:36:02AM -0500, Madhavan T. Venkataraman wrote:
> > 
> > 
> > On 9/16/20 8:04 PM, Florian Weimer wrote:
> > > * madvenka:
> > > 
> > >> Examples of trampolines
> > >> =======================
> > >>
> > >> libffi (A Portable Foreign Function Interface Library):
> > >>
> > >> libffi allows a user to define functions with an arbitrary list of
> > >> arguments and return value through a feature called "Closures".
> > >> Closures use trampolines to jump to ABI handlers that handle calling
> > >> conventions and call a target function. libffi is used by a lot
> > >> of different applications. To name a few:
> > >>
> > >> 	- Python
> > >> 	- Java
> > >> 	- Javascript
> > >> 	- Ruby FFI
> > >> 	- Lisp
> > >> 	- Objective C
> > > 
> > > libffi does not actually need this.  It currently collocates
> > > trampolines and the data they need on the same page, but that's
> > > actually unecessary.  It's possible to avoid doing this just by
> > > changing libffi, without any kernel changes.
> > > 
> > > I think this has already been done for the iOS port.
> > > 
> > 
> > The trampoline table that has been implemented for the iOS port (MACH)
> > is based on PC-relative data referencing. That is, the code and data
> > are placed in adjacent pages so that the code can access the data using
> > an address relative to the current PC.
> > 
> > This is an ISA feature that is not supported on all architectures.
> > 
> > Now, if it is a performance feature, we can include some architectures
> > and exclude others. But this is a security feature. IMO, we cannot
> > exclude any architecture even if it is a legacy one as long as Linux
> > is running on the architecture. So, we need a solution that does
> > not assume any specific ISA feature.
> 
> Which ISA does not support PIC objects? You mentioned i386 below, but
> i386 does support them, it just needs to copy the PC into a GPR first
> (see below).
> 
> > 
> > >> The code for trampoline X in the trampoline table is:
> > >>
> > >> 	load	&code_table[X], code_reg
> > >> 	load	(code_reg), code_reg
> > >> 	load	&data_table[X], data_reg
> > >> 	load	(data_reg), data_reg
> > >> 	jump	code_reg
> > >>
> > >> The addresses &code_table[X] and &data_table[X] are baked into the
> > >> trampoline code. So, PC-relative data references are not needed. The user
> > >> can modify code_table[X] and data_table[X] dynamically.
> > > 
> > > You can put this code into the libffi shared object and map it from
> > > there, just like the rest of the libffi code.  To get more
> > > trampolines, you can map the page containing the trampolines multiple
> > > times, each instance preceded by a separate data page with the control
> > > information.
> > > 
> > 
> > If you put the code in the libffi shared object, how do you pass data to
> > the code at runtime? If the code we are talking about is a function, then
> > there is an ABI defined way to pass data to the function. But if the
> > code we are talking about is some arbitrary code such as a trampoline,
> > there is no ABI defined way to pass data to it except in a couple of
> > platforms such as HP PA-RISC that have support for function descriptors
> > in the ABI itself.
> > 
> > As mentioned before, if the ISA supports PC-relative data references
> > (e.g., X86 64-bit platforms support RIP-relative data references)
> > then we can pass data to that code by placing the code and data in
> > adjacent pages. So, you can implement the trampoline table for X64.
> > i386 does not support it.
> > 
> 
> i386 just needs a tiny bit of code to copy the PC into a GPR first, i.e.
> the trampoline would be:
> 
> 	call	1f
> 1:	pop	%data_reg
> 	movl	(code_table + X - 1b)(%data_reg), %code_reg
> 	movl	(data_table + X - 1b)(%data_reg), %data_reg
> 	jmp	*(%code_reg)
> 
> I do not understand the point about passing data at runtime. This
> trampoline is to achieve exactly that, no? 
> 
> Thanks.

For libffi, I think the proposed standard trampoline won't actually
work, because not all ABIs have two scratch registers available to use
as code_reg and data_reg. Eg i386 fastcall only has one, and register
has zero scratch registers. I believe 32-bit ARM only has one scratch
register as well.

For i386 you'd need something that saves a register on the stack first,
maybe like the below with a 16-byte trampoline and a 16-byte context
structure that has the address of the code to jump to in the first
dword:

	.balign 4096
	trampoline_page:

	.rept	4096/16-1
	0:	endbr32
		push	%eax
		call	__x86.get_pc_thunk.ax
	1:	jmp	trampoline
	.balign 16
	.endr

	.org trampoline_page + 4096 - 16
	__x86.get_pc_thunk.ax:
		movl	(%esp), %eax
		ret
	trampoline:
		subl	$(1b-0b), %eax
		jmp	*(table-trampoline_page)(%eax)

	.org trampoline_page + 4096
	table:
