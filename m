Subject: Re: [PATCH v13 (resend) 2/6] x86/entry: Add STACKLEAK erasing the
 kernel stack at the end of syscalls
References: <1529686717-16017-1-git-send-email-alex.popov@linux.com>
 <1529686717-16017-3-git-send-email-alex.popov@linux.com>
 <20180705081236.GB20903@gmail.com>
 <45db2e83-5b87-0083-924f-f1ce7c89fe73@linux.com>
 <20180705222006.GA5410@gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <1c78f05f-dba1-d6e3-27cc-a482911a8b91@linux.com>
Date: Fri, 6 Jul 2018 14:46:10 +0300
MIME-Version: 1.0
In-Reply-To: <20180705222006.GA5410@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@kernel.org>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 06.07.2018 01:20, Ingo Molnar wrote:
> 
> * Alexander Popov <alex.popov@linux.com> wrote:
> 
>> Hello Ingo,
>>
>> Thanks for your review! I'll fix the style issues you pointed at.
>>
>> Please also see my answers below.
>>
>> On 05.07.2018 11:12, Ingo Molnar wrote:
>>>> +	  The tradeoff is the performance impact: on a single CPU system kernel
>>>> +	  compilation sees a 1% slowdown, other systems and workloads may vary
>>>> +	  and you are advised to test this feature on your expected workload
>>>> +	  before deploying it.
>>>
>>> Is there a way to patch this out runtime? I.e. if a distro enabled it, is there an 
>>> easy way to disable much of the overhead without rebooting the kernel?
>>
>> Hm. We can't completely disable STACKLEAK in runtime, since STACKLEAK gcc plugin
>> performs compile-time instrumentation of the kernel code. So we can only chop
>> off a part of functionality, for example, by introducing some variable and
>> checking it before every stack erasing (additional performance impact), but the
>> kernel will stay uselessly instrumented. It doesn't look reasonable to me.
> 
> Or we could use what every other performance critical instrumentation feature uses 
> to reduce overhead (ftrace, perf): kernel patching.

I see. It would be a big separate research - how to combine those different
kinds of instrumentation. I would propose to postpone it until we have a request
for STACKLEAK runtime disabling.

>>> If so then please make this:
>>>
>>> 	if (WARN_ON(boundary - kstack_ptr >= THREAD_SIZE))
>>> 		return;
>>>
>>> or so, to make it non-fatal and to allow users to report it, should it trigger 
>>> against all expectations.
>>
>> I've made an experiment. The results:
>>  1. BUG_ON() here doesn't freeze the kernel output - I see a full 'PANIC: double
>> fault' report;
> 
> Only in text mode - very few users are using text mode.
> 
>>  2. WARN_ON() here gives absolutely same 'PANIC: double fault' here.
> 
> that should only happen if the kernel is otherwise already fatally corrupted, 
> right?

No, I mean WARN_ON() in stackleak_erase_kstack() gives the double fault just
like BUG_ON() (without any corruption). In my experiment I've made the following
change:

-       BUG_ON(boundary - kstack_ptr >= THREAD_SIZE);
+//     BUG_ON(boundary - kstack_ptr >= THREAD_SIZE);
+       WARN_ON(1);

It might be caused by the fact, that stackleak_erase_kstack() is called from the
trampoline stack just before returning to the userspace.

So I mean 'WARN_ON() + return' here wouldn't give any profit over a single
BUG_ON() check.

Best regards,
Alexander
