Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 7 Jul 2011 12:55:51 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110707085551.GA4718@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
 <20110629201718.GA11071@albatros>
 <20110702073625.GA3318@albatros>
 <CAKTCnzmjaddz-ihxJ_qme28S==BAPGRmC2j3iE5fqm8TPi0knA@mail.gmail.com>
 <20110704174540.GA3321@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704174540.GA3321@albatros>
Subject: [kernel-hardening] Re: [PATCH 2/2] taskstats: restrict access to user
To: Balbir Singh <bsingharora@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org, Eric Paris <eparis@redhat.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 04, 2011 at 21:45 +0400, Vasiliy Kulikov wrote:
> The already known danger is these io fields.

Two more things:

1) unblocking netlink socket on task exit is a rather useful help to win
different races.  E.g. if the vulnerable program has the code -

    wait(NULL);
    do_smth_racy();

- then the attacker's task listening for the taskstats event will be
effectively woken up just before the racy code.  It might greatly
increase the chanses to win the race => to exploit the bug.
(The same defect exists in inotify.)


2) taskstats gives the task information at the precisely specific moment
- task death.  So, the attacker shouldn't guess whether some event
occured or not.  The formula of gotten information is _exactly_ task
activity during the life.  On the contrary, getting the same information
from procfs files might result in some inaccuracy because of measuring
time inaccuracy (scheduler's variability, different disks' load, etc.).

Of cource, (2) makes sense only if some sensible information is still
available through taskstats.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
