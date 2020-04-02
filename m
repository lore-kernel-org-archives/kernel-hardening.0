Return-Path: <SRS0=0QVb=5S=lists.openwall.com=kernel-hardening-return-18384-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08311C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 15:34:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6127820737
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 15:34:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6127820737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18384-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26424 invoked by uid 550); 2 Apr 2020 15:34:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26402 invoked from network); 2 Apr 2020 15:34:48 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexander Viro <viro@zeniv.linux.org.uk>,  Alexey Dobriyan <adobriyan@gmail.com>,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
	<20200327172331.418878-3-gladkov.alexey@gmail.com>
Date: Thu, 02 Apr 2020 10:31:48 -0500
In-Reply-To: <20200327172331.418878-3-gladkov.alexey@gmail.com> (Alexey
	Gladkov's message of "Fri, 27 Mar 2020 18:23:24 +0100")
Message-ID: <87eet5lx97.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jK1rV-0007tb-0b;;;mid=<87eet5lx97.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18bJm/P/P+XAlq1t04hxE6W/8b8KDRYe10=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v10 2/9] proc: allow to mount many instances of proc in one pid namespace
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)


> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 40a7982b7285..5920a4ecd71b 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -27,6 +27,17 @@ struct proc_ops {
>  	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
>  };
>  
> +struct proc_fs_info {
> +	struct pid_namespace *pid_ns;
> +	struct dentry *proc_self;        /* For /proc/self */
> +	struct dentry *proc_thread_self; /* For /proc/thread-self */
> +};

Minor nit.

I have not seen a patch where you remove proc_self and proc_thread_self
from struct pid_namepace.

Ideally it would have been in this patch.  But as it won't break
anyone's bisection can you please have a follow up patch that removes
those fields?

Thank you,
Eric



> +
> +static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
> +{
> +	return sb->s_fs_info;
> +}
> +
>  #ifdef CONFIG_PROC_FS
>  
>  typedef int (*proc_write_t)(struct file *, char *, size_t);
> @@ -161,6 +172,7 @@ int open_related_ns(struct ns_common *ns,
>  /* get the associated pid namespace for a file in procfs */
>  static inline struct pid_namespace *proc_pid_ns(const struct inode *inode)
>  {
> +	return proc_sb_info(inode->i_sb)->pid_ns;
>  	return inode->i_sb->s_fs_info;
>  }
