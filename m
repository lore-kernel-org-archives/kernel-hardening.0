Return-Path: <kernel-hardening-return-21539-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by smtp.lore.kernel.org (Postfix) with SMTP id 73BCCC433EF
	for <kernel-hardening@archiver.kernel.org>; Fri, 14 Jan 2022 13:36:53 +0000 (UTC)
Received: (qmail 19832 invoked by uid 550); 14 Jan 2022 13:36:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19812 invoked from network); 14 Jan 2022 13:36:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1642167393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n+u9lImGJHsltEhgnOxi+5lKtT79IMZvETmYQxQXldM=;
	b=Ho1pcNbDqKUWSpdCjhfeO6emBuO6G2ARwfuIgXjrxa19ots/Yo1mrE+SOD0dWf6t16zx6k
	YXZHSoSqbTAsvJgaGRv9MXXFdTnMWRIVTZ7aVh9q8gpHOYQEG4n32P7eg9z0bDCR/BMBZ0
	QweIy/+US7QgDYG/NiDwqm2UvrfKkG8=
X-MC-Unique: eQAah2ufPRiIcSj7ZNrWFg-1
From: Florian Weimer <fweimer@redhat.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: linux-arch@vger.kernel.org,  Linux API <linux-api@vger.kernel.org>,
  linux-x86_64@vger.kernel.org,  kernel-hardening@lists.openwall.com,
  linux-mm@kvack.org,  the arch/x86 maintainers <x86@kernel.org>,
  musl@lists.openwall.com,  libc-alpha@sourceware.org,
  linux-kernel@vger.kernel.org,  Dave Hansen <dave.hansen@intel.com>,  Kees
 Cook <keescook@chromium.org>,  Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v3 1/3] x86: Implement arch_prctl(ARCH_VSYSCALL_CONTROL)
 to disable vsyscall
References: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com>
	<e431fa42-26ec-8ac6-f954-e681b1e0e9a6@kernel.org>
Date: Fri, 14 Jan 2022 14:36:24 +0100
In-Reply-To: <e431fa42-26ec-8ac6-f954-e681b1e0e9a6@kernel.org> (Andy
	Lutomirski's message of "Thu, 13 Jan 2022 13:47:26 -0800")
Message-ID: <87sftqtp5z.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

* Andy Lutomirski:

> Is there a reason you didn't just change the check earlier in the
> function to:
>
> if (vsyscall_mode == NONE || current->mm->context.vsyscall_disabled)

Andrei requested that I don't print anything if vsyscall was disabled.

The original patch used a different message for better diagnostics.

> Also, I still think the prctl should not be available if
> vsyscall=emulate.  Either we should fully implement it or we should
> not implement.  We could even do:
>
> pr_warn_once("userspace vsyscall hardening request ignored because you
> have vsyscall=emulate.  Unless you absolutely need vsyscall=emulate, 
> update your system to use vsyscall=xonly.\n");
>
> and thus encourage good behavior.

I think there is still some hardening applied even with
vsyscall=emulate.  The question is what is more important: the
additional hardening, or clean, easily described behavior of the
interface.

Maybe ARCH_VSYSCALL_CONTROL could return different values based on to
what degree it could disable vsyscall?

The pr_warn_once does not seem particularly useful.  Anyone who upgrades
glibc and still uses vsyscall=emulate will see that, with no way to
disable it.

Thanks,
Florian

