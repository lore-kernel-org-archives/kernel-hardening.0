MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFzQA+W_t1-7UaQtiEY3MJQ0cRP0r3AJi5qOum_9zb_3sA@mail.gmail.com>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-20-git-send-email-keescook@chromium.org> <CA+55aFzQA+W_t1-7UaQtiEY3MJQ0cRP0r3AJi5qOum_9zb_3sA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:32:26 -0700
Message-ID: <CAGXu5jJTrWzeLJkCELe0qNfMsoYfHbwL9sx-kBMm+4L8BatB7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 19/20] [RFC] task_struct: Allow randomized layout
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 26, 2017 at 1:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, May 26, 2017 at 1:17 PM, Kees Cook <keescook@chromium.org> wrote:
>> This marks most of the layout of task_struct as randomizable, but leaves
>> thread_info and scheduler state untouched at the start, and thread_struct
>> untouched at the end.
>
> I think you want to abstract this out somehow, because this is both
> ugly and bad:
>
>> +       /* This begins the randomizable portion of task_struct... */
>> +#if GCC_VERSION >= 40600
>> +       struct {
>> +#endif
>
> when you could instead just introduce something like
>
> #if GCC_VERSION >= 40600
>   #define randomized_struct_fields_start struct {
>   #define randomized_struct_fields_end } __randomize_layout;
> #else
>   #define randomized_struct_fields_start
>   #define randomized_struct_fields_end
> #endif
>
> and then this pattern is
>  (a) more-or-less self-documenting
>  (b) usable in other places too.
>  (c) maybe some future compiler wants that struct field to have some
> "randomize-me attribute" or something
>
> Hmm?

There were so many options and they all seems weird for various
reason. :) I'll use your idea, it looks much cleaner, thanks!

-Kees

-- 
Kees Cook
Pixel Security
