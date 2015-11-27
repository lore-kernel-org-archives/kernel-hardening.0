Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151126163920.GA32190@chrystal.uk.oracle.com>
References: <CAGXu5j+Su3SC4gRmyXz2J1O7rY5eUe9-5KVGhCafy5iRZ4JnCA@mail.gmail.com>
	<20151125234542.GA10324@chrystal>
	<20151126163920.GA32190@chrystal.uk.oracle.com>
Date: Fri, 27 Nov 2015 12:09:31 -0800
Message-ID: <CAGXu5jL9-op32X2WFhbdahW8XHHLAdvT+pxULKU2nun5FN6ndg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: status: GRKERNSEC_KSTACKOVERFLOW
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 26, 2015 at 8:39 AM, Quentin Casasnovas
<quentin.casasnovas@oracle.com> wrote:
> On Thu, Nov 26, 2015 at 12:45:42AM +0100, Quentin Casasnovas wrote:
>> On Tue, Nov 24, 2015 at 11:10:09AM -0800, Kees Cook wrote:
>>
>> [snip/]
>>
>> It should also be noted that I did not find that the struct thread_info
>> (which is stuffed at the end of the stack) was protected in any way either.
>> So even if a write/read _below_ the stack could still be trapped if nothing
>> is currently mapped there, it looks like deep stack usage could still
>> overflow it and go unoticed.  Here again, I didn't spend a lot of time on
>> this and it might just be that I'm missing something.
>>
>> In the very unlikely event where I didn't miss anything and the struct
>> thread_info can still be overflown and there isn't any guard page, maybe we
>> can improve on the current KSTACK_OVERFLOW feature by putting the struct
>> thread_info on a different page than the kernel stack, and not vmap() it
>> like the rest of the stack pages, but instead map a PROT_NONE page there.
>> That would mean the struct thread_info can still be accessed by using its
>> lowmem mapping (i.e. legit usage from the kernel) but not by deep kernel
>> stack usage.  Maybe the cost of adding an extra page per kernel stack is
>> too high though.
>
> As expected I missed some other changes:
>
> /* Load thread_info address into "reg" */
> #define GET_THREAD_INFO(reg) \
> -       _ASM_MOV PER_CPU_VAR(cpu_current_top_of_stack),reg ; \
> -       _ASM_SUB $(THREAD_SIZE),reg ;
> +       _ASM_MOV PER_CPU_VAR(current_tinfo),reg ;
>
> and
>
> +DECLARE_PER_CPU(struct thread_info *, current_tinfo);
> +
> static inline struct thread_info *current_thread_info(void)
> {
> -       return (struct thread_info *)(current_top_of_stack() - THREAD_SIZE);
> +       return this_cpu_read_stable(current_tinfo);
> }
>
> So no more thread_info on the stack in the default configuration, which
> isn't correlated with the KSTACKOVERFLOW config option.

Good find! This seems like it should be its own patch, distinct from
KSTACKOVERFLOW?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
