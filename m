MIME-Version: 1.0
References: <20180511093221.GA902@comp-core-i7-2640m-0182e6>
In-Reply-To: <20180511093221.GA902@comp-core-i7-2640m-0182e6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 11 May 2018 09:39:23 -0700
Message-ID: <CA+55aFwZK+BMsm19sK-Wmfta6PcdvW6z-ghuKsb4PAwk19nRVg@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] proc: modernize proc to support multiple private instances
Content-Type: text/plain; charset="UTF-8"
To: gladkov.alexey@gmail.com, Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Akinobu Mita <akinobu.mita@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "J. Bruce Fields" <bfields@fieldses.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Solar Designer <solar@openwall.com>, "Dmitry V. Levin" <ldv@altlinux.org>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 11, 2018 at 2:42 AM Alexey Gladkov <gladkov.alexey@gmail.com>
wrote:

> This is RFC v5 to modernize procfs and make it able to support multiple
> private instances per the same pid namespace.

So I have no big objections, but I would *really* like this to go through
Al's vfs tree.

Al? Have you looked at this series?

                  Linus
