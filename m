Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 2 Oct 2011 14:54:57 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111002105457.GA5598@albatros>
References: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
 <CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com>
 <CAA879TPzmVh4yR5n4Mfd8D6ERpvAFipeMXr1QBr3fwQMdvnRzw@mail.gmail.com>
 <CA+55aFyci1PB9Y_BSqWnQKSSfcCrbJud+q1Z8Cdquo7hXJZaMw@mail.gmail.com>
 <CAA879TMgMm4u6kDFahXqCHAFyvDc_hTt+Q93tdSdHKnAcUaMTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA879TMgMm4u6kDFahXqCHAFyvDc_hTt+Q93tdSdHKnAcUaMTw@mail.gmail.com>
Subject: [kernel-hardening] Re: taskstats root only breaking iotop
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Balbir Singh <bsingharora@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

(cc'ed kernel-hardening)

On Sun, Oct 02, 2011 at 12:22 +0200, Guillaume Chazarain wrote:
> On Sun, Oct 2, 2011 at 2:20 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > So I don't see why you ask for it. What could possibly be a valid use-case?
> 
> Right, kbyte granularity is enough.

It is not enough.  In some border cases an attacker may still learn
private information given the counters with _arbitrary_ granularity:

http://www.openwall.com/lists/oss-security/2011/06/29/9


> And that's consistent with
> /proc/vmstat, which nobody is complaining about.

<jumping with a raised hand>Me, me, it was me!</jumping with a raised hand>

Seriously, most of procfs files were created with relaxed permissions in
old days when nobody thought about such infoleaks.  Now it is much
harder to close all of them without breaking existing users.

http://www.openwall.com/lists/kernel-hardening/2011/07/28/1
http://www.openwall.com/lists/kernel-hardening/2011/09/27/3
http://www.openwall.com/lists/kernel-hardening/2011/09/19/24
http://www.openwall.com/lists/kernel-hardening/2011/09/21/2


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
