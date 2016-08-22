Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160822175307.GI3482@linux.vnet.ibm.com>
References: <1471470132-29499-1-git-send-email-keescook@chromium.org>
 <1471470132-29499-5-git-send-email-keescook@chromium.org> <4367840.AWTJIHYqbe@wuerfel>
 <20160822175307.GI3482@linux.vnet.ibm.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 22 Aug 2016 15:32:06 -0700
Message-ID: <CAGXu5j+wRSe1srP9kQhzgmhpXoKr4MeOS1=e+Nmo91KudW-szg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v3 4/5] bug: Provide toggle for BUG
 on data corruption
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Stephen Boyd <sboyd@codeaurora.org>, Syed Rameez Mustafa <rameezmustafa@codeaurora.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 22, 2016 at 10:53 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Aug 22, 2016 at 03:15:35PM +0200, Arnd Bergmann wrote:
>> On Wednesday, August 17, 2016 2:42:11 PM CEST Kees Cook wrote:
>> > +
>> > +/*
>> > + * Since detected data corruption should stop operation on the affected
>> > + * structures, this returns false if the corruption condition is found.
>> > + */
>> > +#define CHECK_DATA_CORRUPTION(condition, fmt, ...)                      \
>> > +       do {                                                             \
>> > +               if (unlikely(condition)) {                               \
>> > +                       if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
>> > +                               pr_err(fmt, ##__VA_ARGS__);              \
>> > +                               BUG();                                   \
>> > +                       } else                                           \
>> > +                               WARN(1, fmt, ##__VA_ARGS__);             \
>> > +                       return false;                                    \
>> > +               }                                                        \
>> > +       } while (0)
>> > +
>>
>> I think the "return false" inside of the macro makes it easy to misread
>> what is actually going on.
>>
>> How about making it a macro that returns the condition argument?
>>
>> #define CHECK_DATA_CORRUPTION(condition, fmt, ...)    \
>> ({    \
>>       bool _condition = unlikely(condition);  \
>>       if (_condition) {       \
>>               ...
>>       }       \
>>       _condition;     \
>> })
>
> That does look better, now that you mention it.  Kees, any objections?

That's fine with me; it'll require changing the callers of the macros
to test their results, but that should be clean change.

-Kees

-- 
Kees Cook
Nexus Security
