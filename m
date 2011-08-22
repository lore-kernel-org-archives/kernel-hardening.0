Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 22 Aug 2011 14:05:12 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110822100512.GA2878@albatros>
References: <20110817191550.GA18554@albatros>
 <20110820142723.GA5708@albatros>
 <20110820163120.GA7256@openwall.com>
 <20110822092429.GA29597@albatros>
 <20110822093819.GA13665@openwall.com>
 <20110822094558.GA2620@albatros>
 <20110822095354.GA13836@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822095354.GA13836@openwall.com>
Subject: Re: [kernel-hardening] kmalloc() nofail allocations
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Mon, Aug 22, 2011 at 13:53 +0400, Solar Designer wrote:
> However, is there any difference for the caller between kmalloc()
> looping until success (and thus only returning on success) and it
> OOM-killing the current process (and thus also only returning on
> success)?  Or does this question somehow not apply to the problem you
> discovered?

The "cannot fail" loop stops if the current task is marked as
to-be-killed-by-oom-killer.  OOM killer doesn't immediately kill the
task, the task exits itself after the exit from kernel mode and a
scheduler step (AFAIU).


So, AFAICS, the loop is executed only if:

1) Appropriate flags are passed (no NOWAIT, etc.), sane NUMA node list is
passed (e.g. not GFP_THISNODE and node list without current node).

2) Size is not big (less than PAGE_SIZE << 3).

3) Debugging allocation failure injection is either off or has a
min size more than the current allocation size.

4) OOM killer didn't mark the task with TIF_MEMDIE.


Thanks,

-- 
Vasiliy
