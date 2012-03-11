Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Mar 2012 09:39:15 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120311083915.GB4310@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
 <CA+55aFzTXuvpqjDUtjN48cc3RWADryddVXxc2RQhj6sCK=V9ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzTXuvpqjDUtjN48cc3RWADryddVXxc2RQhj6sCK=V9ag@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2012 at 04:12:20PM -0800, Linus Torvalds wrote:
> On Sat, Mar 10, 2012 at 3:25 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
> >
> > Given that consideration this patch introduces two counters:
> > A global atomic execve counter that will be incremented on every
> > do_execve_common() call, and an atomic exec_id member for the task_struct.
> 
> This seems horribly expensive on most 32-bit architectures, including
> very much x86-32. That atomic64_inc_return() is not cheap.  It's
> possible that it's basically an impossible operation to do atomically
> on certain platforms, causing it to use some random spinlock instead.
Yes it will use spinlocks, and before that we also hold the
current->signal->cred_guard_mutex during all the do_execve_common(), not
to mention the search_binary_handler() logic which will test binary
format... it can even call request_module()

There is the first:
exec_id = atomic64_inc_return(&exec_counter); /* increment global */

and the second one:
atomic64_set(&current->exec_id, exec_id); /* set task exec_id */

I've added this since when we track the target task we do not want to race
against it when it does its execve call or when we set the exec_id at
open time of the /proc/<pid>/* files.

I can remove this second one but in this situation we must track only
reader (current), which is an aggressive behaviour, actually it may be
safer to do so. I've made the target track change to fit the desired
behaviour of "bind files to their process image".

And when we are at it, we should only allow reading of /proc/<pid>/mem, at
least it's only info leak in case there are future changes that can affect
the current protections.

-- 
tixxdz
http://opendz.org
