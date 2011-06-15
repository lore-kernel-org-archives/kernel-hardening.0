Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 15 Jun 2011 18:42:45 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110615144245.GC32753@openwall.com>
References: <20110613064252.GB3877@albatros> <20110613070700.GA22659@openwall.com> <20110614083318.GA8710@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614083318.GA8710@albatros>
Subject: Re: [kernel-hardening] destroy unused shmem segments
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Tue, Jun 14, 2011 at 12:33:45PM +0400, Vasiliy Kulikov wrote:
> It is used in case shmem segment was created, but never used.  In this
> case refcount is never incremented and never decremented, shm_clone()
> isn't called.
> 
> If shmctl() sets IPC_RMID, it is deleted, but as you have implemented
> implicit semantics (like IPC_RMID is always set), actual check in
> shmget()+exit() is needed.
> 
> Spotted by reading -ow README and testing :)

Oh, right.  Having documentation is good.

> I think forcing IPC_RMID should be configurable via sysctl like other
> ipc variables.  Something like /proc/sys/kernel/shm_orphans_denied.
> And I think changing it from 0 to 1 should destroy already orphaned
> segments without users.

OK.

Thanks,

Alexander
