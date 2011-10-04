Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 4 Oct 2011 17:31:26 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111004133125.GA11257@albatros>
References: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
 <CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com>
 <CAA879TPzmVh4yR5n4Mfd8D6ERpvAFipeMXr1QBr3fwQMdvnRzw@mail.gmail.com>
 <CA+55aFyci1PB9Y_BSqWnQKSSfcCrbJud+q1Z8Cdquo7hXJZaMw@mail.gmail.com>
 <CAA879TMgMm4u6kDFahXqCHAFyvDc_hTt+Q93tdSdHKnAcUaMTw@mail.gmail.com>
 <20111002105457.GA5598@albatros>
 <20111003123158.GA28898@localhost.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003123158.GA28898@localhost.pp.htv.fi>
Subject: [kernel-hardening] Re: taskstats root only breaking iotop
To: Adrian Bunk <bunk@stusta.de>
Cc: Guillaume Chazarain <guichaz@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Balbir Singh <bsingharora@gmail.com>, kernel-hardening@lists.openwall.com, Andrew Morton <akpm00@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 03, 2011 at 15:31 +0300, Adrian Bunk wrote:
> On Sun, Oct 02, 2011 at 02:54:57PM +0400, Vasiliy Kulikov wrote:
> > (cc'ed kernel-hardening)
> > 
> > On Sun, Oct 02, 2011 at 12:22 +0200, Guillaume Chazarain wrote:
> > > On Sun, Oct 2, 2011 at 2:20 AM, Linus Torvalds
> > > <torvalds@linux-foundation.org> wrote:
> > > > So I don't see why you ask for it. What could possibly be a valid use-case?
> > > 
> > > Right, kbyte granularity is enough.
> > 
> > It is not enough.  In some border cases an attacker may still learn
> > private information given the counters with _arbitrary_ granularity:
> > 
> > http://www.openwall.com/lists/oss-security/2011/06/29/9
> 
> If you request a CVE for that, shouldn't there also be a CVE for
> /proc/<pid>/cmdline being readable by all users?
> 
> I'd expect "ps -ef" to be more likely to give private information to an 
> attacker than counters with kbyte granularity, or am I wrong on that?

I agree that world-readable cmdline can be a privacy issue in some
cases.  I tried to push a patch introducing procfs mount option to
restrict /proc/PID/ to PID owner to address the issue (as world-readable
cmdline and other files are already used by plenty of programs and
unconditionally breaking backward compatibility is not good, a
configuration mechanism is needed), but it didn't receive positive
feedback.  A more detailed explanation from Solar Designer:

http://www.openwall.com/lists/kernel-hardening/2011/06/20/5

Andrew Morton complained that it is too specific to our needs and one
might want to define more fine granted procfs security model:

http://www.openwall.com/lists/kernel-hardening/2011/06/21/3

I've tried to address it and defined per-file policy:

http://www.openwall.com/lists/kernel-hardening/2011/08/10/12

No comments so far :(

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
