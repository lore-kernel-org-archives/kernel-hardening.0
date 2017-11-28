MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1511826058-2563-2-git-send-email-me@tobin.cc>
References: <1511826058-2563-1-git-send-email-me@tobin.cc> <1511826058-2563-2-git-send-email-me@tobin.cc>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Nov 2017 16:46:35 -0800
Message-ID: <CAGXu5jKurtT0ipe6V6_+9OSWQ0R=DiXz6Wxp+Bb=kjxhUxVamg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 1/5] docs: correct documentation for %pK
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 27, 2017 at 3:40 PM, Tobin C. Harding <me@tobin.cc> wrote:
> Current documentation indicates that %pK prints a leading '0x'. This is
> not the case.
>
> Correct documentation for printk specifier %pK.

Yup, quite true. :)

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

>
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  Documentation/printk-formats.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> index 361789df51ec..b4fe3c5f3b44 100644
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -91,7 +91,7 @@ Kernel Pointers
>
>  ::
>
> -       %pK     0x01234567 or 0x0123456789abcdef
> +       %pK     01234567 or 0123456789abcdef
>
>  For printing kernel pointers which should be hidden from unprivileged
>  users. The behaviour of ``%pK`` depends on the ``kptr_restrict sysctl`` - see
> --
> 2.7.4
>



-- 
Kees Cook
Pixel Security
