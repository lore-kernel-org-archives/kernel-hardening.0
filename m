Return-Path: <kernel-hardening-return-21600-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 60180C25B4E
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Jan 2023 10:12:41 +0000 (UTC)
Received: (qmail 19596 invoked by uid 550); 24 Jan 2023 10:12:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19559 invoked from network); 24 Jan 2023 10:12:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674555132;
	bh=Hikckpna3DVXXZPGZ4BuFVYPSnZbNR3v/om5urasXP8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jvS8tFYynVdhY+yLg/Uo8uGL7xBxvivN7Dj+2pb5uR00svQO750DkL7jkIcs8kxEz
	 /qr1QDFUHdIIuaYYn0MsgtVe/07se6catfUuNh7FLGIMb2tR/viH5ROJRNF6vLRI3Y
	 mftyt3O+8jzURwwcJ+k4EizDX6UfnTBrg57Ym+V6lbxWYZEvvMDbxtTXTKp6LQ9Kac
	 HMhWxO3evQAAYoHX73patO6mAOVKmp5Oi94nlj4NDZcL9LJPqPJCPSy4H/vanOOL1q
	 pmV19yMGDJjwF8HID2HvxUyd0qIMLC99Q4IylZm9gZvl8vRUIMlWayW55xN4G1A+Jd
	 +eX5NfNWoxZNw==
Date: Tue, 24 Jan 2023 11:12:07 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] fs: Use CHECK_DATA_CORRUPTION() when kernel bugs are
 detected
Message-ID: <20230124101207.ofqr6qv2yla24jyd@wittgenstein>
References: <20230116191425.458864-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
> 
> Signed-off-by: Jann Horn <jannh@google.com>
> ---

Looks good,
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
