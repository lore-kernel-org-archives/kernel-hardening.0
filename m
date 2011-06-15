Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 15 Jun 2011 18:22:44 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110615142244.GA32753@openwall.com>
References: <1308146286-12840-1-git-send-email-segoon@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308146286-12840-1-git-send-email-segoon@openwall.com>
Subject: Re: [kernel-hardening] [RFC 2/5 v3] procfs: add hidepid= and gid= mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Wed, Jun 15, 2011 at 05:58:05PM +0400, Vasiliy Kulikov wrote:
> +	if (pid->hide_pid &&
> +	    !ptrace_may_access(task, PTRACE_MODE_READ) &&
> +	    !in_group_p(pid->pid_gid)) {

I think ptrace_may_access() involves capable() in some cases (when
access would otherwise be denied).  Thus, in order not to raise the used
privs flag unnecessarily, you need to check it last - after checking
in_group_p().

Thanks,

Alexander
