Return-Path: <SRS0=js/p=A3=lists.openwall.com=kernel-hardening-return-19355-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85ACAC433E8
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 15:31:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D2E2D206F5
	for <kernel-hardening@archiver.kernel.org>; Thu, 16 Jul 2020 15:31:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ZCAVB8ns"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D2E2D206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19355-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13604 invoked by uid 550); 16 Jul 2020 15:31:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13584 invoked from network); 16 Jul 2020 15:31:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=jGC0Cma9sD+M6C66CXjEVdr4Gdb8mMF8OboSIxxwdH4=;
        b=ZCAVB8nsh1reVbsCtXsNpc9/GpvQQzf253bRke2fSht/9fsA2S0zNy7s7Q7zaYprZf
         XIp3CYeZYUJRxqJWxlw4GYR6Rxfcw9Cy7l7xTQwKslcSPJZlLm/qGcYymwn8C7VPsU+k
         dDBF3EEYw3UhdPnQHkORD5qj1r8KpyjprM3rc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=jGC0Cma9sD+M6C66CXjEVdr4Gdb8mMF8OboSIxxwdH4=;
        b=V/f9cg2JCcTx/emNIox3Du/zJl5qn6gog/ploYFk9qj62azXC8tKBo0Eies/plaMS3
         ZArsJ9lgh/UFvftGwla27U2Si6iidB3VMtDaeB/R/v03frpkzPfNTJbzXm7PquF9nWbw
         Gj6WlDx30q/+cHJyuNemioaa63NsOWzQojn0Hv39FCHKZ6yr0XHfWO+DymnDkNY1I85d
         ItwiHNqRMVNh3l1ChLNNahr5aszRffZxmeUNi+aH4qXBAUSbh15OYbyAMkUMBQcqGoUe
         r5+sqctwE/Diamr3lslC/fjTwV8qkgpqJ5cx559AU3lo9zIJokebhWetKv+Ail17EabT
         Xb/A==
X-Gm-Message-State: AOAM532LytkoyJMkZUC4F9ISMKdWkj03L1SR1WozNpx4Uk50cKqm+eJs
	UlzvxvXLkW6m6jRyw5gqTN/vjw==
X-Google-Smtp-Source: ABdhPJweDZrRnoUX7jCQB/uM+EQPmvMQFRn5PcnR6HDszEBspoWj0c+Kso5Fx/ceySNNzLeNRQX5LA==
X-Received: by 2002:a17:90b:390e:: with SMTP id ob14mr4976168pjb.221.1594913494019;
        Thu, 16 Jul 2020 08:31:34 -0700 (PDT)
Date: Thu, 16 Jul 2020 08:31:32 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Jan Kara <jack@suse.cz>, Matthew Bobrowski <mbobrowski@mbobrowski.org>,
	linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Aleksa Sarai <cyphar@cyphar.com>,
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
	James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 4/7] fs: Introduce O_MAYEXEC flag for openat2(2)
Message-ID: <202007160822.CCDB5478@keescook>
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-5-mic@digikod.net>
 <202007151304.9F48071@keescook>
 <b209ea10-5b7f-c40e-5b6a-3da9028403d5@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b209ea10-5b7f-c40e-5b6a-3da9028403d5@digikod.net>

On Thu, Jul 16, 2020 at 04:18:27PM +0200, Mickaël Salaün wrote:
> On 15/07/2020 22:06, Kees Cook wrote:
> > On Tue, Jul 14, 2020 at 08:16:35PM +0200, Mickaël Salaün wrote:
> >> The implementation of O_MAYEXEC almost duplicates what execve(2) and
> >> uselib(2) are already doing: setting MAY_OPENEXEC in acc_mode (which can
> >> then be checked as MAY_EXEC, if enforced), and propagating FMODE_EXEC to
> >> _fmode via __FMODE_EXEC flag (which can then trigger a
> >> fanotify/FAN_OPEN_EXEC event).
> >> [...]
> > 
> > Adding __FMODE_EXEC here will immediately change the behaviors of NFS
> > and fsnotify. If that's going to happen, I think it needs to be under
> > the control of the later patches doing the behavioral controls.
> > (specifically, NFS looks like it completely changes its access control
> > test when this is set and ignores the read/write checks entirely, which
> > is not what's wanted).
> 
> __FMODE_EXEC was suggested by Jan Kara and Matthew Bobrowski because of
> fsnotify. However, the NFS handling of SUID binaries [1] indeed leads to
> an unintended behavior. This also means that uselib(2) shouldn't work
> properly with NFS. I can remove the __FMODE_EXEC flag for now.

I kind of wonder if we need to more completely fix __FMODE_EXEC?

> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=f8d9a897d4384b77f13781ea813156568f68b83e

Hmpf, this implies that "fmode" should contain MAY_EXEC? It really looks
like __FMODE_EXEC is a hack for places where only "flags" were passed
around, and this only seems to be an issue for NFS at this point? And it
should be fixable for fsnotify too?

Hmm. (And nothing should use uselib anyway...)

-- 
Kees Cook
