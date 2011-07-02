Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 2 Jul 2011 11:36:25 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110702073625.GA3318@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
 <20110629201718.GA11071@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110629201718.GA11071@albatros>
Subject: [kernel-hardening] Re: [PATCH 2/2] taskstats: restrict access to user
To: Balbir Singh <bsingharora@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org, Eric Paris <eparis@redhat.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 30, 2011 at 00:17 +0400, Vasiliy Kulikov wrote:
> On Wed, Jun 29, 2011 at 06:57 +0530, Balbir Singh wrote:
> > On Fri, Jun 24, 2011 at 5:39 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > > +               task = find_task_by_vpid(s->pid);
> > > +               if (!task || __task_cred(task)->euid != cred->euid) {
> 
> If consider this patch for inclusion, it also needs some check for
> the listener root ability.  __task_cred(task)->euid == 0 or smth like
> that.  But ptrace_task_may_access_current() is better.

So...  What to do with this patch?  Should I resend it with euid==0 and
rcu optimication, wait for the new ptrace interface or what?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
