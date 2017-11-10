MIME-Version: 1.0
In-Reply-To: <1510244046-3256-7-git-send-email-tixxdz@gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com> <1510244046-3256-7-git-send-email-tixxdz@gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 9 Nov 2017 18:38:34 -0800
Message-ID: <CALCETrWX=GN4KoxysJwDUhYs-fu3wdJU=pzTTKgQuKwa0O2k8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v3 6/7] proc: support new 'pids=all|ptraceable' mount option
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, me@tobin.cc, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "J. Bruce Fields" <bfields@fieldses.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Solar Designer <solar@openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 9, 2017 at 8:14 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
> This patch introduces the new 'pids' mount option, as it was discussed
> and suggested by Andy Lutomirski [1].
>
> * If 'pids=' is passed without 'newinstance' then it has no effect.

Would it be safer this were an error instead?
