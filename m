Return-Path: <SRS0=c6pr=23=lists.openwall.com=kernel-hardening-return-17543-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61365C33C8C
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Jan 2020 15:15:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AFD2520707
	for <kernel-hardening@archiver.kernel.org>; Mon,  6 Jan 2020 15:15:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cWvJ0hUJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFD2520707
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17543-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5574 invoked by uid 550); 6 Jan 2020 15:15:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5543 invoked from network); 6 Jan 2020 15:15:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zTQSaUx9fY9N5fiG62F+7SM0UDzGL6HAVdcpx53+n90=;
        b=cWvJ0hUJN/7su+kb3ylfeBXNSVRKFL/Ht5gOkGAE6PXYxHmSNi0Tux3zKIPXxb0A//
         8W8kKdL3/Am33w5EX/YnhVV9WI4nDpzd6/i01V2323cciQgjlyqCRXEAffJV5t03GIPO
         CYpLD/zp+ndGI32uFUbtvlyJkswTd2218CXcmQ9zUAoJKbUiRzfKkg2W2dSpTgIgBwGs
         t3wpmk7dFDIv3c42swffAWKB4//RmnyRMDdooB/zfYedKmP5R+VLN/8FbIcyH88Z++VU
         T8B/yPTlLqtnhoP2artOpVm/VDcQLJSx98qR7TZFnYMfEJy8hv7+NGaGPKnmUqQ6cn0G
         Z5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zTQSaUx9fY9N5fiG62F+7SM0UDzGL6HAVdcpx53+n90=;
        b=Eq292OJglfr2awNbC5mcZ36lRlK3qrruYYCLraKRki3eaPAGPXLKXoBcIbpQGaw/XA
         Dx9iA1/3sV6UwGVLtBRMVeokSnB8QlzlJl3v2ARHILi9jgIk7lXuXLH0qWmhb3NdwLfV
         OusaZnxGsnKXz8I63Qff6+oj4FIpd4sSe8Jhn4XS3yQbe10egj5mTIDNv5rATvkadXFz
         ypTFCt4ONBnR09gqCponJptfwZU9srhEkH1flZfroOjKUCiJoEmi+MEoT6DjJQ6+XdrY
         JxYOgpTDxjUcFOA5KyJmo0J5nWSOSLI4m9lf5y+AgI4I8ttTWO1mPLoxAZ6i2r1HtdbJ
         9s2A==
X-Gm-Message-State: APjAAAX1iiitTd9GJKDBZ4V0qQ39dimMDA9Lj1YFJCkh2r14u669BdWz
	yc0W9XWhHwkx4njQUm/r3A==
X-Google-Smtp-Source: APXvYqyNeCBfGcSY8tzYao6Gf9lT0qkr1r3n6MMW2yaYqWla2aP861L3uIRX5g58cqiOezdEr2W3OQ==
X-Received: by 2002:a5d:4687:: with SMTP id u7mr103340897wrq.176.1578323718007;
        Mon, 06 Jan 2020 07:15:18 -0800 (PST)
Date: Mon, 6 Jan 2020 18:15:14 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
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
	Oleg Nesterov <oleg@redhat.com>,
	Solar Designer <solar@openwall.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v6 00/10] proc: modernize proc to support multiple
 private instances
Message-ID: <20200106151514.GA382@avx2>
References: <20191225125151.1950142-1-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191225125151.1950142-1-gladkov.alexey@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

>  	hidepid=	Set /proc/<pid>/ access mode.
>  	gid=		Set the group authorized to learn processes information.
> +	pidonly=	Show only task related subset of procfs.

I'd rather have

	mount -t proc -o set=pid

so that is can be naturally extended to 

	mount -t proc -o set=pid,sysctl,misc

> +static int proc_dir_open(struct inode *inode, struct file *file)
> +{
> +	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
> +
> +	if (proc_fs_pidonly(fs_info) == PROC_PIDONLY_ON)
> +		return -ENOENT;
> +
> +	return 0;
> +}
> +
>  /*
>   * These are the generic /proc directory operations. They
>   * use the in-memory "struct proc_dir_entry" tree to parse
> @@ -338,6 +357,7 @@ static const struct file_operations proc_dir_operations = {
>  	.llseek			= generic_file_llseek,
>  	.read			= generic_read_dir,
>  	.iterate_shared		= proc_readdir,
> +	.open			= proc_dir_open,

This should not be necessary: if lookup and readdir filters work
then ->open can't happen.

>  static int proc_reg_open(struct inode *inode, struct file *file)
>  {
> +	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
>  	struct proc_dir_entry *pde = PDE(inode);
>  	int rv = 0;
>  	typeof_member(struct file_operations, open) open;
>  	typeof_member(struct file_operations, release) release;
>  	struct pde_opener *pdeo;
>  
> +	if (proc_fs_pidonly(fs_info) == PROC_PIDONLY_ON)
> +		return -ENOENT;

Ditto. Can't open what can't be looked up.

> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> +/* definitions for hide_pid field */
> +enum {
> +	HIDEPID_OFF	  = 0,
> +	HIDEPID_NO_ACCESS = 1,
> +	HIDEPID_INVISIBLE = 2,
> +	HIDEPID_NOT_PTRACABLE = 3, /* Limit pids to only ptracable pids */
> +};

These should live in uapi/ as they _are_ user interface to mount().
