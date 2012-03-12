Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 12 Mar 2012 15:34:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
Message-ID: <20120312143400.GA23113@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com> <20120311233615.GD10787@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120311233615.GD10787@dztty>
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/12, Djalal Harouni wrote:
>
> On Sun, Mar 11, 2012 at 06:25:12PM +0100, Oleg Nesterov wrote:
> >
> > Well, I don't think it is right to add this counter into task_struct.
> >
> > It should be per-process, signal_struct makes more sense. Or may be
> > mm_struct.
> Some /proc/<pid>/{syscall,stack,...} do not operate on mm_struct so why we
> should add the: "acquire a reference to mm, get exec_id and mmput".

This could be simpler, just read the counter under task_lock(). And
unless I misread the next patches syscall/stack can use current->mm
lockless.

OK, nevermind.

> For the signal_struct currently I don't know, from a comment it seems that
> signal_struct can be shared!

Yes, it is shared, and that is why it makes sense for the per-process
data. All threads in the thread group (process) have the same ->signal.
And unlike ->mm, ->signal survives after exec.

Oleg.
