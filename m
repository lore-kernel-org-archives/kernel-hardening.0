Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 18 Jul 2011 22:46:32 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110718184632.GB3748@albatros>
References: <20110628172108.GA3156@albatros>
 <20110714161309.GA30371@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714161309.GA30371@albatros>
Subject: [kernel-hardening] Re: PAX_USERCOPY testing
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Thu, Jul 14, 2011 at 20:13 +0400, Vasiliy Kulikov wrote:
> This is a version of PAX_USERCOPY I want to send to LKML.  However, the
> patch without performance testing would be incomplete.  I have some
> syscalls measurements, the worst case is gethostname() with 6-7% penalty
> on x86-64 (Intel Core 2 Duo 2Ghz).

The previous benchmarks are totally wrong.  I didn't disable background
daemons, which created significant error, and used on-demand CPU
governor, which finally smashed results.

Measurements with maximum governor and with minimum processes showed
great "boost":

The worst case of tiny syscalls, gethostname(), has 0,9% slowdown.

Real workflows - find /usr, git log -Sredirect, make in kernel tree,
files copying - are not affected by the feature at all (the slowdown is
so low that I cannot effectively measure it, so it is less than 0,1%).

So, I've sent RFCv2 to LKML as-is :-)

I suppose no sysctl to control the behaviour is needed - the permormance
is acceptable for real workflows IMO.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
