Date: Thu, 4 Apr 2019 15:09:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Convert struct pid count to refcount_t
In-Reply-To: <20190404180842.GB183378@google.com>
Message-ID: <Pine.LNX.4.44L0.1904041504500.1288-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Joel Fernandes <joel@joelfernandes.org>
Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>, Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Michal Hocko <mhocko@suse.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 4 Apr 2019, Joel Fernandes wrote:

> FWIW, thought to mention (feel free ignore the suggestion if its
> meaningless): If there is any chance that the outcome can be better
> outputted, like r1=X; x=1; Where X stands for the result of a data race, that
> would be lovely.  I don't know much about herd internals (yet) to say if the
> suggestion makes sense but as a user, it would certainly help reduce
> confusion.

I don't think that is feasible.  For one thing, according to the C 
Standard, in the presence of a data race a program is allowed to do 
anything at all.  There's no point trying to display all possible 
outcomes of an execution!

If we adopted the proposal that certain kinds of data races only result
in undefined values, things would be a little better.  It's possible
that the herd program could be changed to support undefined values.  
At present, however, it does not.

Alan Stern
