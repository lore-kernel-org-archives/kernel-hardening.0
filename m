Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 25 Aug 2011 21:56:02 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110825175602.GA3439@albatros>
References: <4E56483F.3070701@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E56483F.3070701@gentoo.org>
Subject: Re: [kernel-hardening] Trying to get PaX RANDMMAP into the
 mainstream kernel
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Anthony,

On Thu, Aug 25, 2011 at 09:03 -0400, Anthony G. Basile wrote:
> I had a brief conversation yesterday with solardiz on
> freenode/#openwall.  The topic turned to what other hardening code could
> go upstream besides the stuff you guys have already been pushing.

Sure!  The previous stuff was just a part that I've tried to somehow
handle during a short time window.


>  It
> would be nice if we could get PaX RANDMMAP in.  It gives better
> randomization on mmap addresses, but unfortunately breaks packages which
> use pre-compiled headers. [1]

Am I right that the difference is that upstream mmap() respects addr
hint from userspace and PaX ignores it?


> We came across this issue in a hardened gentoo bug.

Were gcc developers informed about the issue?  There is a small
possibility that they don't mind to fix it :)


> If RANDMMAP does get in, then this would be incentive to the gcc people
> to address the limitations of their gch code.  However, the logic works
> the other way, so this is also the barrier to getting RANDMMAP upstream.
> solardiz had a good idea: have some sysctl in /proc/sys/kernel either
> turn it on or off,

Do you mean ignore addr hint or respect it?  I find it too limited and
upstream is likely to NACK it.

As it is only a hint for OS, it could be simply ignored, without any
sysctl.  But as it breaks at least one widespread application, it's
unlikely to be applied by upstream :(


> or allow you to set the amount of randomization.

Agreed.  sysctl is good for containers, which handle ASLR different way.
E.g. some containers run apps which don't need much VA space, but
another container has space critical applications.


> Also, I don't know if people here are familiar with Hedrick's work.  He
> has broken up the grsec 50k line monolithic patch into smaller patches
> which address each feature individually.  Critical if you want to get
> any of this stuff upstream.

Great, I didn't know about it.  I'll look at it very soon.


Thanks,

-- 
Vasiliy
