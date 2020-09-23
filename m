Return-Path: <SRS0=UVSp=DA=lists.openwall.com=kernel-hardening-return-19983-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D722C2D0A8
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 18:10:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2A09120791
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 18:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGNukZ1X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A09120791
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19983-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1620 invoked by uid 550); 23 Sep 2020 18:09:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1573 invoked from network); 23 Sep 2020 18:09:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600884584;
	bh=0sQpYjrO1FEOUdJEyt75wZRgQiNVOyCLQf75CE6PFHk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oGNukZ1XzS6+01unsngiaWE+87lr66kpPInuBoy/nJdJAwRXJ3MMlxk++8egYoI+l
	 uYqjaOFRo6XImKO5Xgc7VG7K8JPLOLjY/WBGg+8qNiErRQvMbi06E9ylJM0RYc2rP3
	 xNjnr+21fWQcIlSZqvNMaM83CpvisjcgTDpWjjiw=
X-Gm-Message-State: AOAM531gWBkeGjmi/JGur/DygVjj53YrTH7kUF1Zj4FXpGflvGJQGXtF
	vZYynatDK3xth+BYg6GWyctZqfBIQazecuGgtI3AHA==
X-Google-Smtp-Source: ABdhPJwfMfqd9rmUBSaNu+esX7OO7HDQLQ/5mB6cl8BJqHE3Ip+CBSog/eVQL5KyNSbUahOo8NC7kD0pV+eTdSv397I=
X-Received: by 2002:adf:a3c3:: with SMTP id m3mr947291wrb.70.1600884582830;
 Wed, 23 Sep 2020 11:09:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200922215326.4603-1-madvenka@linux.microsoft.com>
 <20200923081426.GA30279@amd> <20200923091456.GA6177@openwall.com> <87wo0ko8v0.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87wo0ko8v0.fsf@oldenburg2.str.redhat.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 23 Sep 2020 11:09:29 -0700
X-Gmail-Original-Message-ID: <CALCETrUqct4tDrjTSzJG4+=+cEaaDbZ+Mx=LAUdQjVV=CruUcw@mail.gmail.com>
Message-ID: <CALCETrUqct4tDrjTSzJG4+=+cEaaDbZ+Mx=LAUdQjVV=CruUcw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
To: Florian Weimer <fweimer@redhat.com>
Cc: Solar Designer <solar@openwall.com>, Pavel Machek <pavel@ucw.cz>, 
	"Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	linux-integrity <linux-integrity@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	LSM List <linux-security-module@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	X86 ML <x86@kernel.org>, Andrew Lutomirski <luto@kernel.org>, David Laight <David.Laight@aculab.com>, 
	Mark Rutland <mark.rutland@arm.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	Rich Felker <dalias@libc.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 23, 2020 at 7:39 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Solar Designer:
>
> > While I share my opinion here, I don't mean that to block Madhavan's
> > work.  I'd rather defer to people more knowledgeable in current userland
> > and ABI issues/limitations and plans on dealing with those, especially
> > to Florian Weimer.  I haven't seen Florian say anything specific for or
> > against Madhavan's proposal, and I'd like to.  (Have I missed that?)
>
> There was a previous discussion, where I provided feedback (not much
> different from the feedback here, given that the mechanism is mostly the
> same).
>
> I think it's unnecessary for the libffi use case.  Precompiled code can
> be loaded from disk because the libffi trampolines are so regular.  On
> most architectures, it's not even the code that's patched, but some of
> the data driving it, which happens to be located on the same page due to
> a libffi quirk.
>
> The libffi use case is a bit strange anyway: its trampolines are
> type-generic, and the per-call adjustment is data-driven.  This means
> that once you have libffi in the process, you have a generic
> data-to-function-call mechanism available that can be abused (it's even
> fully CET compatible in recent versions).  And then you need to look at
> the processes that use libffi.  A lot of them contain bytecode
> interpreters, and those enable data-driven arbitrary code execution as
> well.  I know that there are efforts under way to harden Python, but
> it's going to be tough to get to the point where things are still
> difficult for an attacker once they have the ability to make mprotect
> calls.
>
> It was pointed out to me that libffi is doing things wrong, and the
> trampolines should not be type-generic, but generated so that they match
> the function being called.  That is, the marshal/unmarshal code would be
> open-coded in the trampoline, rather than using some generic mechanism
> plus run-time dispatch on data tables describing the function type.
> That is a very different design (and typically used by compilers (JIT or
> not JIT) to implement native calls).  Mapping some code page with a
> repeating pattern would no longer work to defeat anti-JIT measures
> because it's closer to real JIT.  I don't know if kernel support could
> make sense in this context, but it would be a completely different
> patch.

I would very much like to see a well-designed kernel facility for
helping userspace do JIT in a safer manner, but designing such a thing
is likely to be distinctly nontrivial.  To throw a half-backed idea
out there, suppose a program could pre-declare a list of JIT
verifiers:

static bool ffi_trampoline_verifier(void *target_address, size_t
target_size, void *source_data, void *context);

struct jit_verifier {
  .magic = 0xMAGIC_HERE,
  .verifier = ffi_trampoline_verifier,
} my_verifier __attribute((section("something special here?)));

and then a system call something like:

instantiate_jit_code(target, source, size, &my_verifier, context);

The idea being that even an attacker that can force a call to
instantiate_jit_code() can only create code that passes verification
by one of the pre-declared verifiers in the process.
