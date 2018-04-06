MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jKVKFmVN-esd5N7B-6mirZv5fm01=uOoq_02jL3idgCVw@mail.gmail.com>
References: <20180331015236.GA3852@beast> <CAGXu5jJsaB+FJJszkOwvW2VYbSHGVyTD+EE=n+k1p1Mg_wtkMw@mail.gmail.com>
 <CA+55aFxVvg=4cX6wTTVNCJMj-VzJp0KhLBY3yLP5Nd3eMXGt=w@mail.gmail.com>
 <CAGXu5j+yDnNkH2vaipGvExqqiAQLP2_SvvEtnzpobBgGvJrUAQ@mail.gmail.com>
 <CA+55aFxU66DqMtwWYh_WqXkdM-fapMyyQZSEZXVmVY=KV-7SLw@mail.gmail.com>
 <CA+55aFzN0B+ajX5ArsGYzqRMxDY26ptfTetSoYOOCVJKYHnZ7g@mail.gmail.com> <CAGXu5jKVKFmVN-esd5N7B-6mirZv5fm01=uOoq_02jL3idgCVw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 5 Apr 2018 17:52:43 -0700
Message-ID: <CAGXu5jKVGtBFP2NuPwjyJjEmUG7N4Z+6o5v6-F4ipY9yUx+XOg@mail.gmail.com>
Subject: Re: [PATCH v7] kernel.h: Retain constant expression output for max()/min()
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Martin Uecker <Martin.Uecker@med.uni-goettingen.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 5, 2018 at 3:09 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Apr 5, 2018 at 2:20 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> There may be others hiding that weren't caught by my limited build
>> testing, trhough. So please keep an eye out for build warnings.
>
> I'll spin up my full multi-arch allmodconfig builds and see if
> anything kicks out...

FWIW, nothing exploded on allmodconfig for x86_64, arm64, i386, arm,
powerpc64, s390, powerpc, mips, nor sparc64...

-Kees

-- 
Kees Cook
Pixel Security
