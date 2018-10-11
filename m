MIME-Version: 1.0
In-Reply-To: <CALS6=qUf52a877nH414P0T2B7_9=A6FvqBLc24a-5duX0KrtSQ@mail.gmail.com>
References: <CALS6=qXmb0sXPbaSS-9ftRidxNSCck-NMxQWpA9AfCWFhwXKwg@mail.gmail.com>
 <CALS6=qUf52a877nH414P0T2B7_9=A6FvqBLc24a-5duX0KrtSQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 11 Oct 2018 09:59:16 -0700
Message-ID: <CAGXu5j+kx_QE8fN0QjCLh-EwObTKfh9xt4BxBA0mF40oygcvqQ@mail.gmail.com>
Subject: Re: link time analysis for the kernel.
Content-Type: text/plain; charset="UTF-8"
To: Carter Cheng <cartercheng@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 11, 2018 at 9:38 AM, Carter Cheng <cartercheng@gmail.com> wrote:
> There are some detaills about the current procedures for linking the kernel
> that I am unfamiliar with. My understanding is that GCC and Clang both have
> the ability to do link time analysis and transforms on code but is it
> possible to write link time passes that will run on the kernel since the
> linking phase is a bit different (i.e. doesnt produce an ELF file)?

I think you'd need to build with LTO for this to work. I'm not sure
what the state of gcc and LTO against the kernel is right now, but it
works under Clang[0] with some patches[1].

For gcc, once you get LTO working, I assume you'd want to write a
linker plugin[2].

>
> Are there other tools that are used for the purpose of analysing the kernel
> and patching it? I have encountered a tool called Coccinelle but I am
> uncertain if CTL can be used to simulate the analysis I would need for
> adding and eliding runtime checks on various pointer operations.

Coccinelle isn't a linker, but rather a static analysis and semantic
patching tool. It's possible it might be able to do what you need,
though. What are you working on, specifically?

> I assume from previous discussions that the gcc would be best since clang
> still doesn't correctly compile the kernel without patches.

Building the kernel for arm64 works well with Clang. Doing x86 builds
requires a little more work, but that should be solved soon only
asm-goto support lands (it's under development now...)

-Kees

[0] https://llvm.org/docs/LinkTimeOptimization.html
[1] https://android-review.googlesource.com/q/topic:android-4.14-lto
[2] https://www.cleancss.com/explain-command/gcc/79600

-- 
Kees Cook
Pixel Security
