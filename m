Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 15 Apr 2016 09:29:40 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160415072940.GB30715@gmail.com>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
 <1460672954-32567-2-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1460672954-32567-2-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v5 01/21] x86, KASLR: Remove unneeded boot_params argument
To: Kees Cook <keescook@chromium.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> From: Yinghai Lu <yinghai@kernel.org>
> 
> Since the boot_params can be found using the real_mode global variable, there is 
> no need to pass around a pointer to it. This slightly simplifies the 
> choose_kernel_location function and its callers.

Yeah, so I really wanted to apply this series because the changelogs are now very 
nice, but got held up by the very first patch again ...

Guys, 'real_mode' totally sucks as a variable name!

By removing a seemingly unnecessary parameter, you made the code actively worse to 
read...

So please make a second patch on top of this one that renames 'real_mode' to 
something that both displays what it is about (it sure isn't mainly about real 
mode only!!), and also expresses that it's a global variable, not some local 
function parameter.

In arch/x86/ we usually achieve that via prefixing it with x86_ or so. So 
something like 'x86_boot_params' would work for me. I realize that this is 
somewhat special, because this is pre-relocation code so we really have to be 
careful about pointers - so maybe name it x86_boot_params_rm or so.

Also, I had a look at the whole file you are patching, 
arch/x86/boot/compressed/misc.c, and for heaven's sake, please first improve the 
comments on top of that file before further complicating that code with KASLR 
details! Right now it consists of various low level ramblings choke full of typos. 
No mention of where KASLR fits into the picture at all!

Right now it says:

 * misc.c
 *
 * This is a collection of several routines from gzip-1.0.3
 * adapted for Linux.

Which was perhaps true 15 years ago, but sure it's not true today! We do 
relocation and KASLR processing in this path as well, which is just as important 
as running the decompressor. Also, gzip is not the only decompressor we support.

The high level purpose of the code in this file should be explained first, and the 
file should probably be renamed to something like extract.c - to signal that this 
file is about extracting a kernel image and preparing it for execution (i.e. 
relinking it, etc.). It's (much!) more than just pure decompression.

Likewise, decompress_kernel() should be renamed to extract_kernel().

The low level explanations in extract.c should be moved to the function that is 
affected by those details. The top of the file should only contain general 
explanations, a high level description of in what state the kernel is when we call 
this code, and the sort of stuff we do in that code.

The credits should be collected into a single, coherent block. Unnecessary fluff 
should be cut.

Furthermore, I see similar problems with arch/x86/boot/compressed/aslr.c: for 
example it has no high level description at the top of the file _at all_. WTF is 
this with writing security-sensitive code that has no high level design 
description whatsoever?? Also, why is it named aslr.c, why not kaslr.c? We do have 
both KASLR and ASLR code in the kernel, confusing naming on the source code level 
sure does not help.

Also, what's this thing about choose_kernel_location()? That name is actively 
hiding the fact that the main purpose of that function is to randomize things ... 

It should be named x86_randomize_kernel_address() or so.

We need to stop making a mess of the x86 boot code! This is a highly critical 
piece of kernel code that every single x86 Linux user will execute, we should 
improve its visual presentation and general readability to the level of being 
proud of it ...

Thanks,

	Ingo
