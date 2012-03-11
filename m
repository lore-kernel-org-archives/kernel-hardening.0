Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Mar 2012 01:27:25 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120311002725.GA4310@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <CA+55aFwdOgt=C52APPyvnAitcWNbzu-uXRi43m4bLS85oDgtqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwdOgt=C52APPyvnAitcWNbzu-uXRi43m4bLS85oDgtqA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 0/9] proc: protect /proc/<pid>/* files across execve
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2012 at 04:01:09PM -0800, Linus Torvalds wrote:
> On Sat, Mar 10, 2012 at 3:25 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >
> > 1) Use the target exec_id to bind files to their exec_id task:
> >
> > For the REG files /proc/<pid>/{environ,pagemap,mem} we set the exec_id
> > of the proc_file_private to the target task, and we continue with
> > permission checks at open time, later on each read/write call the
> > permission checks are done + check the target exec_id if it equals the
> > exec_id of the proc_file_private that was set at open time, in other words
> > we bind the file to its task's exec_id, this way new exec programs can not
> > operate on the passed fd.
> 
> So the exec_id approach was totally broken when it was used for
> /proc/<pid>/mem, is there any reason to believe it's a good idea now?
Yes the previously one was broken since it was not a global uniq exec_id,
it was designed for threads tracking.

The current one is a global exec_id with uniq IDs, incremented on each
do_execve_common() call.

> It's entirely predictable, and you can make the exec_id match by
> simply forking elsewhere and then passing the fd around using unix
> domain sockets, since the exec_id is just updated by incrementing a
> counter.
For the fork one yes exec_id will match but we have the permission
checks (ptrace) at each syscall, so even if two processes share the same
exec_id the ptrace check should fail.

Yes it's predictable, but I don't see how you could pass the fd to another
extern privileged process without failing at the exec_id check.

-- 
tixxdz
http://opendz.org
