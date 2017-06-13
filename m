MIME-Version: 1.0
In-Reply-To: <CAG48ez1DBG9cwGtcwKmrL9tSfi4vvNk-X07jnUmzv81RM4Po_Q@mail.gmail.com>
References: <1497286620-15027-1-git-send-email-s.mesoraca16@gmail.com>
 <1497286620-15027-2-git-send-email-s.mesoraca16@gmail.com> <CAG48ez1DBG9cwGtcwKmrL9tSfi4vvNk-X07jnUmzv81RM4Po_Q@mail.gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 13 Jun 2017 09:43:16 +0200
Message-ID: <CAJHCu1JGyW6AasQ=VSLDVv9S2u7mf9SxgGX8H7KBnjHKvfsjkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH 01/11] S.A.R.A. Documentation
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-06-12 19:49 GMT+02:00 Jann Horn <jannh@google.com>:
> On Mon, Jun 12, 2017 at 6:56 PM, Salvatore Mesoraca
> As far as I can tell, the wxprot interface in procfs, when used as
> /proc/PID/attr/sara/wxprot, actually only sets restrictions on one of the
> threads.
> The documentation doesn't seem to mention this.

Yes, you are right. I'll change it.

>> +.. [3] `saralib                <https://github.com/smeso/saralib>`_
>
> This link is broken.

Oops, the correct link is https://github.com/smeso/libsara

Thank you very much for your time.
