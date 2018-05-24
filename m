Subject: Re: [PATCH v12 2/6] x86/entry: Add STACKLEAK erasing the kernel stack
 at the end of syscalls
References: <1526488097-20611-1-git-send-email-alex.popov@linux.com>
 <1526488097-20611-3-git-send-email-alex.popov@linux.com>
 <20180518065349.GA10080@gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <24c5699b-d222-486b-6f16-7539e931c436@linux.com>
Date: Thu, 24 May 2018 16:05:27 +0300
MIME-Version: 1.0
In-Reply-To: <20180518065349.GA10080@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Florian Weimer <fweimer@redhat.com>, Boris Lukashev <blukashev@sempervictus.com>, Andrey Konovalov <andreyknvl@google.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 18.05.2018 09:53, Ingo Molnar wrote:
> * Alexander Popov <alex.popov@linux.com> wrote:
>> +	if (on_thread_stack())
>> +		boundary = current_stack_pointer;
>> +	else
>> +		boundary = current_top_of_stack();
>> +
>> +	BUG_ON(boundary - p >= THREAD_SIZE);
> 
> Please make this:
> 
> 	if ( WARN_ON_ONCE())
> 		return;
> 
> ... or so, so that if this code is buggy we get actual useful user reports, not 
> just "my machine froze, help!"...

I've just double-checked that BUG() in erase_kstack() works fine when it's
called from the trampoline stack and thread stack.

But this "WARN_ON_ONCE() + return" logic would introduce an undesirable effect:
modifying 'lowest_stack' value would allow to silently skip stack erasing.

Best regards,
Alexander
