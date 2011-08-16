Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 16 Aug 2011 10:39:01 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110816063901.GC3733@albatros>
References: <20110813151220.GA8388@albatros>
 <20110813151947.GA12495@openwall.com>
 <20110813165502.GA9328@albatros>
 <20110814095010.GA14443@openwall.com>
 <20110814101658.GA20509@albatros>
 <20110814112922.GA15012@openwall.com>
 <20110814115549.GA3423@albatros>
 <20110814120448.GA15372@openwall.com>
 <20110815153836.GA6060@albatros>
 <20110815213339.GB20895@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110815213339.GB20895@openwall.com>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Tue, Aug 16, 2011 at 01:33 +0400, Solar Designer wrote:
> Are you proposing this for OpenVZ and distro kernels now?

For OpenVZ it needs s/CAP_SYS_ADMIN/CAP_VE_SYS_ADMIN/ to be able to use
the feature by in-CT root programs.  But given it doesn't go to
upstream, it's unlikely to be needed.

As for the implementation, it looks it's ready and it passes lock.c
tests.  But, as usual, additional testing doesn't hurt :)

Thanks,

-- 
Vasiliy
