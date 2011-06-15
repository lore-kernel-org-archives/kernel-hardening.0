Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 15 Jun 2011 20:51:40 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110615165140.GA17909@albatros>
References: <1308146286-12840-1-git-send-email-segoon@openwall.com>
 <20110615142244.GA32753@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615142244.GA32753@openwall.com>
Subject: Re: [kernel-hardening] [RFC 2/5 v3] procfs: add hidepid= and gid=
 mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Wed, Jun 15, 2011 at 18:22 +0400, Solar Designer wrote:
> On Wed, Jun 15, 2011 at 05:58:05PM +0400, Vasiliy Kulikov wrote:
> > +	if (pid->hide_pid &&
> > +	    !ptrace_may_access(task, PTRACE_MODE_READ) &&
> > +	    !in_group_p(pid->pid_gid)) {
> 
> I think ptrace_may_access() involves capable() in some cases (when
> access would otherwise be denied).  Thus, in order not to raise the used
> privs flag unnecessarily, you need to check it last - after checking
> in_group_p().

Yep, fixed here and in one more place, thanks.

-- 
Vasiliy
