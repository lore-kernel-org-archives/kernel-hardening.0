Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1476260846.19479.5.camel@cvidal.org>
References: <1476016472.2329.38.camel@cvidal.org> <CAGXu5jK9ZNr+AbVxfAns7PGEiw9NQ5zOp_EG_9dG7i+oeYwyCg@mail.gmail.com>
 <1476260846.19479.5.camel@cvidal.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 12 Oct 2016 15:40:55 -0700
Message-ID: <CAGXu5jK+80C8FM__Z4nY64VsN4Y+RNGt1OVGonLjQW_T8mTf=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] self introduction
To: Colin Vidal <colin@cvidal.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 12, 2016 at 1:27 AM, Colin Vidal <colin@cvidal.org> wrote:
>> I see there's already a thread getting into the HARDENED_ATOMIC
>> effort, though I thought I might bring up some other areas too, in
>> case they entice you as well. You've got some background in control
>> flow -- have you spent much time in compiler internals? The recent
>
> Not really on mainstream compilers. I've done some static inter/intra
> procedural analysis on previous projects (in order to optimize object
> call site), and the compiler of the DSL I'm working on is based on a
> completely different theories (it uses Esterel synchronous language
> semantic) and does not uses static CFG. Hence, I am quite far of CFI
> analysis :(

Heh, okay, no worries. I just thought I'd ask. I saw some key words in
your introduction. ;)

>> addition of the gcc plugin infrastructure means there's a much wider
>> ability for the kernel to do compiler tricks now. Two things that
>> come to mind for CFI when looking at the existing PaX/Grsecurity gcc
>> plugins are the kernexec plugin (which, AIUI, is mainly a weak form
>> of SMEP emulation on x86, using simple CFI to keep the high bit set
>> on all kernel function calls) which I think would be easy to extract
>> as a stand-alone plugin:
>>
>> https://github.com/linux-scraping/linux-grsecurity/blob/grsec-test/sc
>> ripts/gcc-plugins/kernexec_plugin.c
>
> If I understand, this plugin protects against running user-space code
> in supervisor mode (SMEP emulation, so avoid ROP class exploit), but
> since this analysis is purely static, it does not protects again
> out-of-tree dynamically loaded modules, right?

I can't tell which of two questions you're asking, so I'll answer both. :)

The gcc plugin infrastructure in the kernel is designed so that any
kernel modules built for the kernel will get the plugin run on it. The
kernexec plugin in particular, however, has logic to handle totally
out-of-tree builds that lack the instrumentation (see the Kconfig for
it). In that case, that module would not be protected, but the rest of
the kernel would be.

And, allowing arbitrary module loading on a system would nullify
virtually all kernel self-protection efforts when defending against
the root user, so it's an assumed that systems that are serious about
system security are either built monolithic (without modules) or
perform some kind of module verification (module signing, or LoadPin
with dm-verity).

-Kees

-- 
Kees Cook
Nexus Security
