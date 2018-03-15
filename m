MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <1521143266-31350-2-git-send-email-keescook@chromium.org>
References: <1521143266-31350-1-git-send-email-keescook@chromium.org> <1521143266-31350-2-git-send-email-keescook@chromium.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 15 Mar 2018 14:42:13 -0700
Message-ID: <CA+55aFzu+VU_FVZdbLCZttUspZdJCvBhkuo4V69H=XnqmLrpLA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kernel.h: Introduce const_max() for VLA removal
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Randy Dunlap <rdunlap@infradead.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, Ingo Molnar <mingo@kernel.org>, David Laight <David.Laight@aculab.com>, Ian Abbott <abbotti@mev.co.uk>, linux-input@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 15, 2018 at 12:47 PM, Kees Cook <keescook@chromium.org> wrote:
>
> To gain the ability to compare differing types, the arguments are
> explicitly cast to size_t.

Ugh, I really hate this.

It silently does insane things if you do

   const_max(-1,6)

and there is nothing in the name that implies that you can't use
negative constants.

                   Linus
