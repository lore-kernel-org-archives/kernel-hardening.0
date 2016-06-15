Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrWMh0+_RKV1OwwqE6s8P=fLFUYcAxvSNwDK_qB6BOBs9w@mail.gmail.com>
References: <CALCETrWMh0+_RKV1OwwqE6s8P=fLFUYcAxvSNwDK_qB6BOBs9w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 15 Jun 2016 10:05:49 -0700
Message-ID: <CAGXu5jJ64qCGuMCt+hTpwiVT+pu76b+g8QA=vtVgEv=a4ca9mQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Playing with virtually mapped stacks (with guard pages!)
To: Andy Lutomirski <luto@amacapital.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 14, 2016 at 11:01 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> Hi all-
>
> If you want to play with virtually mapped stacks, I have it more or
> less working on x86 in a branch here:
>
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/vmap_stack
>
> The core bit (virtually map the stack and fix the accounting) is just
> a config option, but it needs the arch to opt-in.  I suspect that
> every arch will have its own set of silly issues to address to make it
> work well.  For x86, the silly issues are getting the OOPS to work
> right and handling some vmalloc_fault oddities to avoid panicing at
> random.

Awesome! Some notes/questions:

- there are a number of typos in commit messages and comments, just FYI

- where is the guard page added? I don't see anything leaving a hole at the end?

- where is thread_info? I understand there to be two benefits from
vmalloc stack: 1) thread_info can live elsewhere, 2) guard page can
exist easily

- this seems like it should Oops not warn:
WARN_ON_ONCE(vm->nr_pages != THREAD_SIZE / PAGE_SIZE);
that being wrong seems like a very bad state to continue from

- bikeshed: I think the CONFIG should live in arch/Kconfig (with a
description of what an arch needs to support for it) and be called
HAVE_ARCH_VMAP_STACK so that archs can select it instead of having
multiple definitions of CONFIG_VMAP_STACK in each arch.

Thanks for digging into this!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
