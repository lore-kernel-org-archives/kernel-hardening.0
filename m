Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Mar 2012 18:15:32 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120311171532.GB10787@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org>
 <CA+55aFzTXuvpqjDUtjN48cc3RWADryddVXxc2RQhj6sCK=V9ag@mail.gmail.com>
 <CA+55aFy-ktC3NG5Wc+vhWB+18aqj9a0VLUSKQg+KR=FsVqfoJQ@mail.gmail.com>
 <20120311140310.1c7c735f@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120311140310.1c7c735f@pyramind.ukuu.org.uk>
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2012 at 02:03:10PM +0000, Alan Cox wrote:
> > I wonder if the number part of exec_id would even have to be 64-bit. I
> > think I can do about 10000 execves per second if I make the program a
> > small static one - and that's on a fast CPU. And it's a per-thread
> > counter, so you can't scale it with lots of CPU's. So it would take
> > something like four days to wrap. Hmm..
> 
> I don't think an exec id trick works that well here. It needs to bind to
> the actual *object* being used and refcount it in the cases that matter,
> then have a proper way of ensuring we clean up references such as a list
> of objects to zap hooked to each task struct
> 
> So something like
> 
> 
> 	struct foo_node {
> 		struct list_node node;
> 		struct proc_object *ref;
> 	};
> 		
> 	ref = NULL;
> 	if (foo->ptr != NULL
> 		ref = kref_get(foo->ptr);
> 
> And in the task exit paths walk the node list doing a kref_put/NULL
Here I assume that you are talking about the target task.

Yes but proc inode which are created on the fly can also be released by
the reader before the target exits, so do we want to walk the node list
each time release is called by the reader ?

The current implementation tries to track target, but as noted in the
other thread we can just track the reader and in this case we do not need
atomic for task_struct nor for the proc_file_private, a simple u64
comparison will do the job

But perhaps what you propose is better, I'll try to think more about it.

> Add a suitable lock and it ought to be able to generically do that for
> anything you need to clobber.
> 
> You've still got a sort of race however, just as the proposed execid base
> code.  You can pass the fd and access the proc function *as* the exec
IMO the proposed patch do not suffer from this race if we do the propre
permission checks just after setting the exec_id at open, or do permission
checks and then check exec_id at read. And here I'm talking about target
tracking. If we just check reader (current) then I assume that there are no
room for races.

> occurs. Assuming your ref counting is valid and you use new objects after
> the exec that ought to just mean you get the data for the old mm struct,
> which seems fine to me. It's logically equivalent to having asked a
> microsecond before the exec rather than during it.
> 
> Alan
Thanks.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
tixxdz
http://opendz.org
