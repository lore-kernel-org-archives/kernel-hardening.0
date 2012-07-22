Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 22 Jul 2012 22:00:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20120722200049.GA29222@redhat.com>
References: <1342974959-2748-1-git-send-email-tixxdz@opendz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342974959-2748-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] Re: [PATCH] proc: do not allow negative offsets on
	/proc/<pid>/environ
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, Solar Designer <solar@openwall.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/22, Djalal Harouni wrote:
>
> __mem_open() which is called by both /proc/<pid>/environ and
> /proc/<pid>/mem ->open() handlers will allow the use of negative offsets.
> /proc/<pid>/mem has negative offsets but not /proc/<pid>/environ.

Probablt the patch makes sense, but I can't understand the changelog...

> Allowing negative offsets on /proc/<pid>/environ can turn it to act like
> /proc/<pid>/mem. A negative offset will pass the
> fs/read_write.c:lseek_execute() and the environ_read() checks and will
> point to another VMA.

which VMA?

environ_read() can only read the memory from [env_start, env_end], and
it should check *ppos anyway to ensure it doesn't read something else.

>  static int mem_open(struct inode *inode, struct file *file)
>  {
> -	return __mem_open(inode, file, PTRACE_MODE_ATTACH);
> +	int ret = __mem_open(inode, file, PTRACE_MODE_ATTACH);
> +	if (!ret)
> +		/* OK to pass negative loff_t, we can catch out-of-range */
> +		file->f_mode |= FMODE_UNSIGNED_OFFSET;
> +
> +	return ret;

I guess you can set FMODE_UNSIGNED_OFFSET unconditionally, it doesn't
matter if __mem_open() fails. But I won't insist.

Oleg.
