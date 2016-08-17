Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160817005509.GA6281@khazad-dum.debian.net>
References: <1471393229-27182-1-git-send-email-keescook@chromium.org> <20160817005509.GA6281@khazad-dum.debian.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 16 Aug 2016 20:37:26 -0700
Message-ID: <CAGXu5j+OaUKb0cc2mLm5hh2+Sdj0NryuvtwTuGeexp1C4FJk3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 0/5] bug: Provide toggle for BUG on data corruption
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Stephen Boyd <sboyd@codeaurora.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Tejun Heo <tj@kernel.org>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 16, 2016 at 5:55 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Tue, 16 Aug 2016, Kees Cook wrote:
>> This adds a CONFIG to trigger BUG()s when the kernel encounters
>> unexpected data structure integrity as currently detected with
>> CONFIG_DEBUG_LIST.
>>
>> Specifically list operations have been a target for widening flaws to gain
>> "write anywhere" primitives for attackers, so this also consolidates the
>> debug checking to avoid code and check duplication (e.g. RCU list debug
>> was missing a check that got added to regular list debug). It also stops
>> manipulations when corruption is detected, since worsening the corruption
>> makes no sense. (Really, everyone should build with CONFIG_DEBUG_LIST
>> since the checks are so inexpensive.)
>
> Well, maybe it wants a name that it looks like something that should be
> enabled by default on production kernels?
>
> I.e. CONFIG_DETECT_LIST_CORRUPTION or somesuch?

Yeah, that very well be true. I'd currently like to avoid CONFIG name
churn, but I've added it to my list of CONFIGs to rename (along with
CONFIG_DEBUG_RODATA). :)

-Kees

-- 
Kees Cook
Nexus Security
