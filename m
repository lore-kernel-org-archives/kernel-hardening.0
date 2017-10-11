MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1507693696-3777-1-git-send-email-me@tobin.cc>
References: <1507693696-3777-1-git-send-email-me@tobin.cc>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 11 Oct 2017 09:49:56 -0700
Message-ID: <CA+55aFw_yercy5L1Ly8t2Yh4-x=JzVMuSa7qi9ddVHQenAGBQQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 10, 2017 at 8:48 PM, Tobin C. Harding <me@tobin.cc> wrote:
>
> Add function ptr_to_id() to map an address to a unique identifier. This
> mapping is created by calling ptr_obfuscate() to hash the address. The
> hashing algorithm is carried out in two stages. First the address is
> xor'd by a random value then we multiply the xor production by a second
> random value.

So that's a fine obfuscation for normal kernel addresses.

It's also fine for testing this feature, and forcing people who
actually care about the real pointer value to look at thei rcode.

However, it's almost certainly no good for hardening.

The reasons is that it's going to be fairly trivial to just reverse
the obfuscation if you have any kind of pattern to the pointers
printed out.

And there's tons of information like that. Some code (think KASAN
reports etc) might print out addresses that increment with a fixed
offset. In other situations, NULL is going to be fairly common. In yet
other cases, you'll know specific bit patterns of the pointers (like
"I know this reports a page address, so the upper 14 bits are all set,
and the lower 12 bits are all zero").

You need just a few of those kinds of things, and you're going to
easily break the obfuscation.

A *normal* user won't bother. A kernel developer won't bother. But
somebody writing an attack would. It's an inconvenience, and maybe it
would push somebody towards an easier attack if one can be found, but
it's not really a particularly _big_ inconvenience.

So I'm absolutely ok with this patch for testing, and for finding the
places that need fixing up, but it should be clear that for real
hardening we'd need something much smarter.

                   Linus
