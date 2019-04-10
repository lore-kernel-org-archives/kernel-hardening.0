Date: Wed, 10 Apr 2019 00:20:49 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Message-ID: <475423743.2834.1554870049461.JavaMail.zimbra@efficios.com>
In-Reply-To: <CAJWu+orXgFkJpB8ww9kz_Nzmmj4qXjj2HtN_eDW3x+XPLbH0qw@mail.gmail.com>
References: <20190410011418.76408-1-joel@joelfernandes.org> <20190410011418.76408-2-joel@joelfernandes.org> <20190409223820.511e3671@oasis.local.home> <20190410024103.GA104423@google.com> <20190409224826.308b12a4@oasis.local.home> <CAJWu+orXgFkJpB8ww9kz_Nzmmj4qXjj2HtN_eDW3x+XPLbH0qw@mail.gmail.com>
Subject: Re: [PATCH 2/2] module: Make srcu_struct ptr array as read-only
 post init
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Joel Fernandes <joelaf@google.com>
Cc: rostedt <rostedt@goodmis.org>, "Joel Fernandes, Google" <joel@joelfernandes.org>, linux-kernel <linux-kernel@vger.kernel.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Jessica Yu <jeyu@kernel.org>, kernel-hardening <kernel-hardening@lists.openwall.com>, kernel-team <kernel-team@android.com>, rcu <rcu@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

----- On Apr 9, 2019, at 11:38 PM, Joel Fernandes joelaf@google.com wrote:

> On Tue, Apr 9, 2019 at 10:48 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>>
>> On Tue, 9 Apr 2019 22:41:03 -0400
>> Joel Fernandes <joel@joelfernandes.org> wrote:
>>
>> > > Other than that, the two patches look fine to me.
>> >
>> > Could I add your Reviewed-by in the respin?
>>
>> You can add an Acked-by, as I haven't spent enough time to offer a
>> Reviewed-by tag. ;-)
>>
>> Maybe I'll get some time to vet it a bit more tomorrow, and then
>> upgrade the ack to a review.
>>
>> Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>>
> 
> Thanks!
> 
> Also we could possibly consider adding the tracepoint ptrs array as
> well to the list, which would be useful I think, if one were to over
> write that array by accident (and the bpf tps related array too).

Yes, please!

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
