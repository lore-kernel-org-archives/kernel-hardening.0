MIME-Version: 1.0
In-Reply-To: <CAGXu5jLM-NUZf71UzTHqRERAb6GZNO+Yi7OOrnDRuihv+m-pzw@mail.gmail.com>
References: <be5b9100-4f60-1a10-6b32-b425cb2db05e@gmail.com> <CAGXu5jLM-NUZf71UzTHqRERAb6GZNO+Yi7OOrnDRuihv+m-pzw@mail.gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Wed, 22 Nov 2017 15:41:56 -0500
Message-ID: <CA+DvKQKeDURwdCgrJ-O-WEtQpk7vJb8_0q8SYaLecp_HTtZ+6w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] a part of SLAB_FREELIST_HARDENED feature
 doesn't work well
To: Kees Cook <keescook@chromium.org>
Cc: zerons <zeronsaxm@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Alexander Popov <alex.popov@linux.com>
List-ID: <kernel-hardening.lists.openwall.com>

Also see this out-of-tree patch:

https://github.com/copperhead/linux-hardened/commit/d6aa68684a28eac7270f715ece25998b2c9804c8

It's similar to the slub redzones but designed for hardening rather
than finding bugs.

It's not great at detecting double-free without a quarantine like
KASan though. Allocations get handed out again very quickly (LIFO
policy via free lists). A quarantine could also improve
poisoning-based write-after-free detection along with providing
inherent resistance to use-after-free, etc. exploitation especially if
it's partially randomized.
