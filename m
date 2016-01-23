Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 23 Jan 2016 00:44:01 +0000
From: Serge Hallyn <serge.hallyn@ubuntu.com>
Message-ID: <20160123004400.GA23632@ubuntumail>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
 <1453502345-30416-3-git-send-email-keescook@chromium.org>
 <CAP145piccauJvW6JrVzxm1xM3_5xtMk_Fa+uwFx-84+dKCS0WQ@mail.gmail.com>
 <CAGXu5j+dS3nEc-9HhxBxQO0gWC-bakWxfJHzmfsVb7_AK_8+Jw@mail.gmail.com>
 <CAP145pgdjQ4ALiq0wN9s-7PP5pxfMJs5xY7rdCjtYua6guUZqg@mail.gmail.com>
 <CAGXu5jKbroEt0nO=yA4V6esKePseO75tcsK=YVy-=1NEuzwxzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jKbroEt0nO=yA4V6esKePseO75tcsK=YVy-=1NEuzwxzQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] sysctl: allow CLONE_NEWUSER to be disabled
To: Kees Cook <keescook@chromium.org>
Cc: Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Ben Hutchings <ben@decadent.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Kees Cook (keescook@chromium.org):
> On Fri, Jan 22, 2016 at 2:55 PM, Robert Święcki <robert@swiecki.net> wrote:
> > 2016-01-22 23:50 GMT+01:00 Kees Cook <keescook@chromium.org>:
> >
> >>> Seems that Debian and some older Ubuntu versions are already using
> >>>
> >>> $ sysctl -a | grep usern
> >>> kernel.unprivileged_userns_clone = 0
> >>>
> >>> Shall we be consistent wit it?
> >>
> >> Oh! I didn't see that on systems I checked. On which version did you find that?
> >
> > $ uname -a
> > Linux bc1 4.3.0-0.bpo.1-amd64 #1 SMP Debian 4.3.3-5~bpo8+1
> > (2016-01-07) x86_64 GNU/Linux
> > $ cat /etc/debian_version
> > 8.2
> 
> Ah-ha, Debian only, though it looks like this was just committed to
> the Ubuntu kernel tree too:
> 
> 
> > IIRC some older kernels delivered with Ubuntu Precise were also using
> > it (but maybe I'm mistaken)
> 
> I don't see it there.
> 
> I think my patch is more complete, but I'm happy to change the name if
> this sysctl has already started to enter the global consciousness. ;)
> 
> Serge, Ben, what do you think?
> 
> -Kees

Hey,

I had originally written this for Ubuntu when userns was still new
and not upstream.  Then we dropped it when it got upstream.

The reason we are re-adding it is because we're going to be pushing the
envelop again wrt unprivileged userns usage.  Seth has been working on
supporting mounts of fuse, for instance.  When everything is upstream,
(or we drop it :) we'll drop the patch again.

-serge
