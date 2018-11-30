Subject: Re: [PATCH 1/1] stackleak: Register the 'stackleak_cleanup' pass
 before the 'mach' pass
References: <1543583987-27948-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jJ7LmHRJJxtH2HD4XEu5hPLtAe=koJbaCmqF9qoSw=sVw@mail.gmail.com>
 <CAGXu5jKcRLcAg7r-E-9LMjK0YisLJp2TVYoiBwE+4ctYzi5wkg@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <4ba60677-4a69-755c-2507-13793830ccd5@linux.com>
Date: Sat, 1 Dec 2018 01:01:29 +0300
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKcRLcAg7r-E-9LMjK0YisLJp2TVYoiBwE+4ctYzi5wkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Jann Horn <jannh@google.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Masami Hiramatsu <mhiramat@kernel.org>, Florian Weimer <fweimer@redhat.com>, Richard Sandiford <richard.sandiford@arm.com>, Segher Boessenkool <segher@kernel.crashing.org>, amonakov@ispras.ru, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Emese Revfy <re.emese@gmail.com>, Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>, Alexei Starovoitov <ast@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, gcc@gcc.gnu.org, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 30.11.2018 20:12, Kees Cook wrote:
> On Fri, Nov 30, 2018 at 9:09 AM Kees Cook <keescook@chromium.org> wrote:
>>
>> On Fri, Nov 30, 2018 at 5:20 AM Alexander Popov <alex.popov@linux.com> wrote:
>>>
>>> Currently the 'stackleak_cleanup' pass deleting a CALL insn is executed
>>> after the 'reload' pass. That allows gcc to do some weird optimization in
>>> function prologues and epilogues, which are generated later [1].
>>>
>>> Let's avoid that by registering the 'stackleak_cleanup' pass before
>>> the 'mach' pass, which performs the machine dependent code transformations.
>>> It's the moment when the stack frame size is final and function prologues
>>> and epilogues are already generated.
>>>
>>> [1] https://www.openwall.com/lists/kernel-hardening/2018/11/23/2
>>>
>>> Reported-by: kbuild test robot <lkp@intel.com>
>>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>>
>> Thanks, applied!
> 
> Eek, no, this is breaking my build badly:
> 
> *** WARNING *** there are active plugins, do not report this as a bug
> unless you can reproduce it without enabling any plugins.
> Event                            | Plugins
> PLUGIN_START_UNIT                | stackleak_plugin
> kernel/exit.c: In function ‘release_task’:
> kernel/exit.c:228:1: internal compiler error: Segmentation fault
>  }
> 
> Failing with:
> 
> gcc (Ubuntu 7.3.0-16ubuntu3) 7.3.0

Nice... I don't reproduce it with gcc-7.3 built from source.
I'll investigate this, return with details and we'll decide what to do.

Thanks,
Alexander
