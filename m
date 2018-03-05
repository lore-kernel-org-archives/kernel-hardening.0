Subject: Re: [PATCH RFC v9 4/7] x86/entry: Erase kernel stack in
 syscall_trace_enter()
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <1520107232-14111-5-git-send-email-alex.popov@linux.com>
 <b52a2cca-cb5c-d47f-131e-7db297f78958@linux.intel.com>
 <CAGXu5jLRpJ7ktij4TpaSG-RZLOou=RWyY_=jTMNE87+E4Xp2Ag@mail.gmail.com>
 <CA+55aFxEAYyrUkApo-dtZvxcYbvWBZJpUytjbm7e2wruTvbYjQ@mail.gmail.com>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <abc02704-304e-2604-6297-75e6d2757c1e@linux.com>
Date: Tue, 6 Mar 2018 00:02:49 +0300
MIME-Version: 1.0
In-Reply-To: <CA+55aFxEAYyrUkApo-dtZvxcYbvWBZJpUytjbm7e2wruTvbYjQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hello Linus,

Thanks for your reply (despite some strong words).

On 05.03.2018 23:15, Linus Torvalds wrote:
> This is the first I see of any of this, it was apparently not actually
> posted to lkml or anything like that.

I described that below.

> Honestly, what I see just makes me go "this is security-masturbation".

Let me quote the cover letter of this patch series.

STACKLEAK (initially developed by PaX Team):
 - reduces the information that can be revealed through kernel stack leak bugs;
 - blocks some uninitialized stack variable attacks (e.g. CVE-2017-17712,
CVE-2010-2963);
 - introduces some runtime checks for kernel stack overflow detection. It blocks
the Stack Clash attack against the kernel.

So it seems to be a useful feature.

> It doesn't actually seem to help *find* bugs at all. As such, it's
> another "paper over and forget" thing that just adds fairly high
> overhead when it's enabled.

The cover letter also contains the information about the performance impact.
It's 0.6% on the compiling the kernel (with Ubuntu config) and approx 4% on a
very intensive hackbench test.

> I'm NAK'ing it sight-unseen (see above) just because I'm tired of
> these kinds of pointless things that don't actually strive to improve
> on the kernel, just add more and more overhead for nebulous "things
> may happen", and that just make the code uglier.
> 
> Why wasn't it even posted to lkml?

That's my mistake. I started to learn that feature 9 month ago, just before
Qualys published the Stack Clash attack (which is blocked by STACKLEAK). I sent
first WIP versions to a short list of people (and had a lot of feedback to work
with). But later unfortunately I didn't adjust the list of recipients.

That was not done intentionally.

> And why isn't the focus of security people on tools to _analyse_ and
> find problems?

You know, I like KASAN and kernel fuzzing as well:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=82f2341c94d270421f383641b7cd670e474db56b

Best regards,
Alexander
