Return-Path: <kernel-hardening-return-21530-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 70E2AC433EF
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Jan 2022 17:28:12 +0000 (UTC)
Received: (qmail 3276 invoked by uid 550); 13 Jan 2022 17:27:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3233 invoked from network); 13 Jan 2022 17:27:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642094847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6JAs1cBVKVd9apEjPFkt89/bQIVFWGiLVSiodneQbkU=;
	b=Y2WKTAT6tW0wu7nySC3npPZqrEVOfUICkoDZRu154eKuITMH1drMoCGS0WBRi9egjb3bwH
	wy+dr3mtZOBFq7HpD8nTuITHwSsH/n+lDTdFfBXsdRJWmXGjdbVWjCKxbuCDZ/1KnCavLt
	32/4FfOwe67LvyjwwB6a5UGPQLPowxg=
X-MC-Unique: 3VuFLHQSP1u5wqMgynuaxw-1
From: Florian Weimer <fweimer@redhat.com>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: linux-arch@vger.kernel.org,  "Linux API" <linux-api@vger.kernel.org>,
  linux-x86_64@vger.kernel.org,  kernel-hardening@lists.openwall.com,
  linux-mm@kvack.org,  "the arch/x86 maintainers" <x86@kernel.org>,
  musl@lists.openwall.com,  <libc-alpha@sourceware.org>,
  <linux-kernel@vger.kernel.org>,  "Dave Hansen" <dave.hansen@intel.com>,
  "Kees Cook" <keescook@chromium.org>,  Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v3 1/3] x86: Implement arch_prctl(ARCH_VSYSCALL_CONTROL)
 to disable vsyscall
References: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com>
Date: Thu, 13 Jan 2022 18:27:15 +0100
In-Reply-To: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com>
	(Florian Weimer's message of "Wed, 05 Jan 2022 17:02:48 +0100")
Message-ID: <874k67zguk.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13

* Florian Weimer:

> Distributions struggle with changing the default for vsyscall
> emulation because it is a clear break of userspace ABI, something
> that should not happen.
>
> The legacy vsyscall interface is supposed to be used by libcs only,
> not by applications.  This commit adds a new arch_prctl request,
> ARCH_VSYSCALL_CONTROL, with one argument.  If the argument is 0,
> executing vsyscalls will cause the process to terminate.  Argument 1
> turns vsyscall back on (this is mostly for a largely theoretical
> CRIU use case).
>
> Newer libcs can use a zero ARCH_VSYSCALL_CONTROL at startup to disable
> vsyscall for the process.  Legacy libcs do not perform this call, so
> vsyscall remains enabled for them.  This approach should achieves
> backwards compatibility (perfect compatibility if the assumption that
> only libcs use vsyscall is accurate), and it provides full hardening
> for new binaries.
>
> The chosen value of ARCH_VSYSCALL_CONTROL should avoid conflicts
> with other x86-64 arch_prctl requests.  The fact that with
> vsyscall=emulate, reading the vsyscall region is still possible
> even after a zero ARCH_VSYSCALL_CONTROL is considered limitation
> in the current implementation and may change in a future kernel
> version.
>
> Future arch_prctls requests commonly used at process startup can imply
> ARCH_VSYSCALL_CONTROL with a zero argument, so that a separate system
> call for disabling vsyscall is avoided.
>
> Signed-off-by: Florian Weimer <fweimer@redhat.com>
> Acked-by: Andrei Vagin <avagin@gmail.com>
> ---
> v3: Remove warning log message.  Split out test.
> v2: ARCH_VSYSCALL_CONTROL instead of ARCH_VSYSCALL_LOCKOUT.  New tests
>     for the toggle behavior.  Implement hiding [vsyscall] in
>     /proc/PID/maps and test it.  Various other test fixes cleanups
>     (e.g., fixed missing second argument to gettimeofday).
>
> arch/x86/entry/vsyscall/vsyscall_64.c | 7 ++++++-
>  arch/x86/include/asm/mmu.h            | 6 ++++++
>  arch/x86/include/uapi/asm/prctl.h     | 2 ++
>  arch/x86/kernel/process_64.c          | 7 +++++++
>  4 files changed, 21 insertions(+), 1 deletion(-)

Hello,

sorry to bother you again.  What can I do to move this forward?

Thanks,
Florian

