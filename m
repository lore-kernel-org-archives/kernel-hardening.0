Return-Path: <kernel-hardening-return-21505-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id AF11DC433F5
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Nov 2021 20:24:46 +0000 (UTC)
Received: (qmail 30142 invoked by uid 550); 26 Nov 2021 20:24:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30122 invoked from network); 26 Nov 2021 20:24:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1637958265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VaMSLSvOMBZUZjoiq/5xjj3U/SyEVvXyMfJTnAZhnLg=;
	b=a7O+hw60G2JWCmVWKGGQA+Hulgj7m3WyyENUewG9x7CJnKopwGRh5HwxQIllJFdmPEM4Di
	FtAaGYi6otACcn/oZ7tV1R1H2gAmU0cBZoZ1OHb40Gxis17suyvCsPq8qakpc97hjzIkdo
	hbDNGZzzbkzgRH3OOyzrwOb9Iq3mBBg=
X-MC-Unique: fN5c24S2MZKxNZ159z5v3g-1
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
Date: Fri, 26 Nov 2021 21:24:16 +0100
In-Reply-To: <4728eeae-8f1b-4541-b05a-4a0f35a459f7@www.fastmail.com> (Andy
	Lutomirski's message of "Fri, 26 Nov 2021 10:58:26 -0800")
Message-ID: <87lf1ais27.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

* Andy Lutomirski:

> On Fri, Nov 26, 2021, at 5:47 AM, Florian Weimer wrote:
>> Distributions struggle with changing the default for vsyscall
>> emulation because it is a clear break of userspace ABI, something
>> that should not happen.
>>
>> The legacy vsyscall interface is supposed to be used by libcs only,
>> not by applications.  This commit adds a new arch_prctl request,
>> ARCH_VSYSCALL_LOCKOUT.  Newer libcs can adopt this request to signal
>> to the kernel that the process does not need vsyscall emulation.
>> The kernel can then disable it for the remaining lifetime of the
>> process.  Legacy libcs do not perform this call, so vsyscall remains
>> enabled for them.  This approach should achieves backwards
>> compatibility (perfect compatibility if the assumption that only libcs
>> use vsyscall is accurate), and it provides full hardening for new
>> binaries.
>
> Why is a lockout needed instead of just a toggle?  By the time an
> attacker can issue prctls, an emulated vsyscall seems like a pretty
> minor exploit technique.  And programs that load legacy modules or
> instrument other programs might need to re-enable them.

For glibc, I plan to add an environment variable to disable the lockout.
There's no ELF markup that would allow us to do this during dlopen.
(And after this change, you can run an old distribution in a chroot
for legacy software, something that the userspace ABI break prevents.)

If it can be disabled, people will definitely say, =E2=80=9Cwe get more com=
plete
hardening if we break old userspace=E2=80=9D.  I want to avoid that.  (Peop=
le
will say that anyway because there's this fairly large window of libcs
that don't use vsyscalls anymore, but have not been patched yet to do
the lockout.)

Maybe the lockout also simplifies the implementation?

> Also, the interaction with emulate mode is somewhat complex. For now,
> let=E2=80=99s support this in xonly mode only. A complete implementation =
will
> require nontrivial mm work.  I had that implemented pre-KPTI, but KPTI
> made it more complicated.

I admit I only looked at the code in emulate_vsyscall.  It has code that
seems to deal with faults not due to instruction fetch, and also checks
for vsyscall=3Demulate mode.  But it seems that we don't get to this point
for reads in vsyscall=3Demulate mode, presumably because the page is
already mapped?

> Finally, /proc/self/maps should be wired up via the gate_area code.

Should the "[vsyscall]" string change to something else if execution is
disabled?

Thanks,
Florian

