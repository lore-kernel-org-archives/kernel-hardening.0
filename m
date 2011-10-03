Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 3 Oct 2011 15:31:58 +0300
From: Adrian Bunk <bunk@stusta.de>
Message-ID: <20111003123158.GA28898@localhost.pp.htv.fi>
References: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
 <CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com>
 <CAA879TPzmVh4yR5n4Mfd8D6ERpvAFipeMXr1QBr3fwQMdvnRzw@mail.gmail.com>
 <CA+55aFyci1PB9Y_BSqWnQKSSfcCrbJud+q1Z8Cdquo7hXJZaMw@mail.gmail.com>
 <CAA879TMgMm4u6kDFahXqCHAFyvDc_hTt+Q93tdSdHKnAcUaMTw@mail.gmail.com>
 <20111002105457.GA5598@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20111002105457.GA5598@albatros>
Subject: [kernel-hardening] Re: taskstats root only breaking iotop
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Guillaume Chazarain <guichaz@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Balbir Singh <bsingharora@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 02, 2011 at 02:54:57PM +0400, Vasiliy Kulikov wrote:
> (cc'ed kernel-hardening)
> 
> On Sun, Oct 02, 2011 at 12:22 +0200, Guillaume Chazarain wrote:
> > On Sun, Oct 2, 2011 at 2:20 AM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > So I don't see why you ask for it. What could possibly be a valid use-case?
> > 
> > Right, kbyte granularity is enough.
> 
> It is not enough.  In some border cases an attacker may still learn
> private information given the counters with _arbitrary_ granularity:
> 
> http://www.openwall.com/lists/oss-security/2011/06/29/9

If you request a CVE for that, shouldn't there also be a CVE for
/proc/<pid>/cmdline being readable by all users?

I'd expect "ps -ef" to be more likely to give private information to an 
attacker than counters with kbyte granularity, or am I wrong on that?

>...
> Thanks,

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed
