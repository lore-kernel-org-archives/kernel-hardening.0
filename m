Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 12 Jun 2011 17:12:24 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110612131223.GA3994@albatros>
References: <20110609141745.GA11957@albatros>
 <20110612022833.GB14976@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612022833.GB14976@openwall.com>
Subject: Re: [kernel-hardening] rlimit_nproc check
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sun, Jun 12, 2011 at 06:28 +0400, Solar Designer wrote:
> As an option, you could propose to revert that 8-year old change and
> introduce the check on execve().  Unrealistic?

I've started a separate thread on LKML for it, we'll see ;)

> Oh, by the way, here's what I found:
> 
> Subject: [PATCH] sched: Don't allow setuid to succeed if the user does not have rt bandwidth
> http://lists.openwall.net/linux-kernel/2009/02/27/177

Yeah, but it was removed in 7c9414385ebfdd87cc542d4e7e3bb0dbb2d3ce25 as
a "2.6.34 scheduled cleanup".


Thanks,

-- 
Vasiliy
