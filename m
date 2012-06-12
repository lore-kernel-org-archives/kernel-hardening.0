Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 12 Jun 2012 13:38:12 +0400
From: Vasily Kulikov <segoon@openwall.com>
Message-ID: <20120612093812.GA24809@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] RLIMIT_NPROC DoS fix
To: owl-dev@lists.openwall.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

There is a problem with RLIMIT_NPROC patch:
http://www.openwall.com/lists/kernel-hardening/2011/06/12/9
http://www.openwall.com/lists/kernel-hardening/2011/08/08/2

As planned, it moves RLIMIT check from set_user() (set*uid()) stage to
fork()/execve() stage.  But the drawback is that now there is no RLIMIT
check at set_user().  It means that there are two bad cases:

1) a root process sometimes does setrlimit()+setuid(U)+execve()/fork().
In this case U can do kill(pid, SIGSTOP) each time just after setuid(U).
U may store unlimited number of processes this way.
(Spender has learned this way.)

2) there are nonroot users A and B.
A makes a binary ./loop which does setuid(A)+for(;;) {}
A does chmod u+s ./loop
B does 'while :; do ./loop &; done'


IOW, if there is a way one can produce unlimited number of processes at
atfer-setuid before-execve stage, one may DoS the system.

I don't see any fair way to fix that.  The way I see is using additional
limit which is used to kill overmultiplied processes.  E.g.:

set_user()
{
    ...
	if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
			new_user != INIT_USER) {
		if (atomic_read(&new_user->processes) >= 2*rlimit(RLIMIT_NPROC) + 10) {
		    ...some ratelimited printk warning...
		    force_sig(SIGKILL, current);
		}
		current->flags |= PF_NPROC_EXCEEDED;
	} else {
		current->flags &= ~PF_NPROC_EXCEEDED;
    }
        
    ...
}

Yes, this is dirty.  Any thoughts about less dirty way?

-- 
Vasily
