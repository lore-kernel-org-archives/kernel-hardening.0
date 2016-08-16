Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160816175726.31b55326@gandalf.local.home>
References: <1471381865-25724-1-git-send-email-keescook@chromium.org>
 <1471381865-25724-5-git-send-email-keescook@chromium.org> <20160816212605.GY3482@linux.vnet.ibm.com>
 <CAGXu5jLGRL9PaLMVwGQ39_GUeMdBJgD03-PCYZ9KvtUF7aHt=Q@mail.gmail.com>
 <20160816175354.0b58d5f3@gandalf.local.home> <20160816175726.31b55326@gandalf.local.home>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 16 Aug 2016 16:14:05 -0700
Message-ID: <CAGXu5jK4TfAqr92cAfd406eRG2_VR7yCQkFKQYD5wFfVhPg2AA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 4/5] bug: Provide toggle for BUG on data corruption
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>, Stephen Boyd <sboyd@codeaurora.org>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Joe Perches <joe@perches.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 16, 2016 at 2:57 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 16 Aug 2016 17:53:54 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>
>>              WARN(1, "list_del corruption. next->prev should be %p, but was %p\n",
>>                      entry, next->prev);
>>              BUG_ON(CORRUPTED_DATA_STRUCTURE);
>>
>> Will always warn (as stated by "1") and and the BUG_ON() will bug if
>> CORRUPTED_DATA_STRUCTURE is set. Although, I don't like that name. Can
>> we have a:
>>
>>  BUG_ON(BUG_ON_CORRUPTED_DATA_STRUCTURES);
>>
>> Or maybe have that as a macro:
>>
>> #ifdef CONFIG_BUG_ON_CORRUPTION
>> # define BUG_ON_CORRUPTED_DATA_STRUCTURE() BUG_ON(1)
>> #else
>> # define BUG_ON_CORRUPTED_DATA_STRUCTURE() do {} while (0)
>> #endif
>>
>> Then we can have:
>>
>>              WARN(1, "list_del corruption. next->prev should be %p, but was %p\n",
>>                      entry, next->prev);
>>              BUG_ON_CORRUPTED_DATA_STRUCTURE();
>>
>> ??
>>
>
> Hmm, maybe better yet, just have it called "CORRUPTED_DATA_STRUCTURE()"
> because it wont bug if the config is not set, and having "BUG_ON" in
> the name, it might be somewhat confusing.

Yeah, I'm trying to redesign this now, since one thing I think is
important to build into the new macro is the concept of _stopping_
execution. i.e. even if you don't want to BUG, you really don't want
to operate on the busted data structure. This protection was precisely
what went missing with commit 924d9addb9b1.

-Kees

-- 
Kees Cook
Nexus Security
