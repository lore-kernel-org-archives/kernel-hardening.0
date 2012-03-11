Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 10 Mar 2012 16:01:09 -0800
Message-ID: <CA+55aFwdOgt=C52APPyvnAitcWNbzu-uXRi43m4bLS85oDgtqA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 0/9] proc: protect /proc/<pid>/* files across execve
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2012 at 3:25 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>
> 1) Use the target exec_id to bind files to their exec_id task:
>
> For the REG files /proc/<pid>/{environ,pagemap,mem} we set the exec_id
> of the proc_file_private to the target task, and we continue with
> permission checks at open time, later on each read/write call the
> permission checks are done + check the target exec_id if it equals the
> exec_id of the proc_file_private that was set at open time, in other words
> we bind the file to its task's exec_id, this way new exec programs can not
> operate on the passed fd.

So the exec_id approach was totally broken when it was used for
/proc/<pid>/mem, is there any reason to believe it's a good idea now?

It's entirely predictable, and you can make the exec_id match by
simply forking elsewhere and then passing the fd around using unix
domain sockets, since the exec_id is just updated by incrementing a
counter.

I would in general suggest strongly against using exec_id for anything
that involves files. It isn't designed for that, it's designed for the
whole "check the parent exec_id" thing for ptrace, where that whole
"pass things around to another process" approach doesn't work.

                Linus
