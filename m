Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1471393569.4075.187.camel@perches.com>
References: <1471393229-27182-1-git-send-email-keescook@chromium.org>
 <1471393229-27182-5-git-send-email-keescook@chromium.org> <1471393569.4075.187.camel@perches.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 16 Aug 2016 20:39:07 -0700
Message-ID: <CAGXu5jKvNGG+SmHe7zGS7F=2K7RShSV6+U6Yot4zHoPZz4aqdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 4/5] bug: Provide toggle for BUG on data corruption
To: Joe Perches <joe@perches.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Stephen Boyd <sboyd@codeaurora.org>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Tejun Heo <tj@kernel.org>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 16, 2016 at 5:26 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2016-08-16 at 17:20 -0700, Kees Cook wrote:
>> The kernel checks for cases of data structure corruption under some
>> CONFIGs (e.g. CONFIG_DEBUG_LIST). When corruption is detected, some
>> systems may want to BUG() immediately instead of letting the system run
>> with known corruption.  Usually these kinds of manipulation primitives can
>> be used by security flaws to gain arbitrary memory write control. This
>> provides a new config CONFIG_BUG_ON_DATA_CORRUPTION and a corresponding
>> macro CHECK_DATA_CORRUPTION for handling these situations. Notably, even
>> if not BUGing, the kernel should not continue processing the corrupted
>> structure.
> []
>> diff --git a/include/linux/bug.h b/include/linux/bug.h
> []
>> @@ -118,4 +118,21 @@ static inline enum bug_trap_type report_bug(unsigned long bug_addr,
>>  }
>>
>>  #endif       /* CONFIG_GENERIC_BUG */
>> +
>> +/*
>> + * Since detected data corruption should stop operation on the affected
>> + * structures, this returns false if the corruption condition is found.
>> + */
>> +#define CHECK_DATA_CORRUPTION(condition, format...)                   \
>
> My preference would be to use (condition, fmt, ...)
>
>> +     do {                                                             \
>> +             if (unlikely(condition)) {                               \
>> +                     if (IS_ENABLED(CONFIG_BUG_ON_DATA_CORRUPTION)) { \
>> +                             printk(KERN_ERR format);                 \
>
> and
>                                 pr_err(fmt, ##__VA_ARGS__);
>
> so that any use would also get any local pr_fmt applied as well.
>
>> +                             BUG();                                   \
>> +                     } else                                           \
>> +                             WARN(1, format);                         \
>> +                     return false;                                    \
>> +             }                                                        \
>> +     } while (0)
>> +
>>  #endif       /* _LINUX_BUG_H */
>

Ah yes, excellent point. I'll convert this for my v3. Thanks!

-Kees

-- 
Kees Cook
Nexus Security
