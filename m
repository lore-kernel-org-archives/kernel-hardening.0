Return-Path: <SRS0=grSt=3R=lists.openwall.com=kernel-hardening-return-17619-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C64C2D0DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 13:44:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3DF5824683
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jan 2020 13:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WU7A92AH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3DF5824683
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17619-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23952 invoked by uid 550); 28 Jan 2020 13:44:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23907 invoked from network); 28 Jan 2020 13:44:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1580219033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iX5+dNiDCHZNjF1pHsSxrGTH633M7MeaVhdvtFsHS0U=;
	b=WU7A92AHh79YTbJMKXbHCyWwAmmIt8+JHYlC3GS9MCCZF6TtAchrSrABRMTAYhFuZ7dYf6
	a6+8AfNCAjQmU4S8AcKABf8CIHcpVTGyOYzGHztnlngjpX1E9WpHWAekfxU+Q6hTsfgxdA
	Sb9RfzBqfDd+GsH3Lxvpf69yWz83ndg=
X-MC-Unique: Z_wc_W5FMwixynomvgh4KQ-1
Date: Tue, 28 Jan 2020 14:43:37 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
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
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Solar Designer <solar@openwall.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v7 02/11] proc: add proc_fs_info struct to store proc
 information
Message-ID: <20200128134337.GC17943@redhat.com>
References: <20200125130541.450409-1-gladkov.alexey@gmail.com>
 <20200125130541.450409-3-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200125130541.450409-3-gladkov.alexey@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23

On 01/25, Alexey Gladkov wrote:
>
>  static int proc_init_fs_context(struct fs_context *fc)
>  {
>  	struct proc_fs_context *ctx;
> +	struct pid_namespace *pid_ns;
>
>  	ctx = kzalloc(sizeof(struct proc_fs_context), GFP_KERNEL);
>  	if (!ctx)
>  		return -ENOMEM;
>
> -	ctx->pid_ns = get_pid_ns(task_active_pid_ns(current));
> +	pid_ns = get_pid_ns(task_active_pid_ns(current));
> +
> +	if (!pid_ns->proc_mnt) {
> +		ctx->fs_info = kzalloc(sizeof(struct proc_fs_info), GFP_KERNEL);
> +		if (!ctx->fs_info) {
> +			kfree(ctx);
> +			return -ENOMEM;
> +		}
> +		ctx->fs_info->pid_ns = pid_ns;
> +	} else {
> +		ctx->fs_info = proc_sb_info(pid_ns->proc_mnt->mnt_sb);
> +	}
> +

it seems that this code lacks put_pid_ns() if pid_ns->proc_mnt != NULL
or if kzalloc() fails?

Or, better,

	pid_ns = task_active_pid_ns();

	if (!pid_ns->proc_mnt) {
		ctx->fs_info = kzalloc();
		...
		ctx->fs_info->pid_ns = get_pid_ns(pid_ns);
	}

No?

Oleg.

