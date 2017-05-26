MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1495829844-69341-20-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org> <1495829844-69341-20-git-send-email-keescook@chromium.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 May 2017 13:23:49 -0700
Message-ID: <CA+55aFzQA+W_t1-7UaQtiEY3MJQ0cRP0r3AJi5qOum_9zb_3sA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 19/20] [RFC] task_struct: Allow randomized layout
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 26, 2017 at 1:17 PM, Kees Cook <keescook@chromium.org> wrote:
> This marks most of the layout of task_struct as randomizable, but leaves
> thread_info and scheduler state untouched at the start, and thread_struct
> untouched at the end.

I think you want to abstract this out somehow, because this is both
ugly and bad:

> +       /* This begins the randomizable portion of task_struct... */
> +#if GCC_VERSION >= 40600
> +       struct {
> +#endif

when you could instead just introduce something like

#if GCC_VERSION >= 40600
  #define randomized_struct_fields_start struct {
  #define randomized_struct_fields_end } __randomize_layout;
#else
  #define randomized_struct_fields_start
  #define randomized_struct_fields_end
#endif

and then this pattern is
 (a) more-or-less self-documenting
 (b) usable in other places too.
 (c) maybe some future compiler wants that struct field to have some
"randomize-me attribute" or something

Hmm?
