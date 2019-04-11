Date: Thu, 11 Apr 2019 09:19:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v3 3/3] module: Make __tracepoints_ptrs as read-only
Message-ID: <20190411091955.67cdd9fd@gandalf.local.home>
In-Reply-To: <20190411082106.GB167446@google.com>
References: <20190410195708.162185-1-joel@joelfernandes.org>
	<20190410195708.162185-3-joel@joelfernandes.org>
	<20190410161112.540017d9@gandalf.local.home>
	<20190410202902.GA167446@google.com>
	<20190410204401.62f928ca@gandalf.local.home>
	<20190411082106.GB167446@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Joel Fernandes <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, keescook@chromium.org, mathieu.desnoyers@efficios.com, Jessica Yu <jeyu@kernel.org>, kernel-hardening@lists.openwall.com, kernel-team@android.com, rcu@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 11 Apr 2019 04:21:06 -0400
Joel Fernandes <joel@joelfernandes.org> wrote:

> Patch 2/3 and 3/3 would not be nececessary if this works out. 1/3 may be a
> nice clean up but is not something urgent and we could do that in the future
> if needed.

Well, jump_labels is "special" because it requires sorting the RO data
and is done via module notify. The only other user that had to modify
RO data on module load is ftrace. It had to do the nop conversions in
the text area. It use to do it via module notify, but because of the
hardening of the kernel, doing it there was no longer possible because
everything was RO then. The solution was to call into ftrace directly
from the module code instead of a notifier. This was done before
sections were made RO.

One option is to do the same with jump_labels and just have a call to
the sorting before the notifiers and before the section gets turned
into RO. Or I would say just leave it as is. As I stated, jump_labels
are "special" and adding a loop of one section where I don't envision
any other sections needing to do the same thing for a long time to
come. I would save that patch for if there is another section that
comes along that needs to be modify at module notify.

-- Steve
