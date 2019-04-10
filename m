MIME-Version: 1.0
References: <20190410011418.76408-1-joel@joelfernandes.org>
 <20190410011418.76408-2-joel@joelfernandes.org> <20190409223820.511e3671@oasis.local.home>
 <20190410024103.GA104423@google.com> <20190409224826.308b12a4@oasis.local.home>
In-Reply-To: <20190409224826.308b12a4@oasis.local.home>
From: Joel Fernandes <joelaf@google.com>
Date: Tue, 9 Apr 2019 23:38:14 -0400
Message-ID: <CAJWu+orXgFkJpB8ww9kz_Nzmmj4qXjj2HtN_eDW3x+XPLbH0qw@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: Make srcu_struct ptr array as read-only post init
Content-Type: text/plain; charset="UTF-8"
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joel Fernandes <joel@joelfernandes.org>, LKML <linux-kernel@vger.kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@kernel.org>, kernel-hardening@lists.openwall.com, "Cc: Android Kernel" <kernel-team@android.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, rcu@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 9, 2019 at 10:48 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Tue, 9 Apr 2019 22:41:03 -0400
> Joel Fernandes <joel@joelfernandes.org> wrote:
>
> > > Other than that, the two patches look fine to me.
> >
> > Could I add your Reviewed-by in the respin?
>
> You can add an Acked-by, as I haven't spent enough time to offer a
> Reviewed-by tag. ;-)
>
> Maybe I'll get some time to vet it a bit more tomorrow, and then
> upgrade the ack to a review.
>
> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>

Thanks!

Also we could possibly consider adding the tracepoint ptrs array as
well to the list, which would be useful I think, if one were to over
write that array by accident (and the bpf tps related array too).

 - Joel
