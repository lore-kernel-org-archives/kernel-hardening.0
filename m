Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 26 Jul 2011 16:07:04 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110726120704.GA3912@albatros>
References: <20110718194803.GA5337@albatros>
 <20110723150658.GA11156@openwall.com>
 <20110724083907.GA3659@albatros>
 <20110724140631.GA18345@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724140631.GA18345@openwall.com>
Subject: Re: [kernel-hardening] GNU_STACK policy problem
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar, Eugene,

On Sun, Jul 24, 2011 at 18:06 +0400, Solar Designer wrote:
> On Sun, Jul 24, 2011 at 12:39:07PM +0400, Vasiliy Kulikov wrote:
> > On Sat, Jul 23, 2011 at 19:06 +0400, Solar Designer wrote:
> > > I started looking into this, and here's what I found in RHEL 5 kernels:
> > 
> > Very interesting.  The same code is present in RHEL 6.  However, I don't
> > see the problem of GNU_STACK in DSOs is somehow solved.  Maybe RHEL 6
> > glibc has appropriate patches for loader?
> 
> I don't know.  Please take a look.

I failed to find anything GNU_STACK related in RHEL6 glibc patches.
Weird.  Probably they really decided to enforce NX GNU_STACK of binaries
only, leaving libraries' GNU_STACK as is (without NX enforcement)
because of the same reasons.

Thanks,

-- 
Vasiliy
