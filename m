Return-Path: <SRS0=iWBd=5N=lists.openwall.com=kernel-hardening-return-18267-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FA9C43331
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 20:40:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 72097206F6
	for <kernel-hardening@archiver.kernel.org>; Sat, 28 Mar 2020 20:40:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dhUsz2w4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 72097206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18267-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9566 invoked by uid 550); 28 Mar 2020 20:40:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9544 invoked from network); 28 Mar 2020 20:40:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j/EFDB2Q5SPOwwmNnuRi1C0YdHPQQMO4+uXHwaQqTxw=;
        b=dhUsz2w4MYgWNyj6hE0ZxIborPPRKatAyXIJTKPJASqYLflpcsqRqPljXfYVH69gv5
         nnJW6IxDRIPKIyNzwlx+CweVYdI11EHzTdgUHboAK33tWNrpDyi4uVGp2X6inCFH/tiC
         z+C9sh8/fYNrrLzd9ef8KuywghePkxJQCkmqM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j/EFDB2Q5SPOwwmNnuRi1C0YdHPQQMO4+uXHwaQqTxw=;
        b=RBPJ2z0/vlmd8s0TtxjXZQp0AN2qmUIibRtHF+7Ld0Ff/LbMa+EeMhFdWhgUgqaEmg
         GzH1CVX03LPR7fsK5iHxAV+IrzYmVRkocC0JLMdMR89fMwag0JI54iyBkwCoRSqk5Rte
         BbOkvJK4BXT5yZcvXm5SJl6sLI5YKpvV4q4U5m0YVUDUJEk+D027l+tWtQHSM7RRMp29
         Ar2QsRayv5cGe1pDdBsYFVSHHPqwMN3YsL8Vltx+nC8m6Vg1nvrL9LZbRHW9rZzHy6CK
         gGaSSBT6lJWS3ZFdUuMbgtcNXPqR81f5tEYALRNJzxuZliOCTnOsoGUPsiONjgMokwvs
         f0Gg==
X-Gm-Message-State: ANhLgQ2RkQV59Wzec+auXjFvmhXqVSvd7QzCL0mEVOs2vne7tuqEg8x7
	nso4JNzmmLbE3Lc4sOdfPEyVww==
X-Google-Smtp-Source: ADFU+vs6+/SpRmPEoOYQ3qzPgEH3AqddrEIOW9lIgqivUrhiB+kQch1HS6U8Q/6IiCIGdFtx3L4pZQ==
X-Received: by 2002:a63:be49:: with SMTP id g9mr5799185pgo.30.1585428005574;
        Sat, 28 Mar 2020 13:40:05 -0700 (PDT)
Date: Sat, 28 Mar 2020 13:40:03 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 4/9] proc: instantiate only pids that we can ptrace
 on 'hidepid=4' mount option
Message-ID: <202003281336.8354DB74@keescook>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
 <20200327172331.418878-5-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327172331.418878-5-gladkov.alexey@gmail.com>

On Fri, Mar 27, 2020 at 06:23:26PM +0100, Alexey Gladkov wrote:
> If "hidepid=4" mount option is set then do not instantiate pids that
> we can not ptrace. "hidepid=4" means that procfs should only contain
> pids that the caller can ptrace.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
> Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---
>  fs/proc/base.c          | 15 +++++++++++++++
>  fs/proc/root.c          | 13 ++++++++++---
>  include/linux/proc_fs.h |  1 +
>  3 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 43a28907baf9..1ebe9eba48ea 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -701,6 +701,14 @@ static bool has_pid_permissions(struct proc_fs_info *fs_info,
>  				 struct task_struct *task,
>  				 int hide_pid_min)
>  {
> +	/*
> +	 * If 'hidpid' mount option is set force a ptrace check,
> +	 * we indicate that we are using a filesystem syscall
> +	 * by passing PTRACE_MODE_READ_FSCREDS
> +	 */
> +	if (fs_info->hide_pid == HIDEPID_NOT_PTRACEABLE)
> +		return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
> +
>  	if (fs_info->hide_pid < hide_pid_min)
>  		return true;
>  	if (in_group_p(fs_info->pid_gid))
> @@ -3319,7 +3327,14 @@ struct dentry *proc_pid_lookup(struct dentry *dentry, unsigned int flags)
>  	if (!task)
>  		goto out;
>  
> +	/* Limit procfs to only ptraceable tasks */
> +	if (fs_info->hide_pid == HIDEPID_NOT_PTRACEABLE) {
> +		if (!has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS))
> +			goto out_put_task;
> +	}
> +
>  	result = proc_pid_instantiate(dentry, task, NULL);
> +out_put_task:
>  	put_task_struct(task);
>  out:
>  	return result;
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 616e8976185c..62eae22403d2 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -47,6 +47,14 @@ static const struct fs_parameter_spec proc_fs_parameters[] = {
>  	{}
>  };
>  
> +static inline int valid_hidepid(unsigned int value)
> +{
> +	return (value == HIDEPID_OFF ||
> +		value == HIDEPID_NO_ACCESS ||
> +		value == HIDEPID_INVISIBLE ||
> +		value == HIDEPID_NOT_PTRACEABLE);

This likely easier to do with a ...MAX value? i.e.

	return (value < HIDEPID_OFF || value >= HIDEPID_MAX);

> +}
> +
>  static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
>  {
>  	struct proc_fs_context *ctx = fc->fs_private;
> @@ -63,10 +71,9 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
>  		break;
>  
>  	case Opt_hidepid:
> +		if (!valid_hidepid(result.uint_32))
> +			return invalf(fc, "proc: unknown value of hidepid.\n");
>  		ctx->hidepid = result.uint_32;
> -		if (ctx->hidepid < HIDEPID_OFF ||
> -		    ctx->hidepid > HIDEPID_INVISIBLE)
> -			return invalfc(fc, "hidepid value must be between 0 and 2.\n");
>  		break;
>  
>  	default:
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 7d852dbca253..21d19353fdc7 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -32,6 +32,7 @@ enum {
>  	HIDEPID_OFF	  = 0,
>  	HIDEPID_NO_ACCESS = 1,
>  	HIDEPID_INVISIBLE = 2,
> +	HIDEPID_NOT_PTRACEABLE = 4, /* Limit pids to only ptraceable pids */

This isn't a bit field -- shouldn't this be "3"?

	...
	HIDEPID_NOT_PTRACEABLE = 3,
	HIDEPID_MAX

etc?

>  };
>  
>  struct proc_fs_info {
> -- 
> 2.25.2
> 

-- 
Kees Cook
