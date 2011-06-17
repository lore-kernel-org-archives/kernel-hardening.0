Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 17 Jun 2011 12:36:51 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
Message-ID: <20110617083651.GA5625@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] How to temporary change 'current' (task)
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I wonder whether there is a simple way to temporary switch 'current' to
another task and then switch it back with minimum side effects?  I need
it to call "reversed" ptrace_may_access() with swapped current and
target task.  Introducing ptrace_task_may_access_me() would produce too
much noise in LSM (it also needs reversed security_ptrace_access_check()),
which is too loud for my needs.

Specifically, I need it to filter taskstats and proc connector requests
for a restriction of getting other processes' information:

http://permalink.gmane.org/gmane.linux.kernel/1155354

As the check is handled in the context of the ptrace target process,
ptrace_may_access() doesn't fit my needs.

Thanks,

-- 
Vasiliy
