Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jun 2012 02:22:41 +0200 (CEST)
From: Pavel Kankovsky <peak@argo.troja.mff.cuni.cz>
In-Reply-To: <20120612093812.GA24809@albatros>
Message-ID: <alpine.LRH.2.02.1206130119370.32070@argo.troja.mff.cuni.cz>
References: <20120612093812.GA24809@albatros>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Subject: [kernel-hardening] Re: [owl-dev] RLIMIT_NPROC DoS fix
To: owl-dev@lists.openwall.com
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 12 Jun 2012, Vasily Kulikov wrote:

> There is a problem with RLIMIT_NPROC patch:
> http://www.openwall.com/lists/kernel-hardening/2011/06/12/9

I'd like to point out there are at least two other ways setuid() et alii 
can fail in recent kernels: LSM and memory allocation.

> 1) a root process sometimes does setrlimit()+setuid(U)+execve()/fork().
> In this case U can do kill(pid, SIGSTOP) each time just after setuid(U).
> U may store unlimited number of processes this way.
> (Spender has learned this way.)

You could probably refuse to handle SIGSTOP sent by a nonprivileged user 
when PF_NPROC_EXCEEDED is set. I do not thing it would break anything.
But it would make things even dirtier.

> 2) there are nonroot users A and B.
> A makes a binary ./loop which does setuid(A)+for(;;) {}
> A does chmod u+s ./loop
> B does 'while :; do ./loop &; done'

I think processes should count towards RLIMIT_NPROC of the user who forked 
them (B in this example) for the rest of their CPU cycles. Even after they 
exec a setuid program.

> Yes, this is dirty.  Any thoughts about less dirty way?

Create a cgroup controller limiting the number of tasks (and perhaps the 
number of other kernel objects) and pretend RLIMIT_NPROC has never 
existed?

-- 
Pavel Kankovsky aka Peak                          / Jeremiah 9:21        \
"For death is come up into our MS Windows(tm)..." \ 21st century edition /
