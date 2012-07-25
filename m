Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 25 Jul 2012 14:16:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20120725121644.GA6584@redhat.com>
References: <1343143742-31229-1-git-send-email-tixxdz@opendz.org> <1343143742-31229-3-git-send-email-tixxdz@opendz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343143742-31229-3-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] Re: [PATCH v2 2/2] proc: do not allow negative offsets on
	/proc/<pid>/environ
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, Solar Designer <solar@openwall.com>, Kees Cook <keescook@chromium.org>, David Rientjes <rientjes@google.com>, Brad Spengler <spender@grsecurity.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/24, Djalal Harouni wrote:
>
>  static int mem_open(struct inode *inode, struct file *file)
>  {
> -	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
> +	int ret = __mem_open(inode, file, PTRACE_MODE_ATTACH);
> +
> +	/* OK to pass negative loff_t, we can catch out-of-range */
> +	file->f_mode |= FMODE_UNSIGNED_OFFSET;
> +
> +	return ret;
>  }

It could be even simpler, I meant

	file->f_mode |= FMODE_UNSIGNED_OFFSET;
	return __mem_open(inode, file, PTRACE_MODE_ATTACH);

Never mind, this is very minor and the patch is already in -mm.

Oleg.
