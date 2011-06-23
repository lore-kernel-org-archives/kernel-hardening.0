Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 23 Jun 2011 21:11:43 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110623171143.GA3927@albatros>
References: <20110609141745.GA11957@albatros>
 <20110612022833.GB14976@openwall.com>
 <20110619133435.GA2670@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110619133435.GA2670@albatros>
Subject: Re: [kernel-hardening] rlimit_nproc check
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 19, 2011 at 17:34 +0400, Vasiliy Kulikov wrote:
> I have slightly another idea.  Introduce mechanism (e.g. sysctl
> variable) to make all capabilities dropping function cause SIGSEGV if
> actual dropping process fails for any of several reasons.
> 
> The initial list should look like this:
> 
>     set*{u,g}id
>     {set,init}groups
>     unshare
>     prctl(PR_CAPBSET_DROP, ...)
>     prctl(PR_SET_SECCOMP, ...)
>     capset
> [...]

The scheme actually is harmfull in some situations.  E.g. nfs daemon
with one process architecture switches to another user via setfsuid()
or similar, handles the request, switches back to the root.  If
setfsuid() fails (rlimit or some other reason) nfsd is DoS'ed by the
signal.  Any other daemon with similar architecture will be DoS'ed too.

So, the list of SIGKILL'able syscalls should be selected _very_
carefully (I don't know whether the safe list is nonempty).


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
