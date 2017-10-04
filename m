MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1507157703-14972-2-git-send-email-alex.popov@linux.com>
References: <1507157703-14972-1-git-send-email-alex.popov@linux.com> <1507157703-14972-2-git-send-email-alex.popov@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 4 Oct 2017 16:31:20 -0700
Message-ID: <CAGXu5jL2S00knAwamhh8zOJ_Jb7Lc3hPsX=-e=hkts5YC7BevQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v4 1/3] gcc-plugins: Add STACKLEAK erasing the kernel
 stack at the end of syscalls
To: Alexander Popov <alex.popov@linux.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Tycho Andersen <tycho@docker.com>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andy Lutomirski <luto@amacapital.net>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 3:55 PM, Alexander Popov <alex.popov@linux.com> wrote:
> The STACKLEAK feature erases the kernel stack before returning from
> syscalls. That reduces the information which a kernel stack leak bug can
> reveal and blocks some uninitialized stack variable attacks. Moreover,
> STACKLEAK provides runtime checks for kernel stack overflow detection.
>
> This feature consists of:
>  - the architecture-specific code filling the used part of the kernel
>     stack with a poison value before returning to the userspace;
>  - the STACKLEAK gcc plugin. It instruments the kernel code inserting
>     the track_stack() call for tracking the lowest border of the kernel
>     stack and check_alloca() call for checking alloca size.
>
> The STACKLEAK feature is ported from grsecurity/PaX. More information at:
>   https://grsecurity.net/
>   https://pax.grsecurity.net/
>
> This code is modified from Brad Spengler/PaX Team's code in the last
> public patch of grsecurity/PaX based on our understanding of the code.
> Changes or omissions from the original code are ours and don't reflect
> the original grsecurity/PaX code.
>
> Signed-off-by: Alexander Popov <alex.popov@linux.com>

Thanks for the continuing work on this!

If I can get some review from Andy or other x86 folks, I'd appreciate
it. If they're happy, I'll add this to the gcc-plugins tree...

-Kees

-- 
Kees Cook
Pixel Security
