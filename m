Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Jun 2016 23:01:19 -0700
Message-ID: <CALCETrWMh0+_RKV1OwwqE6s8P=fLFUYcAxvSNwDK_qB6BOBs9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Playing with virtually mapped stacks (with guard pages!)
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi all-

If you want to play with virtually mapped stacks, I have it more or
less working on x86 in a branch here:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/vmap_stack

The core bit (virtually map the stack and fix the accounting) is just
a config option, but it needs the arch to opt-in.  I suspect that
every arch will have its own set of silly issues to address to make it
work well.  For x86, the silly issues are getting the OOPS to work
right and handling some vmalloc_fault oddities to avoid panicing at
random.

--Andy
