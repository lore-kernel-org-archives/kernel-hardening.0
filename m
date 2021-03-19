Return-Path: <SRS0=Uaas=IR=lists.openwall.com=kernel-hardening-return-20995-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3AE1C433DB
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 18:46:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3B71261976
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 18:46:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B71261976
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20995-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21855 invoked by uid 550); 19 Mar 2021 18:45:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21835 invoked from network); 19 Mar 2021 18:45:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JGY/EqeMUGC+Bt0wZ3nGVTDLepgM3WlnAUKZmdbmQ04=;
        b=BMblp60iEXVdjovxUp1rExGL91YRwQuPg7ex7JypQ4I7GzGU459rL4//OWZYwwYXk1
         vbD6FWRxEj3FEA+nwCLdGAE01jhnkk9hWRSGjaS5U+/niv+lnudUwa5wXNK4WXp8Sc+8
         K5+rT+YUekesYA4H7ZEzBPFgjWkvH2RjmvCE0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JGY/EqeMUGC+Bt0wZ3nGVTDLepgM3WlnAUKZmdbmQ04=;
        b=SQOADsaUZhVGwCjnkPkJTwuRGc2Cbpkw34OHLFQMaJvJD7mhtXmY6BPI0GG//yx6Ai
         XsdUrtAi1d3bG9VOgNcDLZz7z3H41wI1qmwBFk9+iIkxqfmIx63qHo/QXbQ8lmx/jzeI
         lc5W1vgFh12f1lV+J5VhrQRbanrKxKQPyn/fQFWtm1QSIGN1FpCJoAD0Uafc+3TfDBJD
         CqzvCd/aG+AEQkELlmtuKcDzQ7CFfnBqsNq8RzyygMTHVg20uZxKjIBrT0o0pf0arm3a
         UMvSMvDjHylCZMCHOhiZ6UdiD6PdNt+brmiCNe60ENXIGLTbZFNWurAA08pY46ZS6a5l
         l1QQ==
X-Gm-Message-State: AOAM533BjmeEMXBzSdneWlhcNx4BaWxxFeRChLChOZ8/nCdsbxOmAp8p
	lJhaay3HHuslv/E6ve481TJMdg==
X-Google-Smtp-Source: ABdhPJxnvtZMI8WcSLqJP4CQU2LP1bacblL/FkbqVKRmPz2mN29hO8eLj66oHnTAGfPb6/ukaMAz3Q==
X-Received: by 2002:a63:ff21:: with SMTP id k33mr12313273pgi.379.1616179539760;
        Fri, 19 Mar 2021 11:45:39 -0700 (PDT)
Date: Fri, 19 Mar 2021 11:45:38 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v30 04/12] landlock: Add ptrace restrictions
Message-ID: <202103191145.C8BA4DC@keescook>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-5-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210316204252.427806-5-mic@digikod.net>

On Tue, Mar 16, 2021 at 09:42:44PM +0100, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> Using ptrace(2) and related debug features on a target process can lead
> to a privilege escalation.  Indeed, ptrace(2) can be used by an attacker
> to impersonate another task and to remain undetected while performing
> malicious activities.  Thanks to  ptrace_may_access(), various part of
> the kernel can check if a tracer is more privileged than a tracee.
> 
> A landlocked process has fewer privileges than a non-landlocked process
> and must then be subject to additional restrictions when manipulating
> processes. To be allowed to use ptrace(2) and related syscalls on a
> target process, a landlocked process must have a subset of the target
> process's rules (i.e. the tracee must be in a sub-domain of the tracer).
> 
> Cc: James Morris <jmorris@namei.org>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
