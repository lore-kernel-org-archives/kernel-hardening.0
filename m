MIME-Version: 1.0
In-Reply-To: <1505159427-11747-1-git-send-email-s.mesoraca16@gmail.com>
References: <1505159427-11747-1-git-send-email-s.mesoraca16@gmail.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Tue, 26 Sep 2017 16:25:26 +0200
Message-ID: <CAJHCu1JNBOHVUhF8W6iHmQWyRib0eyE3SdbCsrRkNOTf1_XDBQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC v3 0/9] S.A.R.A. a new stacked LSM
To: kernel list <linux-kernel@vger.kernel.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey@schaufler-ca.com>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>
List-ID: <kernel-hardening.lists.openwall.com>

I've noticed that some of the latest upstream commits broke S.A.R.A.
And now it doesn't compile.
The fix is trivial (just some reordering in a function arguments' list) so
I prefer to not flood the lists with a v4 with just for 2 lines change.
For review and comments the code posted here is still valid.
For those who want to compile S.A.R.A. with the latest upstream changes
there is an always up-to-date patch available here:
https://github.com/smeso/sara/compare/master...sarav3.patch
I'm sorry for the inconvenient.

Salvatore
