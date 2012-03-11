Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Mar 2012 11:05:23 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
Message-ID: <20120311080523.GB3794@p183.telecom.by>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-9-git-send-email-tixxdz@opendz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331421919-15499-9-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] Re: [PATCH 8/9] proc: protect /proc/<pid>/{environ,pagemap} across
 execve
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2012 at 12:25:18AM +0100, Djalal Harouni wrote:
> The /proc/<pid>/{environ,pagemap} are sensitive files which must be
> protected across execve to avoid information leaks.
> 
> These files are protected by attaching them to their task at open time by
> saving the exec_id of the target task, this way in read we just compare
> the target task's exec_id and the previously saved exec_id of the
> proc_file_private struct, in other words we just bind these files to their
> appropriate process image at open time. We do this since we are able to do
> proper permission checks (ptrace) at each syscall, so we do not care about
> the reader.
> 
> Another important rule is to set the exec_id of the target task before the
> permission checks at open, this way we do not race against target task
> execve, and it will be more effective if the exec_id check at read/write
> times are delayed as much as possible to be sure that the target task do
> not change during execve.
> 
> This patch adds the open file_operation to the
> /proc/<pid>/{environ,pagemap} so we are able to set the exec_id of the
> target task and to do the appropriate permission checks. The exec_id check
> is done in the related read file_operation.

->open is duplicated.

> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> +static int environ_open(struct inode *inode, struct file *filp)
