Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CALCETrVFNcGtsm3N50sZRDWmBOJ3VWn=BidAOV4Q+eDwYhJ+vw@mail.gmail.com>
References: <20131003201332.GA3500@dztty> <CALCETrUOMF8MU9xpkQKYub-95fh9DAVBgPBXpAmMdmsb74HcTg@mail.gmail.com>
 <20131004085911.GA2157@dztty> <CALCETrU5vBcqCbKAh=1wWPjt6js7A4R2xtnwc3Z1Z0FRMLP1SQ@mail.gmail.com>
 <20131004182353.GA2600@dztty> <CALCETrVs2Nd82dpURQxAVetK814bAm8TvnSyA4e=YeTWxTFsmA@mail.gmail.com>
 <20131004191113.GA3916@dztty> <CALCETrVMBh0nNgpOHOMrsOjHez7NnCNbY5nHxeQ3RToP4nKO+A@mail.gmail.com>
 <20131004192712.GA4334@dztty> <CALCETrUuMRMgJ1OV3-ZRQ5wwzSQsdf9tKY9iKesk1QJPtj6-qw@mail.gmail.com>
 <20131004194142.GA4524@dztty> <CALCETrXghsx-2rK8QqgtfMaJJhkwcYgRMnqGQfKw-T3O7jBTUA@mail.gmail.com>
 <87fvsgy7cn.fsf@xmission.com> <CALCETrVFNcGtsm3N50sZRDWmBOJ3VWn=BidAOV4Q+eDwYhJ+vw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 4 Oct 2013 16:08:06 -0700
Message-ID: <CALCETrXa1uAAOM7U_Jk1APHx1aJGdJJy4ggJ9C+sn++btXX2FA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's
 opener may access task
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Djalal Harouni <tixxdz@opendz.org>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 4, 2013 at 3:59 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> I'd really like a solution where there are no read or write
> implementations in the entire kernel that check permissions.  Failing
> that, just getting it for procfs would be nice.  (uid_map, etc will
> probably need to be revoked on unshare for this to work.)

By "check permissions" I mean using anything but f_cred.

uid_map won't need any form of revoke, though -- the stuct file
already points at a particular target ns.  I wonder why the
CAP_SYS_ADMIN check is in map_write instead of open, though.

--Andy
