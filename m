Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 4 Jul 2011 21:45:40 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110704174540.GA3321@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
 <20110629201718.GA11071@albatros>
 <20110702073625.GA3318@albatros>
 <CAKTCnzmjaddz-ihxJ_qme28S==BAPGRmC2j3iE5fqm8TPi0knA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKTCnzmjaddz-ihxJ_qme28S==BAPGRmC2j3iE5fqm8TPi0knA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] taskstats: restrict access to user
To: Balbir Singh <bsingharora@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org, Eric Paris <eparis@redhat.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Balbir,

On Mon, Jul 04, 2011 at 08:27 +0530, Balbir Singh wrote:
> Would it be possible to audit the entire taskstats structure to see
> what fields should and should not be exposed. If a particular field
> should not be exposed, we can fill it in with a special value
> indicating additional permission is required to see it and fill in
> those fields only when credentials match like you've shown
> 
> Does that make sense?

I'm afraid there is no universal opinion about it.  My point is
(almost) all this information (unless it can be gathered more simple
way) can be used by an attacker in one or another situation (highly
conditional, he might have to win a race(s), etc.), which might not be
approved by other developers without a proof.

The review would be reduced to trying to exploit some programs using
this information (so, it would be still incomplete).  I don't feel
myself enough experienced in such types of exploitation to (a) imagine
the abstract attack scenario and (b) find a program this attack would be
targeted to.

The already known danger is these io fields.  I *suspect* scheduler,
timer, page faults, exit status, and memory related information can be
used in situations where changing these fields might reveal the very
fact of some private computation.  These are only my thoughts and I
couldn't find any more or less realistic scenario of exploitation.

ac_comm and credential fields values show the same information as procfs
files, but I still want to introduce configuration mechanism with a
separate patch to restrict these fields (both in taskstats and procfs)
to complicate attacker's job of probing system specific information.


So, I cannot fully answer to your question, sorry.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
