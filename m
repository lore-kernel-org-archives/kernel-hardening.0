Return-Path: <kernel-hardening-return-21518-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 959DAC433EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Dec 2021 18:31:58 +0000 (UTC)
Received: (qmail 7648 invoked by uid 550); 16 Dec 2021 18:31:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7623 invoked from network); 16 Dec 2021 18:31:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639679490;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n1bFBT5IB/gpnuuiEdK1jZq3mJoWjFnaUGhMpk4YpP0=;
	b=h0XfPzXVtt0Dl9CuWTR+ea1Ug3gVbwONMCCkVF1/zEwlo7eC4VbqPNvvtAHO9zFEds1ia5
	xfjHDVZvDT78o1bIpjGOsRhW8r59VukgP9UnoqCkfV6jcB/nI5npz9YIA1ZDFJIEYORgeh
	EDovfY4CfxZEHVbMeRGdslafIPmRYfI=
X-MC-Unique: EqnyuIOYP4Ku2VG9jSpmOA-1
From: Florian Weimer <fweimer@redhat.com>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: linux-arch@vger.kernel.org,  "Linux API" <linux-api@vger.kernel.org>,
  linux-x86_64@vger.kernel.org,  kernel-hardening@lists.openwall.com,
  linux-mm@kvack.org,  "the arch/x86 maintainers" <x86@kernel.org>,
  musl@lists.openwall.com,  "Dave Hansen via Libc-alpha"
 <libc-alpha@sourceware.org>,  "Linux Kernel Mailing List"
 <linux-kernel@vger.kernel.org>,  "Dave Hansen" <dave.hansen@intel.com>,
  "Kees Cook" <keescook@chromium.org>
Subject: Re: [PATCH] x86: Implement arch_prctl(ARCH_VSYSCALL_LOCKOUT) to
 disable vsyscall
References: <87h7bzjaer.fsf@oldenburg.str.redhat.com>
	<4728eeae-8f1b-4541-b05a-4a0f35a459f7@www.fastmail.com>
	<87lf1ais27.fsf@oldenburg.str.redhat.com>
	<9641b76e-9ae0-4c26-97b6-76ecde34f0ef@www.fastmail.com>
	<878rxaik09.fsf@oldenburg.str.redhat.com>
	<3b5fb404-7228-48d6-a290-9dd1d6095325@www.fastmail.com>
Date: Thu, 16 Dec 2021 19:31:19 +0100
In-Reply-To: <3b5fb404-7228-48d6-a290-9dd1d6095325@www.fastmail.com> (Andy
	Lutomirski's message of "Sat, 27 Nov 2021 20:45:23 -0800")
Message-ID: <87czlwieq0.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23

* Andy Lutomirski:

> This could possibly be much more generic: have a mask of legacy
> features to disable and a separate mask of lock bits.

Is that really necessary?  Adding additional ARCH_* constants does not
seem to be particularly onerous and helps with detection of kernel
support.

>> I can turn this into a toggle, and we could probably default our builds
>> to vsyscalls=xonly.  Given the userspace ABI impact, we'd still have to
>> upstream the toggle.  Do you see a chance of a patch a long these lines
>> going in at all, given that it's an incomplete solution for
>> vsyscall=emulate?
>
> There is basically no reason for anyone to use vsyscall=emulate any
> more.  I'm aware of exactly one use case, and it's quite bizarre and
> involves instrumenting an outdated binary with an outdated
> instrumentation tool.  If either one is recent (last few years),
> vsyscall=xonly is fine.

Yeah, we plan to stick to vsyscall=xonly.  This means that the toggle is
easier to implement, of course.

>> Hmm.  But only for vsyscall=xonly, right?  With vsyscall=emulate,
>> reading at those addresses will still succeed.
>
> IMO if vsyscall is disabled for a process, reads and executes should
> both fail.  This is trivial in xonly mode.

Right, I'll document this as a glitch for now.

I've got a v2 (with the toggle rather than pure lockout) and will sent
it out shortly.

Thanks,
Florian

