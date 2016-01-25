Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87bn89sbc2.fsf@x220.int.ebiederm.org>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<8737tp0zhr.fsf@x220.int.ebiederm.org>
	<CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
	<CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
	<CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
	<CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
	<87bn89sbc2.fsf@x220.int.ebiederm.org>
Date: Mon, 25 Jan 2016 14:34:32 -0800
Message-ID: <CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to be disabled
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 25, 2016 at 11:33 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Kees Cook <keescook@chromium.org> writes:
>>
>> Well, I don't know about less weird, but it would leave a unneeded
>> hole in the permission checks.
>
> To be clear the current patch has my:
>
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> The code is buggy, and poorly thought through.  Your lack of interest in
> fixing the bugs in your patch is distressing.

I'm not sure where you see me having a "lack of interest". The
existing cap-checking sysctls have a corner-case bug, which is
orthogonal to this change.

> So broken code, not willing to fix.  No. We are not merging this sysctl.

I think you're jumping to conclusions. :)

This feature is already implemented by two distros, and likely wanted
by others. We cannot ignore that. The sysctl default doesn't change
the existing behavior, so this doesn't get in your way at all. Can you
please respond to my earlier email where I rebutted each of your
arguments against it? Just saying "no" and putting words in my mouth
isn't very productive.

Andy, given your interest in this feature, and my explanation of the
CAP_SYSADMIN check, what are your thoughts?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
