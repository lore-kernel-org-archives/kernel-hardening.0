Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160126171523.GA13715@ubuntumail>
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
Date: Tue, 26 Jan 2016 15:13:29 -0800
Message-ID: <CAGXu5j+kkzmnrvfOhcDfsK81bxwrgnywKQKCof+Pqjv-oVB+Kw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to
 be disabled
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 26, 2016 at 9:15 AM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Josh Boyer (jwboyer@fedoraproject.org):
>> What you're saying is true for the "oh crap" case of a new userns
>> related CVE being found.  However, there is the case where sysadmins
>> know for a fact that a set of machines should not allow user
>> namespaces to be enabled.  Currently they have 2 choices, 1) use their
>
> Hi - can you give a specific example of this?  (Where users really should
> not be able to use them - not where they might not need them)  I think
> it'll help the discussion tremendously.  Because so far the only good
> arguments I've seen have been about actual bugs in the user namespaces,
> which would not warrant a designed-in permanent disable switch.  If
> there are good use cases where such a disable switch will always be
> needed (and compiling out can't satisfy) that'd be helpful.

My example is a machine in a colo rack serving web pages. A site gets
attacked, and www-data uses user namespaces to continue their attack
to gain root privileges.

The admin of such a machine could have disabled userns months earlier
and limited the scope of the attack.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
