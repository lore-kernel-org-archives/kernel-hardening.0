Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 19 Jun 2011 18:12:32 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110619141232.GA3444@albatros>
References: <20110614083559.GB7973@albatros>
 <20110615143844.GB32753@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615143844.GB32753@openwall.com>
Subject: Re: [kernel-hardening] HARDEN_VM86
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Wed, Jun 15, 2011 at 18:38 +0400, Solar Designer wrote:
> BTW, a related syscall is modify_ldt(2).  You could want to research
> what programs use it, and consider restricting it as well.  Perhaps with
> a separate sysctl?

It starts to look like seccomp v2.

http://thread.gmane.org/gmane.linux.kernel/833539/focus=833864

- but with capable(CAP_SYS_RAWIO) instead of just deny and static
syscalls list.  Will Drewry is trying to push his limiting patch with
ftrace-like syntax restrictions, but (a) it is not yet applied and (b)
it is not inherited by execve's:

https://lkml.org/lkml/2011/6/12/184

If it was not limited to one task it would serve our needs :(


-- 
Vasiliy
