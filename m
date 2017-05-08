MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170508225308.a6uznrhdm7pgyhcg@treble>
References: <1494271972-140319-1-git-send-email-keescook@chromium.org>
 <1494271972-140319-3-git-send-email-keescook@chromium.org> <20170508225308.a6uznrhdm7pgyhcg@treble>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 8 May 2017 16:31:11 -0700
Message-ID: <CAGXu5j+J=o7hHceQn6pFtCmQcfUtSrtZ9uP8fLo0gkDWNdetAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 2/2] x86/refcount: Implement fast refcount overflow protection
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, PaX Team <pageexec@freemail.hu>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>, "x86@kernel.org" <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 8, 2017 at 3:53 PM, Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> On Mon, May 08, 2017 at 12:32:52PM -0700, Kees Cook wrote:
>> +#define REFCOUNT_EXCEPTION                           \
>> +     "movl $0x7fffffff, %[counter]\n\t"              \
>> +     "int $"__stringify(X86_REFCOUNT_VECTOR)"\n"     \
>> +     "0:\n\t"                                        \
>> +     _ASM_EXTABLE(0b, 0b)
>
> Despite the objtool warnings going away, this still uses the exception
> table in a new way, which will confuse objtool.  I need to do some more
> thinking about the best way to fix it, either as a change to your patch
> or a change to objtool.

In that it's not a "true" exception?

>> diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
>> index 532372c6cf15..0590f384f234 100644
>> --- a/include/asm-generic/sections.h
>> +++ b/include/asm-generic/sections.h
>> @@ -20,6 +20,8 @@
>>   *                   may be out of this range on some architectures.
>>   * [_sinittext, _einittext]: contains .init.text.* sections
>>   * [__bss_start, __bss_stop]: contains BSS sections
>> + * [__refcount_overflow/underflow_start, ..._end]: contains .text sections
>> + *                for refcount error handling.
>>   *
>>   * Following global variables are optional and may be unavailable on some
>>   * architectures and/or kernel configurations.
>> @@ -39,6 +41,8 @@ extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
>>  extern char __kprobes_text_start[], __kprobes_text_end[];
>>  extern char __entry_text_start[], __entry_text_end[];
>>  extern char __start_rodata[], __end_rodata[];
>> +extern char __refcount_overflow_start[], __refcount_overflow_end[];
>> +extern char __refcount_underflow_start[], __refcount_underflow_end[];
>
> I think this part is no longer needed, since you got rid of the new
> sections?

Oh whoops, thanks. I thought I'd removed those, but clearly I didn't. :) Thanks!

-Kees

-- 
Kees Cook
Pixel Security
