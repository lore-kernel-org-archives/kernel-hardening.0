Return-Path: <SRS0=o4ZJ=62=lists.openwall.com=kernel-hardening-return-18772-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89430C2D0F8
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 21:57:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D281C20731
	for <kernel-hardening@archiver.kernel.org>; Tue, 12 May 2020 21:57:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EKNj4UhW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D281C20731
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18772-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3978 invoked by uid 550); 12 May 2020 21:57:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3955 invoked from network); 12 May 2020 21:57:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=e7QDP26KIcvXxlMBDMenIfkDI5g81klinZXY+V/2a0c=;
        b=EKNj4UhWvYLYC+esrF6wIPSlTbES/pi+t5+UQ0FZzqy/47ARXRNq0vx4AjTCa/AKXt
         6Xuy4ZU/p0Wwaf1GllvqRSgZfR+YY+Hc4i5fEDhbCj0JsbqDndK+ZVWdwzHmfT5O9IEG
         BGnWj2ANI1p6ggTHcQmlDREvxqMxzq37T3E0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=e7QDP26KIcvXxlMBDMenIfkDI5g81klinZXY+V/2a0c=;
        b=hZQh5yO74bFlADun7zwTCxOT5oCdXTMubMJfFmWaiErmyd9GZD8LuN078vk5M4gsiO
         pdklnvmpzNr3SZ2Od+gAYnTu+3H0cescv1K2+el0dqxYl0Y3NXt23omhBU1sbQa+HepC
         KpMqrtd4guOleilY2NUzNpEYNNN3aNZNDI70NJgLlNDDiEZv4q3wwoYyqFTWovRPpQuL
         fLtFWVfIt9pd9iO/Ie7sR+qtds0pJj9wejgY+pZy3Oo6/kRTQj+aoMiMZByLwUzz9KJa
         76A6RcEvhkmd5VUppz28MjSngpQbYAI7jfh3Wy5EbHc5dGINDeH41vCVuv6vvDGW2ejR
         /mxQ==
X-Gm-Message-State: AGi0PuYWw+KpaD4f/bEGhLCexBCw4JQN7iAXkC4NEc6BS8vDUFjK9bB+
	Kww37WKnCTOdKovac3eEZlXB1A==
X-Google-Smtp-Source: APiQypIiqN1d23Fkal6XnfP7M0OVBHWWKQI6z1c+Lxm1tB4W6iJPBSoHHobQonUpZ1R5kSF3kW/fRg==
X-Received: by 2002:a17:902:ac87:: with SMTP id h7mr20712377plr.119.1589320649149;
        Tue, 12 May 2020 14:57:29 -0700 (PDT)
Date: Tue, 12 May 2020 14:57:27 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
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
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 4/6] selftest/openat2: Add tests for O_MAYEXEC
 enforcing
Message-ID: <202005121452.4DED41A@keescook>
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-5-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200505153156.925111-5-mic@digikod.net>

On Tue, May 05, 2020 at 05:31:54PM +0200, Mickaël Salaün wrote:
> Test propagation of noexec mount points or file executability through
> files open with or without O_MAYEXEC, thanks to the
> fs.open_mayexec_enforce sysctl.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> Cc: Aleksa Sarai <cyphar@cyphar.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Shuah Khan <shuah@kernel.org>

Yay tests! :) Notes below...

> diff --git a/tools/testing/selftests/openat2/Makefile b/tools/testing/selftests/openat2/Makefile
> index 4b93b1417b86..cb98bdb4d5b1 100644
> --- a/tools/testing/selftests/openat2/Makefile
> +++ b/tools/testing/selftests/openat2/Makefile
> @@ -1,7 +1,8 @@
>  # SPDX-License-Identifier: GPL-2.0-or-later
>  
>  CFLAGS += -Wall -O2 -g -fsanitize=address -fsanitize=undefined
> -TEST_GEN_PROGS := openat2_test resolve_test rename_attack_test
> +LDLIBS += -lcap
> +TEST_GEN_PROGS := openat2_test resolve_test rename_attack_test omayexec_test

I realize the others have _test in their name, but that feels intensely
redundant to me. :)

> [...]
> diff --git a/tools/testing/selftests/openat2/omayexec_test.c b/tools/testing/selftests/openat2/omayexec_test.c
> new file mode 100644
> index 000000000000..7052c852daf8
> --- /dev/null
> +++ b/tools/testing/selftests/openat2/omayexec_test.c
> [...]
> +FIXTURE_DATA(mount_exec_file_exec) { };

For each of these, Please use "FIXTURE" not "FIXTURE_DATA". See:
1ae81d78a8b2 ("selftests/seccomp: Adjust test fixture counts")

> +FIXTURE_SETUP(mount_exec_file_exec)
> +{
> +	create_workspace(_metadata, 1, 1);

Maybe save the system's original sysctl in create_workspace() instead
of always restoring it to 0 in delete_workspace()?

Otherwise, looks good!

-- 
Kees Cook
