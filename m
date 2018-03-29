Subject: Re: [PATCH RFC v10 2/6] x86/entry: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
References: <1522267032-6603-1-git-send-email-alex.popov@linux.com>
 <1522267032-6603-3-git-send-email-alex.popov@linux.com>
 <alpine.DEB.2.10.1803291137150.27913@vshiva-Udesk>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <bd2c220b-f449-afbb-0b00-a868c8b33afe@linux.com>
Date: Fri, 30 Mar 2018 00:34:21 +0300
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1803291137150.27913@vshiva-Udesk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Shivappa Vikas <vikas.shivappa@linux.intel.com>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 29.03.2018 21:38, Shivappa Vikas wrote:
> On Wed, 28 Mar 2018, Alexander Popov wrote:
> 
>> +	const unsigned long check_depth = STACKLEAK_POISON_CHECK_DEPTH /
>> +							sizeof(unsigned long);
>> +
>> +	/*
>> +	 * Let's search for the poison value in the stack.
>> +	 * Start from the lowest_stack and go to the bottom.
>> +	 */
>> +	while (p > boundary && poison <= check_depth) {
>> +		if (*(unsigned long *)p == STACKLEAK_POISON)
>> +			poison++;
>> +		else
>> +			poison = 0;
>> +
>> +		p -= sizeof(unsigned long);
>> +	}
>> +
>> +	/*
>> +	 * One long int at the bottom of the thread stack is reserved and
>> +	 * should not be poisoned (see CONFIG_SCHED_STACK_END_CHECK).
>> +	 */
>> +	if (p == boundary)
>> +		p += sizeof(unsigned long);
>> +
>> +	/*
>> +	 * So let's write the poison value to the kernel stack.
>> +	 * Start from the address in p and move up till the new boundary.
>> +	 */
>> +	if (on_thread_stack())
>> +		boundary = current_stack_pointer;
>> +	else
>> +		boundary = current_top_of_stack();
>> +
>> +	BUG_ON(boundary - p >= THREAD_SIZE);
>> +
>> +	while (p < boundary) {
>> +		*(unsigned long *)p = STACKLEAK_POISON;
>> +		p += sizeof(unsigned long);
>> +	}
> 
> Sorry catching up late on this. 

Hello Vikas,

You are just in time! Thank you for looking at the code.

> can we use a stosq or something here ? wondering 
> if that helps get more performance. since you seem to copy the whole stack with 
> the poison value. If that was already discussed sorry for the spam :)

Yes, the previous version of the patch series had this function written in
assembly. It used scasq for the poison searching and then stosq for writing:
http://www.openwall.com/lists/kernel-hardening/2018/03/03/9

That amount of assembly was blamed by the maintainers. So I've done my best to
rework it in C bypassing the pitfalls:
http://www.openwall.com/lists/kernel-hardening/2018/03/21/4

In fact, this implementation is not much slower than the assembly one, since we
erase only the used part of the thread stack. This is achieved by the
lowest_stack variable, which is updated during the syscall (please see the next
patch of the series).

Best regards,
Alexander
