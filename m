Return-Path: <SRS0=3Kb5=O3=lists.openwall.com=kernel-hardening-return-21424-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F776C433F5
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Oct 2021 19:25:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5C3CE6101E
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 Oct 2021 19:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5C3CE6101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 5514 invoked by uid 550); 7 Oct 2021 19:25:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5494 invoked from network); 7 Oct 2021 19:25:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/n8Me6J9c/0Aaoq12l4632VyTlikQYiCethpuj+aLbY=;
        b=SQli1vTaGmeF3OtZ3pEx09pCBMoHEts7mbTOISN2rhw8hmBquS/IZbR87v5QBBLbqv
         /pqrMUBoSis9z+SqnCrcggOh95LPt3XnzSnyEUY5qxiV3KUqfrJavcG97WH/T17gpSTR
         ocgOZSBiyES6Ow7gBhMre0GdCndxIz5XD9k68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=/n8Me6J9c/0Aaoq12l4632VyTlikQYiCethpuj+aLbY=;
        b=tIpuGqAMGzG88Ydu7h1nNQTARXXxmFeA5XxWnEsEh9POVtOGtuC6SLrjhg3UPF0ePL
         rQOB119vL2W6c3g7Jhsm6uml7PgwNmy5gvJiCVg6vtu2S5zSib41Y9+RPkh9UvmCmGnb
         hwQTApezZU2MPL8qw9/ms5k9Bj5wVDYlF/iitWQJEzDSNZHeoEQOLTUb9yjXKVcqNU8Z
         e+hb7boPgQagm2NJ8RYrqBI9hwmF24cCcnnbkUNPIQ0MPgE3l3Mfyg8iEkIqH7mblvy6
         rQp0rDQjwz2DmCNAOG93PQyCFPQvrBkBZvjfLyraAIBQ8QnddcsOuRA/jQnjB1qVxudX
         RRHg==
X-Gm-Message-State: AOAM530Jd9h5Nh3xaXHNpsSq9elDBA2UNQTPcpZF0PPjiDJ+L0oN1UxM
	hvBnbPHMoZIoSfn73oS4cWvNbQ==
X-Google-Smtp-Source: ABdhPJyWbT/2wfJkhN3zmahv5/28fdw9q8dBvfcBa/rkLKicY5/v7uqqy3nFOrQlBaExCnpIUB7yjQ==
X-Received: by 2002:a63:7118:: with SMTP id m24mr1146122pgc.332.1633634728739;
        Thu, 07 Oct 2021 12:25:28 -0700 (PDT)
Date: Thu, 7 Oct 2021 12:25:27 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>,
	Philippe =?iso-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v13 1/3] fs: Add trusted_for(2) syscall implementation
 and related sysctl
Message-ID: <202110071217.16C7208F@keescook>
References: <20211007182321.872075-1-mic@digikod.net>
 <20211007182321.872075-2-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211007182321.872075-2-mic@digikod.net>

On Thu, Oct 07, 2021 at 08:23:18PM +0200, Mickaël Salaün wrote:
> From: Mickaël Salaün <mic@linux.microsoft.com>
> 
> The trusted_for() syscall enables user space tasks to check that files
> are trusted to be executed or interpreted by user space.  This may allow
> script interpreters to check execution permission before reading
> commands from a file, or dynamic linkers to allow shared object loading.
> This may be seen as a way for a trusted task (e.g. interpreter) to check
> the trustworthiness of files (e.g. scripts) before extending its control
> flow graph with new ones originating from these files.
> [...]
>  aio-nr & aio-max-nr
> @@ -382,3 +383,52 @@ Each "watch" costs roughly 90 bytes on a 32bit kernel, and roughly 160 bytes
>  on a 64bit one.
>  The current default value for  max_user_watches  is the 1/25 (4%) of the
>  available low memory, divided for the "watch" cost in bytes.
> +
> +
> +trust_policy
> +------------

bikeshed: can we name this "trusted_for_policy"? Both "trust" and
"policy" are very general words, but "trusted_for" (after this series)
will have a distinct meaning, so "trusted_for_policy" becomes more
specific/searchable.

With that renamed, I think it looks good! I'm looking forward to
interpreters using this. :)

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
