MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <39c52c1d-dba5-07f6-0838-2e8b368b40ed@linux.intel.com>
References: <1520107232-14111-1-git-send-email-alex.popov@linux.com>
 <CAGXu5jKvTUkU5qLf+j9aB8G2xqKm7n3QLPBXaGnk_ewhG6=i_g@mail.gmail.com> <39c52c1d-dba5-07f6-0838-2e8b368b40ed@linux.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 5 Mar 2018 12:02:53 -0800
Message-ID: <CAGXu5jK6REx=zhBVomt443pvW_BkyFjCjUnWjn0gu22ZG6fPeA@mail.gmail.com>
Subject: Re: [PATCH RFC v9 0/7] Introduce the STACKLEAK feature and a test for it
Content-Type: text/plain; charset="UTF-8"
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Alexander Popov <alex.popov@linux.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Ingo Molnar <mingo@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Richard Sandiford <richard.sandiford@arm.com>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, "Dmitry V . Levin" <ldv@altlinux.org>, Emese Revfy <re.emese@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Andrey Ryabinin <aryabinin@virtuozzo.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Thomas Garnier <thgarnie@google.com>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Josef Bacik <jbacik@fb.com>, Masami Hiramatsu <mhiramat@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "David S . Miller" <davem@davemloft.net>, Ding Tianhong <dingtianhong@huawei.com>, David Woodhouse <dwmw@amazon.co.uk>, Josh Poimboeuf <jpoimboe@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Juergen Gross <jgross@suse.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, Mathias Krause <minipli@googlemail.com>, Vikas Shivappa <vikas.shivappa@linux.intel.com>, Kyle Huey <me@kylehuey.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 5, 2018 at 11:42 AM, Dave Hansen
<dave.hansen@linux.intel.com> wrote:
> On 03/05/2018 11:34 AM, Kees Cook wrote:
>> Boris, Andy, and Dave (Hansen), you've all looked at this; would you
>> be willing to give an Ack on the x86 parts? (Though I do now see a new
>> comment from Dave was just sent.) And if not, what changes would you
>> like to see?
>
> I think it could definitely use another cleanup and de-#ifdef'ing pass.
> It seems to have inherited the style from the original code and it's a
> bit more than we're used to in mainline.

There are a few places it could be minimized, that's true. It looked
like it might not be worth it, but the places I see are:

include/linux/compiler.h:
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+/* Poison value points to the unused hole in the virtual memory map */
+# define STACKLEAK_POISON -0xBEEF
+# define STACKLEAK_POISON_CHECK_DEPTH 128
+#endif

This doesn't need an #ifdef wrapper...


arch/x86/kernel/process_64.c and arch/x86/kernel/process_32.c:
+#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
+       p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
+                                               2 * sizeof(unsigned long);
+#endif

This could be made into a helper function, maybe, in processor.h? Like:

#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
# define record_lowest_stack(p) do { \
        p->thread.lowest_stack = (unsigned long)task_stack_page(p) +
                                                  2 * sizeof(unsigned long);
    } while (0)
#else
# define save_lowest_stack(p) do { } while (0)
#endif

And the uses in process_*.c would be:

    save_lowest_stack(p);

?


And "fs/proc: Show STACKLEAK metrics in the /proc file system" could
maybe be adjusted too?

It doesn't seem like a lot of savings, but what do you think?

One new thing did pop out at me in this review, track_stack() likely
shouldn't live in fs/exec.c. It has nothing to do with exec(). There
aren't a lot of good places, but maybe a better place would be
mm/util.c. (A whole new source file seems like overkill.)

-Kees

-- 
Kees Cook
Pixel Security
