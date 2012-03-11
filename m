Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 12 Mar 2012 00:36:15 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120311233615.GD10787@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
 <20120311172512.GA2729@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120311172512.GA2729@redhat.com>
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2012 at 06:25:12PM +0100, Oleg Nesterov wrote:
> On 03/11, Djalal Harouni wrote:
> >
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1420,6 +1420,9 @@ struct task_struct {
> >  #endif
> >  	seccomp_t seccomp;
> >
> > +/* Execve counter: will be used to check if objects belong to the appropriate
> > + * process image */
> > +	atomic64_t exec_id;
> >  /* Thread group tracking */
> >     	u32 parent_exec_id;
> >     	u32 self_exec_id;
> 
> Well, I don't think it is right to add this counter into task_struct.
> 
> It should be per-process, signal_struct makes more sense. Or may be
> mm_struct.
Some /proc/<pid>/{syscall,stack,...} do not operate on mm_struct so why we
should add the: "acquire a reference to mm, get exec_id and mmput".

For the signal_struct currently I don't know, from a comment it seems that
signal_struct can be shared! I don't know.

> Btw this is also true for parent_exec_id/self_exec_id, but this is
> another story.
Yes someone who knows this should check it.

> Oleg.
Thanks.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
tixxdz
http://opendz.org
