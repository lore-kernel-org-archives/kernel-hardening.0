Return-Path: <SRS0=J/N2=BD=lists.openwall.com=kernel-hardening-return-19445-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AD5C433E1
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 19:03:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 469A9206D8
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Jul 2020 19:03:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HWLOLY2m"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 469A9206D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19445-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7214 invoked by uid 550); 24 Jul 2020 19:03:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7182 invoked from network); 24 Jul 2020 19:03:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=f0lKwdFa2tE754eWyXOOIFz3gWD2EzuwPTrCttQ++tE=;
        b=HWLOLY2m7CMUOQYAp0GqUyHeBr+slwYCrPxK4fmOYzQKeY1Sqn9NsstNWgyO0gYfZz
         TUCLaYuoK1a5vP1C228zV0xEZgcjSBAnqzIr+6yAndPlXzf8D3bRRlqtGTaJ8eamUTu0
         m/nF3ewNlRWYDQ/wxxQHLPQatyOp/cmIjNB+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=f0lKwdFa2tE754eWyXOOIFz3gWD2EzuwPTrCttQ++tE=;
        b=XnnahQ+e2/hjdscu7sdNj606wLwtRrdSEQ11hiYOc9u0U30JlWMha3sjytY2ENQItJ
         4/zDa/Y23L241svZPsI5yIX5Xs4ApC7+48765hFS8z3hsDKTQsI2meM3mkWt3Bg2aG3t
         tlsVMw8v+Wis2FGmyr2iTSjGzOKA5wFcv4jIplMGNHjmF5gesqSIrwcFC/rvtEvD+5mf
         qbS210hl1uKdqLchxKrK2U1eYlb1Jq7AqIZn6NxP+c3Xf3sw0Va6Bqf+OI8t15oMty25
         lP0MOqtdwTRA8HYAMB3Jpgfc/fI+brvBre2WjwYiqUwoC0+OeUEidkeD2399Qo6J5rkv
         hALQ==
X-Gm-Message-State: AOAM532FKJ2pG6YFt8t2oNgEMXfZLZo1M9bAELJnZ/vET1gXywSjhaBC
	/qKsSXIQVy8LzmIvAdtmApEomg==
X-Google-Smtp-Source: ABdhPJyQSqTNd3BVzP4VWxiWnp6p6oQzAmDBIOJnaoSdP+OBPVoNfaPuvwcTsPgk9o7oKdilefLQ/Q==
X-Received: by 2002:a17:902:c252:: with SMTP id 18mr9772518plg.39.1595617402829;
        Fri, 24 Jul 2020 12:03:22 -0700 (PDT)
Date: Fri, 24 Jul 2020 12:03:21 -0700
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
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v7 5/7] fs,doc: Enable to enforce noexec mounts or file
 exec through O_MAYEXEC
Message-ID: <202007241203.0C596BB36@keescook>
References: <20200723171227.446711-1-mic@digikod.net>
 <20200723171227.446711-6-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200723171227.446711-6-mic@digikod.net>

On Thu, Jul 23, 2020 at 07:12:25PM +0200, Mickaël Salaün wrote:
> Allow for the enforcement of the O_MAYEXEC openat2(2) flag.  Thanks to
> the noexec option from the underlying VFS mount, or to the file execute
> permission, userspace can enforce these execution policies.  This may
> allow script interpreters to check execution permission before reading
> commands from a file, or dynamic linkers to allow shared object loading.
> 
> Add a new sysctl fs.open_mayexec_enforce to enable system administrators
> to enforce two complementary security policies according to the
> installed system: enforce the noexec mount option, and enforce
> executable file permission.  Indeed, because of compatibility with
> installed systems, only system administrators are able to check that
> this new enforcement is in line with the system mount points and file
> permissions.  A following patch adds documentation.
> 
> Being able to restrict execution also enables to protect the kernel by
> restricting arbitrary syscalls that an attacker could perform with a
> crafted binary or certain script languages.  It also improves multilevel
> isolation by reducing the ability of an attacker to use side channels
> with specific code.  These restrictions can natively be enforced for ELF
> binaries (with the noexec mount option) but require this kernel
> extension to properly handle scripts (e.g., Python, Perl).  To get a
> consistent execution policy, additional memory restrictions should also
> be enforced (e.g. thanks to SELinux).
> 
> Because the O_MAYEXEC flag is a meant to enforce a system-wide security
> policy (but not application-centric policies), it does not make sense
> for userland to check the sysctl value.  Indeed, this new flag only
> enables to extend the system ability to enforce a policy thanks to (some
> trusted) userland collaboration.  Moreover, additional security policies
> could be managed by LSMs.  This is a best-effort approach from the
> application developer point of view:
> https://lore.kernel.org/lkml/1477d3d7-4b36-afad-7077-a38f42322238@digikod.net/
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
