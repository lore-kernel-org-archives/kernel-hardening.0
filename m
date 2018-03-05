MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <b6abd009-8f64-c5a2-6496-6affb31ad75e@linux.com>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-3-git-send-email-alex.popov@linux.com> <d968e58a-3abd-8e3c-cee3-00c19c1b6430@linux.intel.com>
 <94f268b2-31a4-620a-86ed-325d5bb33c57@redhat.com> <20180305202535.GX25201@hirez.programming.kicks-ass.net>
 <b6abd009-8f64-c5a2-6496-6affb31ad75e@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 5 Mar 2018 13:36:01 -0800
Message-ID: <CAGXu5jKNsp4WKUJQZ81NWciOGYBGAdVhiSQy9Qa-JAY84LiwmQ@mail.gmail.com>
Subject: Re: [PATCH RFC v9 2/7] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
Content-Type: text/plain; charset="UTF-8"
To: Alexander Popov <alex.popov@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Laura Abbott <labbott@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 5, 2018 at 1:21 PM, Alexander Popov <alex.popov@linux.com> wrote:
> On 05.03.2018 23:25, Peter Zijlstra wrote:
>> On Mon, Mar 05, 2018 at 11:43:19AM -0800, Laura Abbott wrote:
>>> On 03/05/2018 08:41 AM, Dave Hansen wrote:
>>>> On 03/03/2018 12:00 PM, Alexander Popov wrote:
>>>>>   Documentation/x86/x86_64/mm.txt  |   2 +
>>>>>   arch/Kconfig                     |  27 ++++++++++
>>>>>   arch/x86/Kconfig                 |   1 +
>>>>>   arch/x86/entry/entry_32.S        |  88 +++++++++++++++++++++++++++++++
>>>>>   arch/x86/entry/entry_64.S        | 108 +++++++++++++++++++++++++++++++++++++++
>>>>>   arch/x86/entry/entry_64_compat.S |  11 ++++
>>>>
>>>> This is a *lot* of assembly.  I wonder if you tried at all to get more
>>>> of this into C or whether you just inherited the assembly from the
>>>> original code?
>>>>
>>>
>>> This came up previously http://www.openwall.com/lists/kernel-hardening/2017/10/23/5
>>> there were concerns about trusting C to do the right thing as well as
>>> speed.
>>
>> And therefore the answer to this obvious question should've been part of
>> the Changelog :-)
>>
>> Dave is last in a long line of people asking this same question.
>
> Yes, actually the changelog in the cover letter contains that:
>
>   After some experiments, kept the asm implementation of erase_kstack(),
>   because it gives a full control over the stack for clearing it neatly
>   and doesn't offend KASAN.
>
> Moreover, later erase_kstack() on x86_64 became different from one on x86_32.

Maybe explicitly mention the C experiments in future change log?

-Kees

-- 
Kees Cook
Pixel Security
