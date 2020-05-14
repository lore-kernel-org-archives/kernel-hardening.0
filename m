Return-Path: <SRS0=/43n=64=lists.openwall.com=kernel-hardening-return-18783-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6048C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 03:05:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 49073205CB
	for <kernel-hardening@archiver.kernel.org>; Thu, 14 May 2020 03:05:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ER81wy6N"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49073205CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18783-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3477 invoked by uid 550); 14 May 2020 03:05:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3457 invoked from network); 14 May 2020 03:05:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RI4af4t+Hr3cwRvViCD0C0VTSsdcgl2WIZRjAD5Dbd8=;
        b=ER81wy6Nm4qqHe6/4nA1T72QieIUsDZr9xcEPXqlwCuu1bwbRzbDDp76o/GaGyv6ZN
         LhIsA3q1GqyyyLFIO5q4UxMKZ/DLFp4DOO12AImeksODZzTLEOUUYcEhUXA8eb5xmUfr
         WADVBn7cABTbN0GqYscdMzowjTlrjm+0sez/I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RI4af4t+Hr3cwRvViCD0C0VTSsdcgl2WIZRjAD5Dbd8=;
        b=cS0LX9gxZpjwHwhfDfhq6NFTPFwULztZ9NQwLQCaCEo/TZk8eqoG5TL2TnTPxrd8mw
         z3fsngx+jCjVc14FPupnepefRAefMEfPLsQsWjcPOLmJpz5wRm33voXILAn5YZt/OEqf
         +AJ2kygx0w7tVl50t9bF+llm59c0dGrv62LAgSzTr8t+IYM6/K3G97PJOcmyXzi3M49r
         THh+SWk2KijwID+8g7uLk0SuB05YAS8o915DbEUGaIYN1aWnqCHHWj6rbKWVu+Osv8kU
         5bbl6GX3xbbXtT2gXL23fhZZHNXyDjVH+qgGAala0hr+jbZyAEp38Cznis4fwIx5pBWD
         ffEw==
X-Gm-Message-State: AOAM530/1AWxFytJvPpjeomTI5ezr628qyG4PuRDM+9mRa4vE/TQp+om
	1SJeRIZZXT6D7ZPpWFegQpO3Hw==
X-Google-Smtp-Source: ABdhPJyv6W4n0Q3ekaCcNquQfPEI0ohUKwE+N8w+M8dJ+JkwyMY+fS9GmFM65yiwziqJLP/Q/8otoA==
X-Received: by 2002:aa7:958f:: with SMTP id z15mr2213370pfj.10.1589425512261;
        Wed, 13 May 2020 20:05:12 -0700 (PDT)
Date: Wed, 13 May 2020 20:05:09 -0700
From: Kees Cook <keescook@chromium.org>
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
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
	LSM List <linux-security-module@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec
 through O_MAYEXEC
Message-ID: <202005132002.91B8B63@keescook>
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-4-mic@digikod.net>
 <CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
 <202005131525.D08BFB3@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202005131525.D08BFB3@keescook>

On Wed, May 13, 2020 at 04:27:39PM -0700, Kees Cook wrote:
> Like, couldn't just the entire thing just be:
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index a320371899cf..0ab18e19f5da 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2849,6 +2849,13 @@ static int may_open(const struct path *path, int acc_mode, int flag)
>  		break;
>  	}
>  
> +	if (unlikely(mask & MAY_OPENEXEC)) {
> +		if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_MOUNT &&
> +		    path_noexec(path))
> +			return -EACCES;
> +		if (sysctl_omayexec_enforce & OMAYEXEC_ENFORCE_FILE)
> +			acc_mode |= MAY_EXEC;
> +	}
>  	error = inode_permission(inode, MAY_OPEN | acc_mode);
>  	if (error)
>  		return error;
> 

FYI, I've confirmed this now. Effectively with patch 2 dropped, patch 3
reduced to this plus the Kconfig and sysctl changes, the self tests
pass.

I think this makes things much cleaner and correct.

-- 
Kees Cook
