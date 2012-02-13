Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 13 Feb 2012 16:50:34 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120213155034.GA13844@dztty>
References: <20120210020658.GA17709@dztty>
 <20120211100709.GA18767@openwall.com>
 <20120212153612.GA15621@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120212153612.GA15621@dztty>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 12, 2012 at 04:36:12PM +0100, Djalal Harouni wrote:
> On Sat, Feb 11, 2012 at 02:07:09PM +0400, Solar Designer wrote:
> > On Fri, Feb 10, 2012 at 03:06:58AM +0100, Djalal Harouni wrote:
> > > 1) Infoleaks via self-read by a suid/guid:
> > ...
> > >    I believe to fix this we should just let 'mm_struct' point to the old
> > >    one (as done by Linus' commit [2] for the /proc/self/mem)
> > 
> > I dislike this approach because it introduces a resource limits bypass.
> > When you hold an mm, you hold all data of the old process in VM, right?
> I guess, but that code can be considered semantically correct since we did
> not release it.
> 
> Oleg's patch [1] makes sure that 'mm->mm_users' holds the right value, if
> the process drops the 'fd' the next read/write call will fail, so it will
> not be visible to userspace if the original process exits. It will fail
> at:
> if (!atomic_inc_not_zero(&mm->mm_users))
>   return NULL;
> 
> It will be freed only by the release function.
> 
> 
> Can you elaborate more on the resource limits bypass please ?
> 
> 
> I guess we can try this:
> self_pid = getpid()
> open("/proc/self_pid/mem")
> execv("/proc/self_pid/comm",...)
> 
> A quick slabtop shows that mm_struct objects keep increasing...
> But the 'fd' limit will kill the program, what about others ?
> 
Ok it seems that mm_struct can explode, thanks to the VFS:
/proc/sys/fs/file-max  (34869 on the tested system)
This will catch it...


Executing NR programs that keep /proc/self/mem open and re-exec or
whatever can show this behaviour:

slabtop:
OBJS   ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
186585 186410  99%    0.38K   8885       21     71080K kmemleak_object
...
 34233  31414  91%    1.25K   2858       12     45728K mm_struct
 34944  32062  91%    0.38K   1664       21     13312K filp
 44835  41973  93%    0.19K   2135       21      8540K kmalloc-192
...
   294    163  55%    4.88K     49        6      1568K task_struct

See: task_struct.


Hope this will help. Someone who knows this, can tell more.

Thanks.

-- 
tixxdz
http://opendz.org
