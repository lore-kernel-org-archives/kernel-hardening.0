Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <874mdzgvw8.fsf@x220.int.ebiederm.org>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<8737tp0zhr.fsf@x220.int.ebiederm.org>
	<CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
	<CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
	<CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
	<CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
	<87bn89sbc2.fsf@x220.int.ebiederm.org>
	<CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
	<87zivtj5tv.fsf@x220.int.ebiederm.org>
	<CA+5PVA5Q0_sv5MsETa9u79MLOcYbsf-vdeEe3gdxgJ8f1KAbdQ@mail.gmail.com>
	<20160126171523.GA13715@ubuntumail>
	<CAGXu5j+kkzmnrvfOhcDfsK81bxwrgnywKQKCof+Pqjv-oVB+Kw@mail.gmail.com>
	<874mdzgvw8.fsf@x220.int.ebiederm.org>
Date: Thu, 28 Jan 2016 15:41:19 +0100
Message-ID: <CAP145pitMMCPnbyQcwrap=PgPUjcknd1Qr_Mq7XPWzkvK0dCKw@mail.gmail.com>
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to
 be disabled
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

>> The admin of such a machine could have disabled userns months earlier
>> and limited the scope of the attack.
>
> Of course for the paranoid there is already a mechanism to do this.
> /sbin/chroot.
>
> No new user namespaces are allowed to be created inside of a chroot.

Another alternative is to create a custom kernel module which will
disable the user namespace (by limiting to privileged users only, or
disabling it altogether).

IMO people tend to use distro kernels for convenience, and a
suggestion of creating a chroot dir for every service exposed to
users, or building a custom kernel module is an advice that not many
sysadmins using distro kernels would take, even if they have concerns
about the the increased attack surface enabled by CLONE_NEWUSER.

Also, I don't think the willingness to disable the feature or limit it
to the already privileged users will be something that only truly
paranoid sysadmins/users would have. We've seen a fair amount of
privilege escalation / DoS bugs that this kernel feature enabled in
the recent 18 months or so, and they still seem to be found on a
somewhat regular basis. Therefore this discussion and its outcome
might be of interest to less paranoid folk as well.

I agree with Kees that the "knob" will be mostly used by admins of
web-servers (and similar services) as a protection against privilege
escalation after getting low-priv code execution on the system.
Therefore a sysctl enabled from /etc/sysctl.conf should work well
here, even if it's set to the permissive mode by default at boot.
