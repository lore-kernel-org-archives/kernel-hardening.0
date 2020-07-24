Return-Path: <SRS0=jYJ1=BD=lists.openwall.com=kernel-hardening-return-19444-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77692C433E5
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 19:03:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A521C206F6
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 19:03:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="epxr0OVX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A521C206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19444-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5464 invoked by uid 550); 24 Jul 2020 19:03:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5443 invoked from network); 24 Jul 2020 19:03:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LYsHHvmbnOnKOT161wgYJ0QUn66UfJfCSOHkGeru+cM=;
        b=epxr0OVXttEVlXmK9gG8sngCnRWPyA1Tl8s5eFiDuptGA3XfZ7D42jzmy8C+dHex+z
         O4t0er5aVcVIeElSNW4xKoTusneqHOYH3qTX0imlgipraUmww8ZAz/FAdRhZ2XYidyPD
         DxcDODdQ821AGi0c+CClL91b4u9fYF+8edV0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LYsHHvmbnOnKOT161wgYJ0QUn66UfJfCSOHkGeru+cM=;
        b=QjJOOzztyOCUP9yuYGQkwLfkN9C7Qs6RTstVDciChHarxxyDeyvF80FO3QZcEI/2h0
         Zzhdo1RxzM+hVrW395Ln0psHqF+LlloJem9p1hrNbe+CsZNk4uSzivJg9pK78GmSr0Uk
         89FQnYqvjn7SRO3/KiSB4TWJ6KWASQDKDdabFGQfLVmM4Zb9Zpwdnp5t/ga7nBYMNSKe
         +ZbgQ0BK4vfkz2fIBq2L+YWRKhCi5hkiiziT3pBPBH7ts9iApzBa+e0izUHlUog1kEhZ
         qQDb8Y6YL9VEfq2PLJgQptgci2UKztfzPivuHyJ7ts/n8wWPOTuTc+P6TkijLmfQyypb
         vXtQ==
X-Gm-Message-State: AOAM531TKvDoMysow/awEGupIlPrRjC6r53abP94KHHHz69L6RO+jshq
	Vf4X3nkStlAZ1VYzl8MereLgQg==
X-Google-Smtp-Source: ABdhPJxe287CjvKc1vXBSsqo1vqhqr3H+/qMCmeOy+LCVrrgE2glpryiF3Hn9YFdOosrNz2I96GIrw==
X-Received: by 2002:a62:2bd0:: with SMTP id r199mr9978051pfr.160.1595617383058;
        Fri, 24 Jul 2020 12:03:03 -0700 (PDT)
Date: Fri, 24 Jul 2020 12:03:01 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Subject: Re: [PATCH v7 4/7] fs: Introduce O_MAYEXEC flag for openat2(2)
Message-ID: <202007241202.8D07E1F276@keescook>
References: <20200723171227.446711-1-mic@digikod.net>
 <20200723171227.446711-5-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200723171227.446711-5-mic@digikod.net>

On Thu, Jul 23, 2020 at 07:12:24PM +0200, Mickaël Salaün wrote:
> When the O_MAYEXEC flag is passed, openat2(2) may be subject to
> additional restrictions depending on a security policy managed by the
> kernel through a sysctl or implemented by an LSM thanks to the
> inode_permission hook.  This new flag is ignored by open(2) and
> openat(2) because of their unspecified flags handling.  When used with
> openat2(2), the default behavior is only to forbid to open a directory.
> 
> The underlying idea is to be able to restrict scripts interpretation
> according to a policy defined by the system administrator.  For this to
> be possible, script interpreters must use the O_MAYEXEC flag
> appropriately.  To be fully effective, these interpreters also need to
> handle the other ways to execute code: command line parameters (e.g.,
> option -e for Perl), module loading (e.g., option -m for Python), stdin,
> file sourcing, environment variables, configuration files, etc.
> According to the threat model, it may be acceptable to allow some script
> interpreters (e.g. Bash) to interpret commands from stdin, may it be a
> TTY or a pipe, because it may not be enough to (directly) perform
> syscalls.  Further documentation can be found in a following patch.
> 
> Even without enforced security policy, userland interpreters can set it
> to enforce the system policy at their level, knowing that it will not
> break anything on running systems which do not care about this feature.
> However, on systems which want this feature enforced, there will be
> knowledgeable people (i.e. sysadmins who enforced O_MAYEXEC
> deliberately) to manage it.  A simple security policy implementation,
> configured through a dedicated sysctl, is available in a following
> patch.
> 
> O_MAYEXEC should not be confused with the O_EXEC flag which is intended
> for execute-only, which obviously doesn't work for scripts.  However, a
> similar behavior could be implemented in userland with O_PATH:
> https://lore.kernel.org/lkml/1e2f6913-42f2-3578-28ed-567f6a4bdda1@digikod.net/
> 
> The implementation of O_MAYEXEC almost duplicates what execve(2) and
> uselib(2) are already doing: setting MAY_OPENEXEC in acc_mode (which can
> then be checked as MAY_EXEC, if enforced).
> 
> This is an updated subset of the patch initially written by Vincent
> Strubel for CLIP OS 4:
> https://github.com/clipos-archive/src_platform_clip-patches/blob/f5cb330d6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch
> This patch has been used for more than 12 years with customized script
> interpreters.  Some examples (with the original O_MAYEXEC) can be found
> here:
> https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYEXEC
> 
> Co-developed-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
> Signed-off-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
