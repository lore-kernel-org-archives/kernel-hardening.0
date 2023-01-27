Return-Path: <kernel-hardening-return-21622-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 53182C61DA4
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Jan 2023 18:38:42 +0000 (UTC)
Received: (qmail 11867 invoked by uid 550); 27 Jan 2023 18:38:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11832 invoked from network); 27 Jan 2023 18:38:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rHuDJ9RucUYhCg8ApwjHdMewmia/AXOlZBZXO55pQg4=;
        b=RmE65qt1a1ZbGCMjQzVMq0GhHKeBfxlz+MBM6Eq9URWpP3LIKMz2EazDPJtt1bblme
         LOR/+/i+fVokKlYHfgyshAE+35fwF2mGlbWHaA/xtwjOH123ijopEjAce5uujFmEQ/qT
         1ksiRo6KrNJ4TcjDr7Y7urWHe7xb3ZHghvPoQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rHuDJ9RucUYhCg8ApwjHdMewmia/AXOlZBZXO55pQg4=;
        b=nsPA7aOpWWozR4rNGAwOAxFdF0iRElKTND50/84vxifPkeSb92C5d76nsJ0zK6xCXu
         2s1bQ2BeGAaR5SrsKv8apQ6rnKzu1++8dXeUQp3iyOFRysnWEC3uHzgjXO6N1oY02AYD
         h+kIp+EpgJv4rxLVVnWupUAWyTyVs4tz6pbP6qBpvoY7GN3b/XF9t8ckGptfJdvXMRj+
         ryg/XoM2vsFRvWeoNky8HiHy+DSdmcYBEJQJslV5Nc+qMWbGbUdk6nbVpUcwCGx0B7Rt
         GEn57COL9rbpkSdAYAzBAjmjUUfAWdrhi6xfnmW7/lMUgcfnRzDPBJmMjrxaeNH5pcoR
         vmCA==
X-Gm-Message-State: AO0yUKVVDoEAgD+bzRGGhJ5lML1PnfmjrjrqPBRf5QosxNZQhOQ4HYsU
	op0YTFWH9ayGwG0H2QCfNwn1KQ==
X-Google-Smtp-Source: AK7set9l3nqdTnXHNILcrLjSSOwU/xz5W5jOEeN3EGtBcJyIYZZUIrUSGbVwsjhJIzj6ZGKzOdxo1g==
X-Received: by 2002:a62:1b14:0:b0:58b:c1a1:4006 with SMTP id b20-20020a621b14000000b0058bc1a14006mr7347583pfb.18.1674844700509;
        Fri, 27 Jan 2023 10:38:20 -0800 (PST)
Date: Fri, 27 Jan 2023 10:38:19 -0800
From: Kees Cook <keescook@chromium.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] fs: Use CHECK_DATA_CORRUPTION() when kernel bugs are
 detected
Message-ID: <202301271038.1E64668B@keescook>
References: <20230116191425.458864-1-jannh@google.com>
 <202301260835.61F1C2CA4D@keescook>
 <20230127105815.adgqe2opfzruxk7e@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127105815.adgqe2opfzruxk7e@wittgenstein>

On Fri, Jan 27, 2023 at 11:58:15AM +0100, Christian Brauner wrote:
> On Thu, Jan 26, 2023 at 08:35:49AM -0800, Kees Cook wrote:
> > On Mon, Jan 16, 2023 at 08:14:25PM +0100, Jann Horn wrote:
> > > Currently, filp_close() and generic_shutdown_super() use printk() to log
> > > messages when bugs are detected. This is problematic because infrastructure
> > > like syzkaller has no idea that this message indicates a bug.
> > > In addition, some people explicitly want their kernels to BUG() when kernel
> > > data corruption has been detected (CONFIG_BUG_ON_DATA_CORRUPTION).
> > > And finally, when generic_shutdown_super() detects remaining inodes on a
> > > system without CONFIG_BUG_ON_DATA_CORRUPTION, it would be nice if later
> > > accesses to a busy inode would at least crash somewhat cleanly rather than
> > > walking through freed memory.
> > > 
> > > To address all three, use CHECK_DATA_CORRUPTION() when kernel bugs are
> > > detected.
> > 
> > Seems reasonable to me. I'll carry this unless someone else speaks up.
> 
> I've already picked this into a branch with other fs changes for coming cycle.

Okay, great! I'll drop it from my tree.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
