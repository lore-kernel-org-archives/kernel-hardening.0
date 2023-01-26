Return-Path: <kernel-hardening-return-21611-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B37CAC05027
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Jan 2023 16:36:12 +0000 (UTC)
Received: (qmail 11566 invoked by uid 550); 26 Jan 2023 16:36:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11528 invoked from network); 26 Jan 2023 16:36:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dCedkZSub4E7G02ozmeTWJLtnbDkNYV9uv5/ypFjcjs=;
        b=eVNsUVSbY9fywISASdJ8vOfw38lV1OqgtvUQe/DYuTvRD66m+Qs3gitiyBx71/B0fx
         biiKsQThZMp1LfHN5EGfeOINKoMSy9g2go3I16WtwwZQpmFQ2IV/8N1oy6n8YhD6UIky
         WkwjrAgO7QyAPO+kq7hvc2L7BT76y6qkh24as=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dCedkZSub4E7G02ozmeTWJLtnbDkNYV9uv5/ypFjcjs=;
        b=vQQy06tV+v8q0qpQCN3OG5zYR/TPM2t8q43INFvrX5s6ddDw82Z4PQKOZqfExhcEV3
         jlLvc5lpG4LwxPDrPE+inYfO6p7aIAmrP2+h2aYZFNCjxvHDG+DBqPSMS07G1Tw2kMwY
         OlAtydUdWj1K3w+sHYv7h8UeQ9oJnJTUjs6XLyGIsjqQNWjGIs0qC3/wls1eNYMDk36O
         oP2qgDk2pIK4i+mI91oIgZdhZVhbT3ed8yG6VCJAf/yXRCkRsS5ymY0F7smRJG7r47HN
         pPGgERp00rx4OaLCtIk4D67THhUlDry7daHhowAmS+msuFsLwbwrxaydqsSUrMLeUXxT
         G4pw==
X-Gm-Message-State: AO0yUKWAL/mRs/QGxPAeH2FSbin8ZF90pup73Z7p40fnROx2EgGxrScZ
	Tk401pbOfdkSZ895RQm82+w3IQ==
X-Google-Smtp-Source: AK7set+Avp0tanijMNFBCT+FU9xteiB6gbr+IKCgWeSxaIOPWvlfFL0xvNVSPGxExS539i8F/Vvc1g==
X-Received: by 2002:a17:902:9a85:b0:196:1d60:b1b1 with SMTP id w5-20020a1709029a8500b001961d60b1b1mr7396425plp.31.1674750950872;
        Thu, 26 Jan 2023 08:35:50 -0800 (PST)
Date: Thu, 26 Jan 2023 08:35:49 -0800
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] fs: Use CHECK_DATA_CORRUPTION() when kernel bugs are
 detected
Message-ID: <202301260835.61F1C2CA4D@keescook>
References: <20230116191425.458864-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116191425.458864-1-jannh@google.com>

On Mon, Jan 16, 2023 at 08:14:25PM +0100, Jann Horn wrote:
> Currently, filp_close() and generic_shutdown_super() use printk() to log
> messages when bugs are detected. This is problematic because infrastructure
> like syzkaller has no idea that this message indicates a bug.
> In addition, some people explicitly want their kernels to BUG() when kernel
> data corruption has been detected (CONFIG_BUG_ON_DATA_CORRUPTION).
> And finally, when generic_shutdown_super() detects remaining inodes on a
> system without CONFIG_BUG_ON_DATA_CORRUPTION, it would be nice if later
> accesses to a busy inode would at least crash somewhat cleanly rather than
> walking through freed memory.
> 
> To address all three, use CHECK_DATA_CORRUPTION() when kernel bugs are
> detected.

Seems reasonable to me. I'll carry this unless someone else speaks up.
:)

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> 
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  fs/open.c              |  5 +++--
>  fs/super.c             | 21 +++++++++++++++++----
>  include/linux/poison.h |  3 +++
>  3 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 82c1a28b3308..ceb88ac0ca3b 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -1411,8 +1411,9 @@ int filp_close(struct file *filp, fl_owner_t id)
>  {
>  	int retval = 0;
>  
> -	if (!file_count(filp)) {
> -		printk(KERN_ERR "VFS: Close: file count is 0\n");
> +	if (CHECK_DATA_CORRUPTION(file_count(filp) == 0,
> +			"VFS: Close: file count is 0 (f_op=%ps)",
> +			filp->f_op)) {
>  		return 0;
>  	}
>  
> diff --git a/fs/super.c b/fs/super.c
> index 12c08cb20405..cf737ec2bd05 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -491,10 +491,23 @@ void generic_shutdown_super(struct super_block *sb)
>  		if (sop->put_super)
>  			sop->put_super(sb);
>  
> -		if (!list_empty(&sb->s_inodes)) {
> -			printk("VFS: Busy inodes after unmount of %s. "
> -			   "Self-destruct in 5 seconds.  Have a nice day...\n",
> -			   sb->s_id);
> +		if (CHECK_DATA_CORRUPTION(!list_empty(&sb->s_inodes),
> +				"VFS: Busy inodes after unmount of %s (%s)",
> +				sb->s_id, sb->s_type->name)) {
> +			/*
> +			 * Adding a proper bailout path here would be hard, but
> +			 * we can at least make it more likely that a later
> +			 * iput_final() or such crashes cleanly.
> +			 */
> +			struct inode *inode;
> +
> +			spin_lock(&sb->s_inode_list_lock);
> +			list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> +				inode->i_op = VFS_PTR_POISON;
> +				inode->i_sb = VFS_PTR_POISON;
> +				inode->i_mapping = VFS_PTR_POISON;
> +			}
> +			spin_unlock(&sb->s_inode_list_lock);
>  		}
>  	}
>  	spin_lock(&sb_lock);
> diff --git a/include/linux/poison.h b/include/linux/poison.h
> index 2d3249eb0e62..0e8a1f2ceb2f 100644
> --- a/include/linux/poison.h
> +++ b/include/linux/poison.h
> @@ -84,4 +84,7 @@
>  /********** kernel/bpf/ **********/
>  #define BPF_PTR_POISON ((void *)(0xeB9FUL + POISON_POINTER_DELTA))
>  
> +/********** VFS **********/
> +#define VFS_PTR_POISON ((void *)(0xF5 + POISON_POINTER_DELTA))
> +
>  #endif
> 
> base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
> -- 
> 2.39.0.314.g84b9a713c41-goog
> 

-- 
Kees Cook
