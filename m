MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CA+55aFxU66DqMtwWYh_WqXkdM-fapMyyQZSEZXVmVY=KV-7SLw@mail.gmail.com>
References: <20180331015236.GA3852@beast> <CAGXu5jJsaB+FJJszkOwvW2VYbSHGVyTD+EE=n+k1p1Mg_wtkMw@mail.gmail.com>
 <CA+55aFxVvg=4cX6wTTVNCJMj-VzJp0KhLBY3yLP5Nd3eMXGt=w@mail.gmail.com>
 <CAGXu5j+yDnNkH2vaipGvExqqiAQLP2_SvvEtnzpobBgGvJrUAQ@mail.gmail.com> <CA+55aFxU66DqMtwWYh_WqXkdM-fapMyyQZSEZXVmVY=KV-7SLw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Apr 2018 14:20:05 -0700
Message-ID: <CA+55aFzN0B+ajX5ArsGYzqRMxDY26ptfTetSoYOOCVJKYHnZ7g@mail.gmail.com>
Subject: Re: [PATCH v7] kernel.h: Retain constant expression output for max()/min()
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Martin Uecker <Martin.Uecker@med.uni-goettingen.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 5, 2018 at 1:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Ok, applied.

Ugh, during the merge window, we had actually grown a new example of
that "different enum types" problem:

        struct drm_prop_enum_list enum_list[max(DRM_COLOR_ENCODING_MAX,
                                                DRM_COLOR_RANGE_MAX)];

in drm_plane_create_color_properties() in the drm drm_color_mgmt.c file.

I ended up just fixing it up manually and added it to the commit. You
should double-check my change, I've pushed it out now that the build
seems ok for me.

There may be others hiding that weren't caught by my limited build
testing, trhough. So please keep an eye out for build warnings.

                   Linus
