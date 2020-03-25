Return-Path: <SRS0=UIEV=5K=lists.openwall.com=kernel-hardening-return-18226-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66E7BC2D0E5
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 19:16:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BA3BE206F6
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 19:16:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YdgTKJCI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA3BE206F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18226-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20053 invoked by uid 550); 25 Mar 2020 19:16:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20033 invoked from network); 25 Mar 2020 19:16:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/CSnYJ72yMBY5GskbXfCv8g/G/mmEEpCrCFQo2L0Aws=;
        b=YdgTKJCIKwSBYuNKrvm+Yt8937ehN0RPqPBaX9M9Q14Ku0AZPia/hqQDs58KLJaWqN
         BCJYs12445mr3vOefmZ1wZ1vBbhdQRVsbxjZFE/ES2F0BKD2p7LwqyVuo+e8WYYbpjW/
         HtnNRacXs+AIqCrCJGVmVZJ1pHSbWBrGZ7boE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/CSnYJ72yMBY5GskbXfCv8g/G/mmEEpCrCFQo2L0Aws=;
        b=JvwhRcyftGEy3SzmFRUw8RG+ydxq+cginkXeSgh1/v7q//H5tjnLKQLOjfqwg24rQ/
         jh9ExFsz3cRPbURTluuPF8rurG/UAUaMkgrcpN+mZ/1Q4ATUveK+gLo/tvwGEqilv66+
         UbKQLVr9u1QZt+UXEG1RA+9XO9KOV+7UFfDfQ3aFhRAWvoTns62FH6O3nWPztRVOBvRq
         4KlCjslUEEtLazxe68S+GjzIz/PntouC7oj/3fdq1NnQswUt9DPc3T9Joa8DJD2YlA0m
         wjTShqlHsUpBFgT9lYRAf3NIjMO29ie7/w2x3NGevXNmCiwS/pTE/4tlzJDimj9FC2EH
         tavA==
X-Gm-Message-State: ANhLgQ3nQUHM7nzYU2E4sWBaIGNekVFqw88XyiHTT8ttCh0I9/4M0L1b
	caF7MXhx+dU4gJ7MlPYWdl4tzA==
X-Google-Smtp-Source: ADFU+vts8MQmEy0Le/cZw5nvgMjV7AYmKwKdII/bapz+8OLjmUP6QyQ5BjIOyAlngVJq2+M5nE3q1w==
X-Received: by 2002:a63:778e:: with SMTP id s136mr4408159pgc.155.1585163780203;
        Wed, 25 Mar 2020 12:16:20 -0700 (PDT)
Date: Wed, 25 Mar 2020 12:16:17 -0700
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
Subject: Re: [PATCH v9 9/8] proc: use named enums for better readability
Message-ID: <202003251216.FD5E296@keescook>
References: <CAHk-=whXbgW7-FYL4Rkaoh8qX+CkS5saVGP2hsJPV0c+EZ6K7A@mail.gmail.com>
 <20200325174245.298009-1-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325174245.298009-1-gladkov.alexey@gmail.com>

On Wed, Mar 25, 2020 at 06:42:45PM +0100, Alexey Gladkov wrote:
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>

I love these kinds of cleanups. :)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  fs/proc/base.c               | 2 +-
>  fs/proc/inode.c              | 2 +-
>  fs/proc/root.c               | 4 ++--
>  include/linux/proc_fs.h      | 6 +++---
>  include/uapi/linux/proc_fs.h | 2 +-
>  5 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index a836979e42fe..608d60fb79fb 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -699,7 +699,7 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
>   */
>  static bool has_pid_permissions(struct proc_fs_info *fs_info,
>  				 struct task_struct *task,
> -				 int hide_pid_min)
> +				 enum proc_hidepid hide_pid_min)
>  {
>  	/*
>  	 * If 'hidpid' mount option is set force a ptrace check,
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index a462fd111719..7870e0be0a1f 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -165,7 +165,7 @@ void proc_invalidate_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock
>  		deactivate_super(old_sb);
>  }
>  
> -static inline const char *hidepid2str(int v)
> +static inline const char *hidepid2str(enum proc_hidepid v)
>  {
>  	switch (v) {
>  		case HIDEPID_OFF: return "off";
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 42f3ee05c584..de7cee435621 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -32,9 +32,9 @@
>  struct proc_fs_context {
>  	struct proc_fs_info	*fs_info;
>  	unsigned int		mask;
> -	int			hidepid;
> +	enum proc_hidepid	hidepid;
>  	int			gid;
> -	int			pidonly;
> +	enum proc_pidonly	pidonly;
>  };
>  
>  enum proc_param {
> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index d259817ec913..b9f7ecd7f61f 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -29,7 +29,7 @@ struct proc_ops {
>  };
>  
>  /* definitions for proc mount option pidonly */
> -enum {
> +enum proc_pidonly {
>  	PROC_PIDONLY_OFF = 0,
>  	PROC_PIDONLY_ON  = 1,
>  };
> @@ -39,8 +39,8 @@ struct proc_fs_info {
>  	struct dentry *proc_self;        /* For /proc/self */
>  	struct dentry *proc_thread_self; /* For /proc/thread-self */
>  	kgid_t pid_gid;
> -	int hide_pid;
> -	int pidonly;
> +	enum proc_hidepid hide_pid;
> +	enum proc_pidonly pidonly;
>  };
>  
>  static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
> diff --git a/include/uapi/linux/proc_fs.h b/include/uapi/linux/proc_fs.h
> index dc6d717aa6ec..f5fe0e8dcfe4 100644
> --- a/include/uapi/linux/proc_fs.h
> +++ b/include/uapi/linux/proc_fs.h
> @@ -3,7 +3,7 @@
>  #define _UAPI_PROC_FS_H
>  
>  /* definitions for hide_pid field */
> -enum {
> +enum proc_hidepid {
>  	HIDEPID_OFF            = 0,
>  	HIDEPID_NO_ACCESS      = 1,
>  	HIDEPID_INVISIBLE      = 2,
> -- 
> 2.25.2
> 

-- 
Kees Cook
