MIME-Version: 1.0
In-Reply-To: <CALCETrWX=GN4KoxysJwDUhYs-fu3wdJU=pzTTKgQuKwa0O2k8w@mail.gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com>
 <1510244046-3256-7-git-send-email-tixxdz@gmail.com> <CALCETrWX=GN4KoxysJwDUhYs-fu3wdJU=pzTTKgQuKwa0O2k8w@mail.gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Fri, 10 Nov 2017 11:38:00 +0100
Message-ID: <CAEiveUe5pRBConqj_QhD6Kax2rH4nAD+=7X5kWX-+C66v-kS9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v3 6/7] proc: support new 'pids=all|ptraceable' mount option
To: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LSM List <linux-security-module@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, "Tobin C. Harding" <me@tobin.cc>, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, "J. Bruce Fields" <bfields@fieldses.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Solar Designer <solar@openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 10, 2017 at 3:38 AM, Andy Lutomirski <luto@kernel.org> wrote:
> On Thu, Nov 9, 2017 at 8:14 AM, Djalal Harouni <tixxdz@gmail.com> wrote:
>> This patch introduces the new 'pids' mount option, as it was discussed
>> and suggested by Andy Lutomirski [1].
>>
>> * If 'pids=' is passed without 'newinstance' then it has no effect.
>
> Would it be safer this were an error instead?

Hm, I tend to say that you are right, but I also keep your comment
when you said that "newinstance" should be the default later and users
won't have to explicitly pass it. What you think ?

-- 
tixxdz
