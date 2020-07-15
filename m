Return-Path: <SRS0=xX+K=A2=lists.openwall.com=kernel-hardening-return-19331-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A8C3C433E8
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 20:06:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 457272065D
	for <kernel-hardening@archiver.kernel.org>; Wed, 15 Jul 2020 20:06:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="PCMIvsfX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 457272065D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19331-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17859 invoked by uid 550); 15 Jul 2020 20:06:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17839 invoked from network); 15 Jul 2020 20:06:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YL19XoL2DCkvrhiZbpXv6h7Rc/+Lwr1rsydviLs8pFc=;
        b=PCMIvsfXHhRDJz8Khz3VUsUkSsqo3SsGXmW6qozBpfFw4kwRb7k2005MBV/m480XJo
         UJjjM2/i31FD6kd3JPB8hOvDWYGhWQ2O79+33d3StMVVlrSmwT3Jn2OjikQ0pG18Ox6N
         0dOa8dwyh4myV41v2K0+FJWi/pMjoCl6QAT6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YL19XoL2DCkvrhiZbpXv6h7Rc/+Lwr1rsydviLs8pFc=;
        b=Wd3QPSCbemn20spriFvceVqcyjp1Lt7VJFmxZCuODZ6bMrZOyPzq2raguVvf/HcGSK
         RwpFojeXk3Bq1lJX+ZwMW1sqkAJ8dbYDBAbtHN2os27/UR862VcEGN47BCtkKWHLJJzV
         sRRai1XhEdI8xGFL2xLwhZdvwpehidgifbLXBsplGOP5vyPR+wS2ISxdQHI/MC28TsUQ
         lZzfo4UZeTLk4thRI5SS00mMcSpJzz7dES6ZyeYmRL/U3UuR3u1jBysqTFHxRQL06BX6
         ZtQeJAknR5qGaVwtUads+Uw6dBFi0YS4n3B24DU1f2G8iUB/APBGTIXl2IDVfONDWg7j
         tHSA==
X-Gm-Message-State: AOAM533tUE/Sl2q7l/u8O8Rt349mSfWiSze2WAn5kZd249IMdYXkmgfy
	ka9orswUKHbyrlK24fRwgxroUQ==
X-Google-Smtp-Source: ABdhPJxqPw/byppqYk72FBQJ1XrQVSH3bnxbDXc7/lfw9v75K7lcTOddZ1PpPFhX50QhSgkPHCK9SQ==
X-Received: by 2002:a17:90a:bc98:: with SMTP id x24mr1196990pjr.63.1594843587647;
        Wed, 15 Jul 2020 13:06:27 -0700 (PDT)
Date: Wed, 15 Jul 2020 13:06:25 -0700
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
Message-ID: <202007151304.9F48071@keescook>
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-5-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200714181638.45751-5-mic@digikod.net>

On Tue, Jul 14, 2020 at 08:16:35PM +0200, Mickaël Salaün wrote:
> When the O_MAYEXEC flag is passed, openat2(2) may be subject to
> additional restrictions depending on a security policy managed by the
> kernel through a sysctl or implemented by an LSM thanks to the
> inode_permission hook.  This new flag is ignored by open(2) and
> openat(2) because of their unspecified flags handling.
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
> then be checked as MAY_EXEC, if enforced), and propagating FMODE_EXEC to
> _fmode via __FMODE_EXEC flag (which can then trigger a
> fanotify/FAN_OPEN_EXEC event).
> 
> This is an updated subset of the patch initially written by Vincent
> Strubel for CLIP OS 4:
> https://github.com/clipos-archive/src_platform_clip-patches/blob/f5cb330d6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch
> This patch has been used for more than 12 years with customized script
> interpreters.  Some examples (with the original name O_MAYEXEC) can be
> found here:
> https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYEXEC
> 
> Co-developed-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
> Signed-off-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
> Co-developed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Reviewed-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
> 
> Changes since v5:
> * Update commit message.
> 
> Changes since v3:
> * Switch back to O_MAYEXEC, but only handle it with openat2(2) which
>   checks unknown flags (suggested by Aleksa Sarai). Cf.
>   https://lore.kernel.org/lkml/20200430015429.wuob7m5ofdewubui@yavin.dot.cyphar.com/
> 
> Changes since v2:
> * Replace O_MAYEXEC with RESOLVE_MAYEXEC from openat2(2).  This change
>   enables to not break existing application using bogus O_* flags that
>   may be ignored by current kernels by using a new dedicated flag, only
>   usable through openat2(2) (suggested by Jeff Layton).  Using this flag
>   will results in an error if the running kernel does not support it.
>   User space needs to manage this case, as with other RESOLVE_* flags.
>   The best effort approach to security (for most common distros) will
>   simply consists of ignoring such an error and retry without
>   RESOLVE_MAYEXEC.  However, a fully controlled system may which to
>   error out if such an inconsistency is detected.
> 
> Changes since v1:
> * Set __FMODE_EXEC when using O_MAYEXEC to make this information
>   available through the new fanotify/FAN_OPEN_EXEC event (suggested by
>   Jan Kara and Matthew Bobrowski):
>   https://lore.kernel.org/lkml/20181213094658.GA996@lithium.mbobrowski.org/
> ---
>  fs/fcntl.c                       | 2 +-
>  fs/open.c                        | 8 ++++++++
>  include/linux/fcntl.h            | 2 +-
>  include/linux/fs.h               | 2 ++
>  include/uapi/asm-generic/fcntl.h | 7 +++++++
>  5 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 2e4c0fa2074b..0357ad667563 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -1033,7 +1033,7 @@ static int __init fcntl_init(void)
>  	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
>  	 * is defined as O_NONBLOCK on some platforms and not on others.
>  	 */
> -	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ !=
> +	BUILD_BUG_ON(22 - 1 /* for O_RDONLY being 0 */ !=
>  		HWEIGHT32(
>  			(VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
>  			__FMODE_EXEC | __FMODE_NONOTIFY));
> diff --git a/fs/open.c b/fs/open.c
> index 623b7506a6db..38e434bdbbb6 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -987,6 +987,8 @@ inline struct open_how build_open_how(int flags, umode_t mode)
>  		.mode = mode & S_IALLUGO,
>  	};
>  
> +	/* O_MAYEXEC is ignored by syscalls relying on build_open_how(). */
> +	how.flags &= ~O_MAYEXEC;
>  	/* O_PATH beats everything else. */
>  	if (how.flags & O_PATH)
>  		how.flags &= O_PATH_FLAGS;
> @@ -1054,6 +1056,12 @@ inline int build_open_flags(const struct open_how *how, struct open_flags *op)
>  	if (flags & __O_SYNC)
>  		flags |= O_DSYNC;
>  
> +	/* Checks execution permissions on open. */
> +	if (flags & O_MAYEXEC) {
> +		acc_mode |= MAY_OPENEXEC;
> +		flags |= __FMODE_EXEC;
> +	}

Adding __FMODE_EXEC here will immediately change the behaviors of NFS
and fsnotify. If that's going to happen, I think it needs to be under
the control of the later patches doing the behavioral controls.
(specifically, NFS looks like it completely changes its access control
test when this is set and ignores the read/write checks entirely, which
is not what's wanted).


-- 
Kees Cook
