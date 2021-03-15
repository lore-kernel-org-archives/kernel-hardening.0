Return-Path: <SRS0=jEeh=IN=lists.openwall.com=kernel-hardening-return-20942-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91A71C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 21:18:12 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9C741601FB
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 21:18:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9C741601FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20942-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14017 invoked by uid 550); 15 Mar 2021 21:18:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13997 invoked from network); 15 Mar 2021 21:18:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=DUr1k/Qqz3KWpr5/8/e77iHdLKltma+5t29fYrAFmQI=;
        b=S553Mer1ETZUkhiNw0TxP5F993tA5VUjS+Vs4i5CNKcVdsS+ZX8cjrpH1oDdz/Gmw3
         B9ORHP/ddVU/rNUG1cgUaKcWOUZjqDmV5Gwv8vfeh8B+yp+HzweHQYOASbX99+DYehsh
         Gcu+78Pp2kGUbKVUk6kLIGAcFw+5FMtDNb29Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=DUr1k/Qqz3KWpr5/8/e77iHdLKltma+5t29fYrAFmQI=;
        b=dcNPJ8x/UslNrFh6mpQeTTc92sO8gpJOqHiR+no4wYSvWQrBohyGwLxW9eVwd4XAcq
         KhhZFo5DwVWzPnxzDm7kXdOZHgoxd8pvmOS/UccV3DtmuuBpZ/98SqiBE+NISoh4myMn
         eEspKpUrx7qaAoNurYnq1qvevy5kgSuDnRJD6a7EqLzoD/fYz69xTv6KoNf6OuI1iOQ4
         dIjhOgylgQSwaNJUryK2J9Z+K+Ew0Qj3oTk/fpnaqpBF+najjkN6PXBqtT+8NZJKgRTN
         n3xy7RwlwGs/2qD8djmsR7yzFq4mxm69s/6cptHfE/18Hiox8h6alhJRjP0SygxmJvO4
         cHLQ==
X-Gm-Message-State: AOAM531b6WBW+XXzIDO84s4aW2h9aYLX0XNUCEqZhRT2WBBq+//0QClo
	HvGMmqnHM8x/TtU1kQjF8V0Ipw==
X-Google-Smtp-Source: ABdhPJzVe9wuhksN6TsIoHM9voPzo7YtxqoGcB/vIz5wE0tBTLM3puqaLRphxT+4OBrEKzYPy1aFvA==
X-Received: by 2002:a63:2318:: with SMTP id j24mr947180pgj.134.1615843070334;
        Mon, 15 Mar 2021 14:17:50 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:17:48 -0700
From: Kees Cook <keescook@chromium.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
	Serge Hallyn <serge@hallyn.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	John Johansen <john.johansen@canonical.com>,
	Kentaro Takeda <takedakn@nttdata.co.jp>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	kernel-hardening@lists.openwall.com, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>
Subject: Re: [PATCH v3 1/1] fs: Allow no_new_privs tasks to call chroot(2)
Message-ID: <202103151405.88334370F@keescook>
References: <20210311105242.874506-1-mic@digikod.net>
 <20210311105242.874506-2-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210311105242.874506-2-mic@digikod.net>

On Thu, Mar 11, 2021 at 11:52:42AM +0100, Mickaël Salaün wrote:
> [...]
> This change may not impact systems relying on other permission models
> than POSIX capabilities (e.g. Tomoyo).  Being able to use chroot(2) on
> such systems may require to update their security policies.
> 
> Only the chroot system call is relaxed with this no_new_privs check; the
> init_chroot() helper doesn't require such change.
> 
> Allowing unprivileged users to use chroot(2) is one of the initial
> objectives of no_new_privs:
> https://www.kernel.org/doc/html/latest/userspace-api/no_new_privs.html
> This patch is a follow-up of a previous one sent by Andy Lutomirski:
> https://lore.kernel.org/lkml/0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net/

I liked it back when Andy first suggested it, and I still like it now.
:) I'm curious, do you have a specific user in mind for this feature?

> [...]
> @@ -546,8 +547,18 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
>  	if (error)
>  		goto dput_and_out;
>  
> +	/*
> +	 * Changing the root directory for the calling task (and its future
> +	 * children) requires that this task has CAP_SYS_CHROOT in its
> +	 * namespace, or be running with no_new_privs and not sharing its
> +	 * fs_struct and not escaping its current root (cf. create_user_ns()).
> +	 * As for seccomp, checking no_new_privs avoids scenarios where
> +	 * unprivileged tasks can affect the behavior of privileged children.
> +	 */
>  	error = -EPERM;
> -	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT))
> +	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT) &&
> +			!(task_no_new_privs(current) && current->fs->users == 1
> +				&& !current_chrooted()))
>  		goto dput_and_out;
>  	error = security_path_chroot(&path);
>  	if (error)

I think the logic here needs to be rearranged to avoid setting
PF_SUPERPRIV, and I find the many negations hard to read. Perhaps:

static inline int current_chroot_allowed(void)
{
	/* comment here */
	if (task_no_new_privs(current) && current->fs->users == 1 &&
	    !current_chrooted())
		return 0;

	if (ns_capable(current_user_ns(), CAP_SYS_CHROOT))
		return 0;

	return -EPERM;
}

...

	error = current_chroot_allowed();
	if (error)
		goto dput_and_out;


I can't think of a way to race current->fs->users ...

-- 
Kees Cook
