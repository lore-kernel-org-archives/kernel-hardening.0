Return-Path: <SRS0=3S/E=62=lists.openwall.com=kernel-hardening-return-18775-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1AFC2D0FA
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 22:57:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A483B23126
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 22:57:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="N9/eEWjx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A483B23126
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18775-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5253 invoked by uid 550); 12 May 2020 22:57:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5229 invoked from network); 12 May 2020 22:57:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=IXpIsoQged7M/ri/embTMdJh9eC3HGIEafUuSr0Sgp4=;
        b=N9/eEWjx4KryymG7ZL/gSXanLr0DYNDcTqpqniqQuUXfGEZEOCiOVCUM31Rkg5hbPF
         RYrLa1KR6sZdrXCo182VyfY9tc7Dc8vFc162i/vIcqYJQGy8FcEAaac5BV+8lc+P9xKZ
         wBGT4FqmIHHPX2e1wzE8uLoPmiAHm59yHXR8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=IXpIsoQged7M/ri/embTMdJh9eC3HGIEafUuSr0Sgp4=;
        b=CAZk1Cexi8z5ZyTECChQywLO8dvz3xvAdPEJ04o3vPwF6bR6aXHVe/FzTYOewFmU/9
         +vJ6lDgx8fmJZjxbbVkexQPX6rNIPGSTvKLdLP33EPyKqMUSCJq5CYrn37SIG80K7nHI
         x/CsJygzkYbi5df+V1yGLqhzCVJykdH7m7a/GCLFC248pbgNBRRn0/BBturweMYMK5Mk
         g+yBn6orc1kepih+e98OMkPgNF32B4pmSrbsQ7dnF8Gh37wHTJe65VloSu+pqZ2aqUqV
         gqiTlFEYBKq4YLNTfhFSwjiOVUK8qXutLZHdIhjWDpzDi/QElloYstdvpmTNfFWrQQZJ
         H4Sw==
X-Gm-Message-State: AGi0Pub30DMGfMHDurKT6RcLBdE7XNDd1RALfPrKK07jStAyj22TDzEC
	4DBmzTqP8qBu+kDnQlloarM5nQ==
X-Google-Smtp-Source: APiQypKzgC0TF704AZj7wxJgs6uVQ1eXdDqzXBGagWKY3u4jWSDcjnfhuh2eV/DDEm8B+zOSyJm0Nw==
X-Received: by 2002:a17:90a:7788:: with SMTP id v8mr30342795pjk.111.1589324208728;
        Tue, 12 May 2020 15:56:48 -0700 (PDT)
Date: Tue, 12 May 2020 15:56:46 -0700
From: Kees Cook <keescook@chromium.org>
To: Christian Heimes <christian@python.org>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
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
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 1/6] fs: Add support for an O_MAYEXEC flag on
 openat2(2)
Message-ID: <202005121555.0A446763@keescook>
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-2-mic@digikod.net>
 <202005121258.4213DC8A2@keescook>
 <0c70debd-e79e-d514-06c6-4cd1e021fa8b@python.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0c70debd-e79e-d514-06c6-4cd1e021fa8b@python.org>

On Tue, May 12, 2020 at 11:40:35PM +0200, Christian Heimes wrote:
> On 12/05/2020 23.05, Kees Cook wrote:
> > On Tue, May 05, 2020 at 05:31:51PM +0200, Mickaël Salaün wrote:
> >> When the O_MAYEXEC flag is passed, openat2(2) may be subject to
> >> additional restrictions depending on a security policy managed by the
> >> kernel through a sysctl or implemented by an LSM thanks to the
> >> inode_permission hook.  This new flag is ignored by open(2) and
> >> openat(2).
> >>
> >> The underlying idea is to be able to restrict scripts interpretation
> >> according to a policy defined by the system administrator.  For this to
> >> be possible, script interpreters must use the O_MAYEXEC flag
> >> appropriately.  To be fully effective, these interpreters also need to
> >> handle the other ways to execute code: command line parameters (e.g.,
> >> option -e for Perl), module loading (e.g., option -m for Python), stdin,
> >> file sourcing, environment variables, configuration files, etc.
> >> According to the threat model, it may be acceptable to allow some script
> >> interpreters (e.g. Bash) to interpret commands from stdin, may it be a
> >> TTY or a pipe, because it may not be enough to (directly) perform
> >> syscalls.  Further documentation can be found in a following patch.
> > 
> > You touch on this lightly in the cover letter, but it seems there are
> > plans for Python to restrict stdin parsing? Are there patches pending
> > anywhere for other interpreters? (e.g. does CLIP OS have such patches?)
> > 
> > There's always a push-back against adding features that have external
> > dependencies, and then those external dependencies can't happen without
> > the kernel first adding a feature. :) I like getting these catch-22s
> > broken, and I think the kernel is the right place to start, especially
> > since the threat model (and implementation) is already proven out in
> > CLIP OS, and now with IMA. So, while the interpreter side of this is
> > still under development, this gives them the tool they need to get it
> > done on the kernel side. So showing those pieces (as you've done) is
> > great, and I think finding a little bit more detail here would be even
> > better.
> 
> Hi,
> 
> Python core dev here.
> 
> Yes, there are plans to use feature for Python in combination with
> additional restrictions. For backwards compatibility reasons we cannot
> change the behavior of the default Python interpreter. I have plans to
> provide a restricted Python binary that prohibits piping from stdin,
> disables -c "some_code()", restricts import locations, and a couple of
> other things. O_MAYEXEC flag makes it easier to block imports from
> noexec filesystems.
> 
> My PoC [1] for a talk [2] last year is inspired by IMA appraisal and a
> previous talk by Mickaël on O_MAYEXEC.
> 
> Christian
> 
> [1] https://github.com/zooba/spython/blob/master/linux_xattr/spython.c
> [2]
> https://speakerdeck.com/tiran/europython-2019-auditing-hooks-and-security-transparency-for-cpython

Ah, fantastic; thank you! Yes, this will go a long way for helping
demonstration to other folks that there are people who will be using
this feature. :)

-- 
Kees Cook
