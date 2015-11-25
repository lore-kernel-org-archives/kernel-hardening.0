Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrXNe5Ow0cxLACzVpx3HdR_b_XCB3_VUtsAphVjCQpRZwA@mail.gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
	<1448401114-24650-2-git-send-email-keescook@chromium.org>
	<CALCETrXNe5Ow0cxLACzVpx3HdR_b_XCB3_VUtsAphVjCQpRZwA@mail.gmail.com>
Date: Tue, 24 Nov 2015 16:44:07 -0800
Message-ID: <CAGXu5jKe5hZtrUJ7SJ2WTcJvKXftgkAkPjxmvoVjewbC3Kqg9Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 1/2] x86: introduce post-init read-only memory
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-arch <linux-arch@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 24, 2015 at 4:34 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Nov 24, 2015 1:38 PM, "Kees Cook" <keescook@chromium.org> wrote:
>>
>> One of the easiest ways to protect the kernel from attack is to reduce
>> the internal attack surface exposed when a "write" flaw is available. By
>> making as much of the kernel read-only as possible, we reduce the
>> attack surface.
>>
>> Many things are written to only during __init, and never changed
>> again. These cannot be made "const" since the compiler will do the wrong
>> thing (we do actually need to write to them). Instead, move these items
>> into a memory region that will be made read-only during mark_rodata_ro()
>> which happens after all kernel __init code has finished.
>>
>> This introduces __read_only as a way to mark such memory, and adds some
>> documentation about the existing __read_mostly marking.
>
> Obligatory bikeshed:  __ro_after_init, please.  It's barely longer,
> and it directly explains what's going on.  __read_only makes me think
> that it's really read-only and could, for example, actually be in ROM.

I'm fine with that. Anyone else want to chime in before I send a v2?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
